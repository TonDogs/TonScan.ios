import Foundation

extension UserDefaults {
    
    var accountId: Int? {
        get {
            return object(forKey: #function) as? Int
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
    var accessToken: String? {
        get {
            return string(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
    var isSubsribed: Bool {
        get {
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
    var isTrialPeriod: Bool {
        get {
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
    var playerGender: Int? {
        get {
            return object(forKey: #function) as? Int
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
    var playerBackgroundMix: String? {
        get {
            return object(forKey: #function) as? String
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
    var playerTactility: Int? {
        get {
            return object(forKey: #function) as? Int
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
    var backgroundMixerVolume: Float? {
        get {
            return object(forKey: #function) as? Float
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
    var affirmationMode: String? {
        get {
            return object(forKey: #function) as? String
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
    var affirmationListenCount: Int {
        get {
            return integer(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
    var courseLikeCount: Int {
        get {
            return integer(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
    var affirmationOnboardingSeenCount: Int {
        get {
            return integer(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
    var profileAppStoreReviewClicked: Bool {
        get {
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
    var profileNotificationsClicked: Bool {
        get {
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
    var affirmationFeedSwipeTutorialViewed: Bool {
        get {
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
    // MARK: - Development
    
    var developerAPIURL: String? {
        get {
            return string(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
}
