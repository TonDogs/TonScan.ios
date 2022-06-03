import Moya

enum AddressAPITarget {
    case get(address: String, limit: Int, lt: String?, hash: String?)
    case search(address: String)
    case watch(address: String, notificationMode: String?)
    case unwatch(address: String)
    case setCustomAlias(title: String?, address: String)
}

extension AddressAPITarget: TonScanAPITarget {
    
    var needsAuthorization: Bool {
        return true
    }

    var path: String {
        switch self {
        case .get:
            return "address.get"
        case .search:
            return "address.search"
        case .watch:
            return "address.watch"
        case .unwatch:
            return "address.unwatch"
        case .setCustomAlias:
            return "address.setCustomAlias"
        }
    }

    var method: Moya.Method {
        switch self {
        case .get:
            return .get
        case .search:
            return .get
        case .watch:
            return .post
        case .unwatch:
            return .post
        case .setCustomAlias:
            return .post
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .get(let address, let limit, let lt, let hash):
            var parameters: [String: Any] = ["address": address, "limit": limit]
            parameters["lt"] = lt
            parameters["hash"] = hash
            
            return parameters
        case .search(let address):
            return ["address": address]
        case .watch(let address, let notificationMode):
            var parameters = ["address": address]
            parameters["notification_mode"] = notificationMode
            
            return parameters
        case .unwatch(let address):
            return ["address": address]
        case .setCustomAlias(let title, let address):
            var parameters = ["address": address]
            parameters["title"] = title
            
            return parameters
        }
    }
    
    var sampleData: Data {
        return """
        {
            "response": {
                "wallet": {
                    "address": {
                        "raw": "Ef8zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzM0vF"
                    },
                    "balance": "262870352270147525",
                    "state": "active"
                },
                "transactions": [{
                    "address": {
                        "raw": "Ef8zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzM0vF"
                    },
                    "utime": 1651894250,
                    "logic_time": "27707485000002",
                    "hash": "RushsS2PptP2ki2dCSVAINmc3ZLGi8tz5GFDxGMV7Ho=",
                    "fee": {
                        "total": 0,
                        "other_fee": 0,
                        "storage_fee": 0
                    },
                    "is_watching": true,
                    "messages": [{
                        "type": "in",
                        "source": {
                            "raw": "Ef8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAU"
                        },
                        "destination": {
                            "raw": "Ef8zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzM0vF"
                        },
                        "value": "3700000000",
                        "fee": {
                            "forward": 0,
                            "ihr": 0
                        },
                        "message": {
                            "type": "raw",
                            "body": ""
                        }
                    }]
                }, {
                    "address": {
                        "raw": "Ef8zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzM0vF"
                    },
                    "utime": 1651894250,
                    "logic_time": "27707485000001",
                    "hash": "HYwMzcymRrP0JZe7zIjBChhHpVBUCuZmxHSTFunMpEM=",
                    "fee": {
                        "total": 0,
                        "other_fee": 0,
                        "storage_fee": 0
                    },
                    "is_watching": true,
                    "messages": []
                }, {
                    "address": {
                        "raw": "Ef8zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzM0vF"
                    },
                    "utime": 1651894243,
                    "logic_time": "27707483000002",
                    "hash": "w2sisd94f74bPWKxGZ3H9ek29HNXgmWpILvFK9oIbqc=",
                    "fee": {
                        "total": 0,
                        "other_fee": 0,
                        "storage_fee": 0
                    },
                    "is_watching": true,
                    "messages": [{
                        "type": "in",
                        "source": {
                            "raw": "Ef8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAU"
                        },
                        "destination": {
                            "raw": "Ef8zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzM0vF"
                        },
                        "value": "2700000000",
                        "fee": {
                            "forward": 0,
                            "ihr": 0
                        },
                        "message": {
                            "type": "raw",
                            "body": ""
                        }
                    }]
                }, {
                    "address": {
                        "raw": "Ef8zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzM0vF"
                    },
                    "utime": 1651894243,
                    "logic_time": "27707483000001",
                    "hash": "R22VRerMo7+3QL6D19R2kqwMuNa0VHaa6ynHDkviMwI=",
                    "fee": {
                        "total": 0,
                        "other_fee": 0,
                        "storage_fee": 0
                    },
                    "is_watching": true,
                    "messages": []
                }, {
                    "address": {
                        "raw": "Ef8zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzM0vF"
                    },
                    "utime": 1651894240,
                    "logic_time": "27707482000002",
                    "hash": "5UcciHNx0vPSVjNN9EQMi+CVsQTd1qypQXA53QtJ8u0=",
                    "fee": {
                        "total": 0,
                        "other_fee": 0,
                        "storage_fee": 0
                    },
                    "is_watching": true,
                    "messages": [{
                        "type": "in",
                        "source": {
                            "raw": "Ef8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAU"
                        },
                        "destination": {
                            "raw": "Ef8zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzM0vF"
                        },
                        "value": "2751368044",
                        "fee": {
                            "forward": 0,
                            "ihr": 0
                        },
                        "message": {
                            "type": "raw",
                            "body": ""
                        }
                    }]
                }]
            }
        }
        """.data(using: .utf8)!
    }

}
