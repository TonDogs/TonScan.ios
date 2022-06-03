import Moya

private let defaultDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    return decoder
}()

extension Response {
    
    func decode<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = defaultDecoder, failsOnEmptyData: Bool = true) throws -> D {
        return try map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)
    }
    
    func decodeIfPresent<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = defaultDecoder, failsOnEmptyData: Bool = true) throws -> D? {
        guard let jsonDictionary = try mapJSON() as? NSDictionary, let keyPath = keyPath, jsonDictionary.value(forKey: keyPath) != nil else {
            return nil
        }
        return try map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)
    }
    
    /// Maps data received from the signal into a Decodable object.
    ///
    /// - parameter atKeyPath: Optional key path at which to parse object.
    /// - parameter using: A `JSONDecoder` instance which is used to decode data to an object.
    func decode<D: Decodable>(_ type: D.Type, using decoder: JSONDecoder = defaultDecoder, failsOnEmptyData: Bool = true, atKeyPaths keyPaths: String...) throws -> D {
        let serializeToData: (Any) throws -> Data? = { (jsonObject) in
            guard JSONSerialization.isValidJSONObject(jsonObject) else {
                return nil
            }
            do {
                return try JSONSerialization.data(withJSONObject: jsonObject)
            } catch {
                throw MoyaError.jsonMapping(self)
            }
        }
        let jsonData: Data
        keyPathCheck: if keyPaths.count > 0 {
            var extractedJSONObject = try mapJSON(failsOnEmptyData: failsOnEmptyData) as? NSDictionary
            for (index, keyPath) in keyPaths.enumerated() {
                if index == keyPaths.count - 1, let value = extractedJSONObject?.value(forKey: keyPath) as? D {
                    return value
                }
                extractedJSONObject = extractedJSONObject?.value(forKey: keyPath) as? NSDictionary
            }
            guard let jsonObject = extractedJSONObject else {
                if failsOnEmptyData {
                    throw MoyaError.jsonMapping(self)
                } else {
                    jsonData = data
                    break keyPathCheck
                }
            }

            if let data = try serializeToData(jsonObject) {
                jsonData = data
            } else {
                let wrappedJsonObject = ["value": jsonObject]
                let wrappedJsonData: Data
                if let data = try serializeToData(wrappedJsonObject) {
                    wrappedJsonData = data
                } else {
                    throw MoyaError.jsonMapping(self)
                }
                do {
                    return try decoder.decode(DecodableWrapper<D>.self, from: wrappedJsonData).value
                } catch let error {
                    throw MoyaError.objectMapping(error, self)
                }
            }
        } else {
            jsonData = data
        }
        do {
            if jsonData.count < 1 && !failsOnEmptyData {
                if let emptyJSONObjectData = "{}".data(using: .utf8), let emptyDecodableValue = try? decoder.decode(D.self, from: emptyJSONObjectData) {
                    return emptyDecodableValue
                } else if let emptyJSONArrayData = "[{}]".data(using: .utf8), let emptyDecodableValue = try? decoder.decode(D.self, from: emptyJSONArrayData) {
                    return emptyDecodableValue
                }
            }
            return try decoder.decode(D.self, from: jsonData)
        } catch let error {
            throw MoyaError.objectMapping(error, self)
        }
    }
    
    private struct DecodableWrapper<T: Decodable>: Decodable {
        let value: T
    }
    
}
