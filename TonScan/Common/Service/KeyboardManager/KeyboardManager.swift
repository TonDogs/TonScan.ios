import UIKit

public enum KeyboardEvent {
    
    /// Event raised by UIKit's `.UIKeyboardWillShow`.
    case willShow

    /// Event raised by UIKit's `.UIKeyboardDidShow`.
    case didShow

    /// Event raised by UIKit's `.UIKeyboardWillShow`.
    case willHide

    /// Event raised by UIKit's `.UIKeyboardDidHide`.
    case didHide

    /// Event raised by UIKit's `.UIKeyboardWillChangeFrame`.
    case willChangeFrame

    /// Event raised by UIKit's `.UIKeyboardDidChangeFrame`.
    case didChangeFrame

    /// Non-keyboard based event raised by UIKit
    case unknown

}

/// An object containing the key animation properties from NSNotification
public struct KeyboardNotification {

    // MARK: - Properties

    /// The event that triggered the transition
    public let event: KeyboardEvent

    /// The animation length the keyboards transition
    public let timeInterval: TimeInterval

    /// The animation properties of the keyboards transition
    public let animationOptions: UIView.AnimationOptions

    /// iPad supports split-screen apps, this indicates if the notification was for the current app
    public let isForCurrentApp: Bool

    /// The keyboards frame at the start of its transition
    public var startFrame: CGRect

    /// The keyboards frame at the beginning of its transition
    public var endFrame: CGRect

    /// Requires that the `NSNotification` is based on a `UIKeyboard...` event
    ///
    /// - Parameter notification: `KeyboardNotification`
    public init?(from notification: NSNotification) {
        guard notification.event != .unknown else { return nil }
        self.event = notification.event
        self.timeInterval = notification.timeInterval ?? 0.25
        self.animationOptions = notification.animationOptions
        self.isForCurrentApp = notification.isForCurrentApp ?? true
        self.startFrame = notification.startFrame ?? .zero
        self.endFrame = notification.endFrame ?? .zero
    }

}

internal extension NSNotification {

    var event: KeyboardEvent {
        switch self.name {
        case UIResponder.keyboardWillShowNotification:
            return .willShow
        case UIResponder.keyboardDidShowNotification:
            return .didShow
        case UIResponder.keyboardWillHideNotification:
            return .willHide
        case UIResponder.keyboardDidHideNotification:
            return .didHide
        case UIResponder.keyboardWillChangeFrameNotification:
            return .willChangeFrame
        case UIResponder.keyboardDidChangeFrameNotification:
            return .didChangeFrame
        default:
            return .unknown
        }
    }

    var timeInterval: TimeInterval? {
        guard let value = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return nil }
        return TimeInterval(truncating: value)
    }

    var animationCurve: UIView.AnimationCurve? {
        guard let index = (userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue else { return nil }
        guard index >= 0 && index <= 3 else { return .linear }
        return UIView.AnimationCurve.init(rawValue: index) ?? .linear
    }

    var animationOptions: UIView.AnimationOptions {
        guard let curve = animationCurve else { return [] }
        switch curve {
        case .easeIn:
            return .curveEaseIn
        case .easeOut:
            return .curveEaseOut
        case .easeInOut:
            return .curveEaseInOut
        case .linear:
            return .curveLinear
        @unknown default:
            return .curveLinear
        }
    }

    var startFrame: CGRect? {
        return (userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
    }

    var endFrame: CGRect? {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }

    var isForCurrentApp: Bool? {
        return (userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue
    }

}

/// An object that observes keyboard notifications such that event callbacks can be set for each notification
open class KeyboardManager: NSObject {
    
    /// A callback that passes a `KeyboardNotification` as an input
    public typealias EventCallback = (KeyboardNotification)->Void
    
    // MARK: - Properties [Public]
    
    /// A weak reference to a view bounded to the top of the keyboard to act as an `InputAccessoryView`
    /// but kept within the bounds of the `UIViewController`s view
    open weak var inputAccessoryView: UIView?
    
    /// A flag that indicates if a portion of the keyboard is visible on the screen
    private(set) public var isKeyboardHidden: Bool = true
    
    // MARK: - Properties [Private]
    
    /// The `EventCallback` actions for each `KeyboardEvent`. Default value is EMPTY
    private var callbacks: [KeyboardEvent: EventCallback] = [:]

    /// A cached notification used as a starting point when a user dragging the `scrollView` down
    /// to interactively dismiss the keyboard
    private var cachedNotification: KeyboardNotification?
    
    // MARK: - Initialization
    
    /// Creates a `KeyboardManager` object that observes the state of the keyboard
    public override init() {
        super.init()
        addObservers()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - De-Initialization
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Keyboard Observer
    
    /// Add an observer for each keyboard notification
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide(notification:)),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidChangeFrame(notification:)),
                                               name: UIResponder.keyboardDidChangeFrameNotification,
                                               object: nil)
    }
    
    // MARK: - Mutate Callback Dictionary
    
    /// Sets the `EventCallback` for a `KeyboardEvent`
    ///
    /// - Parameters:
    ///   - event: KeyboardEvent
    ///   - callback: EventCallback
    /// - Returns: Self
    @discardableResult
    open func on(event: KeyboardEvent, do callback: EventCallback?) -> Self {
        callbacks[event] = callback
        return self
    }
    
    // MARK: - Keyboard Notifications
    
    /// An observer method called last in the lifecycle of a keyboard becoming visible
    ///
    /// - Parameter notification: NSNotification
    @objc
    open func keyboardDidShow(notification: NSNotification) {
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.didShow]?(keyboardNotification)
    }
    
    /// An observer method called last in the lifecycle of a keyboard becoming hidden
    ///
    /// - Parameter notification: NSNotification
    @objc
    open func keyboardDidHide(notification: NSNotification) {
        isKeyboardHidden = true
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.didHide]?(keyboardNotification)
    }
    
    /// An observer method called third in the lifecycle of a keyboard becoming visible/hidden
    ///
    /// - Parameter notification: NSNotification
    @objc
    open func keyboardDidChangeFrame(notification: NSNotification) {
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.didChangeFrame]?(keyboardNotification)
        cachedNotification = keyboardNotification
    }
    
    /// An observer method called first in the lifecycle of a keyboard becoming visible/hidden
    ///
    /// - Parameter notification: NSNotification
    @objc
    open func keyboardWillChangeFrame(notification: NSNotification) {
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.willChangeFrame]?(keyboardNotification)
        cachedNotification = keyboardNotification
    }
    
    /// An observer method called second in the lifecycle of a keyboard becoming visible
    ///
    /// - Parameter notification: NSNotification
    @objc
    open func keyboardWillShow(notification: NSNotification) {
        isKeyboardHidden = false
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.willShow]?(keyboardNotification)
    }
    
    /// An observer method called second in the lifecycle of a keyboard becoming hidden
    ///
    /// - Parameter notification: NSNotification
    @objc
    open func keyboardWillHide(notification: NSNotification) {
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.willHide]?(keyboardNotification)
    }
    
    // MARK: - Helper Methods
    
    private func animateAlongside(_ notification: KeyboardNotification, animations: @escaping ()->Void) {
        UIView.animate(withDuration: notification.timeInterval, delay: 0, options: [notification.animationOptions, .allowAnimatedContent, .beginFromCurrentState], animations: animations, completion: nil)
    }
    
}
