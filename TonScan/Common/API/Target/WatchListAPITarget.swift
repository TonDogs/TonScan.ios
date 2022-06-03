import Moya

enum WatchListAPITarget {
    case get(limit: Int, offset: Int)
}

extension WatchListAPITarget: TonScanAPITarget {

    var needsAuthorization: Bool {
        return true
    }

    var path: String {
        switch self {
        case .get:
            return "watchList.get"
        }
    }

    var method: Moya.Method {
        switch self {
        case .get:
            return .get
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .get(let limit, let offset):
            return ["limit": limit, "offset": offset]
        }
    }
    
    var sampleData: Data {
        return """
        [{
            "id": 28,
            "address": {
                "raw": "Ef9VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVbxn"
            },
            "balance": "1140714966418",
            "last_transaction_time": 1651876018
        }, {
            "id": 27,
            "address": {
                "raw": "Ef8zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzM0vF"
            },
            "balance": "262404707563859847",
            "last_transaction_time": 1651876018
        }, {
            "id": 25,
            "address": {
                "raw": "EQCqJHS8A2SGvURK7mpg4KaFti1q2QQbg5l3OgRMZWINYMIx"
            },
            "balance": "249962969158",
            "last_transaction_time": 1651175313
        }, {
            "id": 23,
            "address": {
                "raw": "EQD-dkk4t7QQXdY5YiZAh_4q2Xo9f4c3Pd7qLU8vH6Np-hzc"
            },
            "balance": "8612167279",
            "last_transaction_time": 1651849862
        }, {
            "id": 18,
            "address": {
                "raw": "EQAcDW0T-pnlBx639SdeXZ0Sf1YhPDOrUsOyNoIlyzD7QXhJ"
            },
            "balance": "67108864",
            "last_transaction_time": 1651137037
        }, {
            "id": 16,
            "address": {
                "raw": "EQCpchdCzmot3jOou1bIkXlxR5ZYSryCmb1zUBk9nyqMp4qt"
            },
            "balance": "0",
            "last_transaction_time": null
        }, {
            "id": 14,
            "address": {
                "raw": "EQBtzDXKVpS4JJ5r8kJksNltoFW35eSG0p4DnWmDYC4Q-Orf"
            },
            "balance": "67108864",
            "last_transaction_time": 1651145553
        }, {
            "id": 12,
            "address": {
                "raw": "EQDCH6vT0MvVp0bBYNjoONpkgb51NMPNOJXFQWG54XoIAs5Y"
            },
            "balance": "864445633719",
            "last_transaction_time": 1651869668
        }, {
            "id": 9,
            "address": {
                "raw": "EQCtiv7PrMJImWiF2L5oJCgPnzp-VML2CAt5cbn1VsKAxLiE"
            },
            "balance": "815749591152980",
            "last_transaction_time": 1651875840
        }, {
            "id": 2,
            "address": {
                "raw": "EQCpBaPdCr7gtweoDMdH6W12Zf02KogYrgPhsGdbcHQmkVls"
            },
            "balance": "136125122",
            "last_transaction_time": 1651690950
        }]
        """.data(using: .utf8)!
    }
    
}
