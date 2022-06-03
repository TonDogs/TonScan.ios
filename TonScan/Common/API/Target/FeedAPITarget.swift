import Moya

enum FeedAPITarget {
    case get(limit: Int, offset: Int, lt: String?, hash: String?)
}

extension FeedAPITarget: TonScanAPITarget {
    
    var needsAuthorization: Bool {
        return true
    }

    var path: String {
        switch self {
        case .get:
            return "feed.get"
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
        case .get(let limit, let offset, let lt, let hash):
            var parameters: [String: Any] = ["limit": limit, "offset": offset]
            parameters["lt"] = lt
            parameters["hash"] = hash
            
            return parameters
        }
    }
    
    var sampleData: Data {
        return """
        [{
            "id": 2646,
            "address": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
            "utime": 1645457626,
            "logic_time": "25685988000001",
            "hash": "o34WnC3YF4o9hp9x7KwpgmKJoeBdnAfmFqIIwZWEDJE=",
            "fee": {
                "total": 23943517,
                "other_fee": 23807000,
                "storage_fee": 136517
            },
            "messages": [{
                "id": 8943,
                "type": "in",
                "source": "",
                "destination": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "value": "0",
                "fee": {
                    "forward": 0,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "iWd+8fzq0dqPcBpcS8u81d1sNuQTKvhU+jxlpwnikjwLeAmi+NOYc9s/ialf6YWwFNqqIHNptlsM\\nBeMVU8ZABympoxdiE7EVAAAAEAEAQ7msoAA=\\n"
                }
            }, {
                "id": 8944,
                "type": "out",
                "source": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "destination": "EQBV6-c9t60Ews3ALRVldiW1Mi2urPzEuTiO9IWVkchZ02Xx",
                "value": "1000000000",
                "fee": {
                    "forward": 5364041,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "8Gx1Zw==\\n"
                }
            }]
        }, {
            "id": 2645,
            "address": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
            "utime": 1645550499,
            "logic_time": "25714872000001",
            "hash": "TOSG/HeyAFcn3F53z53OXbi5Tdrgk7V1Ftk3GemzJ48=",
            "fee": {
                "total": 5994565,
                "other_fee": 5968000,
                "storage_fee": 26565
            },
            "messages": [{
                "id": 8941,
                "type": "in",
                "source": "",
                "destination": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "value": "0",
                "fee": {
                    "forward": 0,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "H4TLxv7lcBFAOg2hSayjiV/TmA9VuJK3bhGqsRuiLe1mwwq1MsPKFEL2Fy2kKKcWvsIqi9eH2W1J\\nYjIP2//EACmpoxdiFRveAAAAEQAD\\n"
                }
            }, {
                "id": 8942,
                "type": "out",
                "source": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "destination": "EQAgsCufO6w47ZpqhBrEE37dKkoHo3KzPcKp4vW8WcRM5ZJj",
                "value": "1000000000000",
                "fee": {
                    "forward": 666672,
                    "ihr": 0
                },
                "message": {
                    "type": "text",
                    "body": "TON DOGS MINT"
                }
            }]
        }, {
            "id": 2644,
            "address": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
            "utime": 1645550547,
            "logic_time": "25714885000001",
            "hash": "vpGTdjc+NBj6iA76gvNH2xoOVAJcGbL+e8rdQeLPcfI=",
            "fee": {
                "total": 5992014,
                "other_fee": 5992000,
                "storage_fee": 14
            },
            "messages": [{
                "id": 8939,
                "type": "in",
                "source": "",
                "destination": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "value": "0",
                "fee": {
                    "forward": 0,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "sAUIWYt93ZrprkaVgV3UGeqb0SjAD0PRBgJ6HD7TL/7pWp3QbeOTkuEwOvPmU3mY7FSgU0cHnh2S\\nAV3uUKc5CimpoxdiFRwOAAAAEgAD\\n"
                }
            }, {
                "id": 8940,
                "type": "out",
                "source": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "destination": "EQAgsCufO6w47ZpqhBrEE37dKkoHo3KzPcKp4vW8WcRM5ZJj",
                "value": "1000000000000",
                "fee": {
                    "forward": 666672,
                    "ihr": 0
                },
                "message": {
                    "type": "text",
                    "body": "TON DOGS AIRDROP"
                }
            }]
        }, {
            "id": 2643,
            "address": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
            "utime": 1647292951,
            "logic_time": "26263387000003",
            "hash": "LHpbO7IM2cQzpJNnonuxXp/JHd9UmJ7Ofpm8BjiUg/w=",
            "fee": {
                "total": 1488948,
                "other_fee": 991000,
                "storage_fee": 497948
            },
            "messages": [{
                "id": 8938,
                "type": "in",
                "source": "EQCtiv7PrMJImWiF2L5oJCgPnzp-VML2CAt5cbn1VsKAxLiE",
                "destination": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "value": "36140812044",
                "fee": {
                    "forward": 666672,
                    "ihr": 0
                },
                "message": {
                    "type": "text",
                    "body": "g2UDkH3nw874T66GVwbH0tSvfYCcT4FYM"
                }
            }]
        }, {
            "id": 2642,
            "address": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
            "utime": 1647293099,
            "logic_time": "26263433000001",
            "hash": "9FqorLftFV3hUsLQGmREh/ADz78chV/EguIXGLXm+ns=",
            "fee": {
                "total": 5832043,
                "other_fee": 5832000,
                "storage_fee": 43
            },
            "messages": [{
                "id": 8936,
                "type": "in",
                "source": "",
                "destination": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "value": "0",
                "fee": {
                    "forward": 0,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "Z+RD8EHuXE90mHXaggf+71iMgDmpqjwSsL3VzLMYM7+/oQBldxNtpUBNTI7apchMm0UfpFW0ORnm\\nC0kGLkAJBCmpoxdiL7LmAAAAEwAD\\n"
                }
            }, {
                "id": 8937,
                "type": "out",
                "source": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "destination": "EQAng7oEOweSkeVEfbXd4k6ON17Gvh8i8wGzfFK5xnu_FtM6",
                "value": "10000000000",
                "fee": {
                    "forward": 666672,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": ""
                }
            }]
        }, {
            "id": 2641,
            "address": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
            "utime": 1647294099,
            "logic_time": "26263756000001",
            "hash": "IuAR+JHUkipuKvda0nVXD2+0nwohLZkFR4+BFj3fw0M=",
            "fee": {
                "total": 24407286,
                "other_fee": 24407000,
                "storage_fee": 286
            },
            "messages": [{
                "id": 8934,
                "type": "in",
                "source": "",
                "destination": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "value": "0",
                "fee": {
                    "forward": 0,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "w+2atf5qYwKiCT8trBrWXoyKTAjIcj7NCK8Syr3aTle8ksJESIdyGTZt46lxW5kn5Z0dhR5DsAvk\\nySJLLW1LBSmpoxdiL7bNAAAAFAEASy0F4AA=\\n"
                }
            }, {
                "id": 8935,
                "type": "out",
                "source": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "destination": "EQAWHRN4JIPqmEUl8ccX5q99BHi9I2H6MkuJwA-yMR1XidvK",
                "value": "3000000000",
                "fee": {
                    "forward": 5364041,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "8Gx1Zw==\\n"
                }
            }]
        }, {
            "id": 2640,
            "address": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
            "utime": 1647464610,
            "logic_time": "26317404000001",
            "hash": "x1K1xPTEgnQfW/o/CyXLo9BASMWaTOlYwysPc4L4Ap4=",
            "fee": {
                "total": 24459039,
                "other_fee": 24407000,
                "storage_fee": 52039
            },
            "messages": [{
                "id": 8932,
                "type": "in",
                "source": "",
                "destination": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "value": "0",
                "fee": {
                    "forward": 0,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "VMTMAsC4LYxIuOkntppn/9FwFTpZUMftE4nfgGWNISMwVVoV53PTI4LRNyPTIjRp03qJEDCjZWHb\\niR1m7RySDimpoxdiMlDcAAAAFQEAR3NZQAA=\\n"
                }
            }, {
                "id": 8933,
                "type": "out",
                "source": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "destination": "EQAtrchuwcmaGVO9mJgtomIs03zqBtRS1hEJQ6Z5Kr9FiIpY",
                "value": "2000000000",
                "fee": {
                    "forward": 5364041,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "8Gx1Zw==\\n"
                }
            }]
        }, {
            "id": 2639,
            "address": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
            "utime": 1648087439,
            "logic_time": "26513327000003",
            "hash": "oFZPjFCccm2LGRd7AXJodelor6w4o3uWkUg5Y51x7B0=",
            "fee": {
                "total": 5822085,
                "other_fee": 5620000,
                "storage_fee": 202085
            },
            "messages": [{
                "id": 8930,
                "type": "in",
                "source": "EQBV6-c9t60Ews3ALRVldiW1Mi2urPzEuTiO9IWVkchZ02Xx",
                "destination": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "value": "16000000",
                "fee": {
                    "forward": 666672,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "cGx1ZwAAGB0dcAnBQ7msoAA=\\n"
                }
            }, {
                "id": 8931,
                "type": "out",
                "source": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "destination": "EQBV6-c9t60Ews3ALRVldiW1Mi2urPzEuTiO9IWVkchZ02Xx",
                "value": "1010380000",
                "fee": {
                    "forward": 666672,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "8Gx1ZwAAGB0dcAnB\\n"
                }
            }]
        }, {
            "id": 2638,
            "address": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
            "utime": 1648232571,
            "logic_time": "26558672000003",
            "hash": "+wk+ZbCUGs7ULWmBu2eRctesVZpn23JbFojMtyERUDQ=",
            "fee": {
                "total": 1038090,
                "other_fee": 991000,
                "storage_fee": 47090
            },
            "messages": [{
                "id": 8929,
                "type": "in",
                "source": "EQDCH6vT0MvVp0bBYNjoONpkgb51NMPNOJXFQWG54XoIAs5Y",
                "destination": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "value": "1266000000",
                "fee": {
                    "forward": 666672,
                    "ihr": 0
                },
                "message": {
                    "type": "text",
                    "body": "@StakingCATBot"
                }
            }]
        }, {
            "id": 2637,
            "address": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
            "utime": 1648989952,
            "logic_time": "26796024000001",
            "hash": "J6RlierPcN6rDYL2R1pyZ41djj33rJDmergG19ua6f0=",
            "fee": {
                "total": 6069743,
                "other_fee": 5824000,
                "storage_fee": 245743
            },
            "messages": [{
                "id": 8927,
                "type": "in",
                "source": "",
                "destination": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "value": "0",
                "fee": {
                    "forward": 0,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "XegTkZr/VQi141qiPzKl+kK8yGUgnj4/C9JJ9A2ADygrdL946VpWE+F5yVyViIZ4NMgOsRjdeOVg\\nXFqKb3++AympoxdiSZc4AAAAFgAD\\n"
                }
            }, {
                "id": 8928,
                "type": "out",
                "source": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "destination": "EQC5xlN-2amzpfN1I5wRN-6iwdaUcvHe5iGwRpUzGy_8CEOz",
                "value": "2000000000",
                "fee": {
                    "forward": 666672,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": ""
                }
            }]
        }, {
            "id": 2636,
            "address": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
            "utime": 1648994510,
            "logic_time": "26797432000001",
            "hash": "1kVukWMfRSyKhLkZwdZMOISLf8C01G7tK/0hJxW3PHs=",
            "fee": {
                "total": 5825479,
                "other_fee": 5824000,
                "storage_fee": 1479
            },
            "messages": [{
                "id": 8925,
                "type": "in",
                "source": "",
                "destination": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "value": "0",
                "fee": {
                    "forward": 0,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "puNFgOazYOJsTlRQVP9fQEUPi6tN6Jpc//CTk8ZU0qXR5F0ZNs4XJJHD1Om7nzPUUYewdoi1pC17\\nUjAEBuUfBSmpoxdiSakIAAAAFwAD\\n"
                }
            }, {
                "id": 8926,
                "type": "out",
                "source": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "destination": "EQAAy1BC4aCL2e7HsyPaFQ89BWDcNVY9y53OD_bRPAt6oSK0",
                "value": "2000000000",
                "fee": {
                    "forward": 666672,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": ""
                }
            }]
        }, {
            "id": 2635,
            "address": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
            "utime": 1648997711,
            "logic_time": "26798446000001",
            "hash": "3lGRZacvWJkwfxOZMJVldgtnCIW90Cv4+xLYzYnk5+w=",
            "fee": {
                "total": 5825039,
                "other_fee": 5824000,
                "storage_fee": 1039
            },
            "messages": [{
                "id": 8923,
                "type": "in",
                "source": "",
                "destination": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "value": "0",
                "fee": {
                    "forward": 0,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "4TSMRSwsMVZjML6kTZdQ8O2qI4NizOH0zkkwA6RQMIJHpH8YDxhX3x69fDM7Nn0hWndc1VWyrtmt\\nADKlLF+tACmpoxdiSbWIAAAAGAAD\\n"
                }
            }, {
                "id": 8924,
                "type": "out",
                "source": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "destination": "EQAHu-dS9ZZIriydwYQ2nrtbvqdhxhyh6_SnZF4yE8J8M3fJ",
                "value": "2000000000",
                "fee": {
                    "forward": 666672,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": ""
                }
            }]
        }, {
            "id": 2634,
            "address": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
            "utime": 1648998021,
            "logic_time": "26798540000001",
            "hash": "BRfLKJXGQPonueR/Dr6KnyGmRD8XBeGGffs+ZSwKvR0=",
            "fee": {
                "total": 5824101,
                "other_fee": 5824000,
                "storage_fee": 101
            },
            "messages": [{
                "id": 8921,
                "type": "in",
                "source": "",
                "destination": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "value": "0",
                "fee": {
                    "forward": 0,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "9XaURq4jqpSQq2VHOZhBwdDsOnPfi5yjVORTvukgqjIQoggYeTMNbJDvC+k2CG4cyZ9PjmNwBuK7\\nRDFdlXPQCSmpoxdiSbbAAAAAGQAD\\n"
                }
            }, {
                "id": 8922,
                "type": "out",
                "source": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "destination": "EQAHu-dS9ZZIriydwYQ2nrtbvqdhxhyh6_SnZF4yE8J8M3fJ",
                "value": "1000000000",
                "fee": {
                    "forward": 666672,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": ""
                }
            }]
        }, {
            "id": 2633,
            "address": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
            "utime": 1648998021,
            "logic_time": "26798540000005",
            "hash": "xs1vqgYLPQ3DxsWvcYq5L0pvDIOJAv1HhiRJ+XPzqcs=",
            "fee": {
                "total": 775000,
                "other_fee": 775000,
                "storage_fee": 0
            },
            "messages": [{
                "id": 8920,
                "type": "in",
                "source": "EQAHu-dS9ZZIriydwYQ2nrtbvqdhxhyh6_SnZF4yE8J8M3fJ",
                "destination": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "value": "2000000000",
                "fee": {
                    "forward": 666672,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": ""
                }
            }]
        }, {
            "id": 2632,
            "address": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
            "utime": 1649008423,
            "logic_time": "26801838000003",
            "hash": "6ORdtj22rMu318qyXRbZk72UmYwVCr2clsD5cb+IHxU=",
            "fee": {
                "total": 994376,
                "other_fee": 991000,
                "storage_fee": 3376
            },
            "messages": [{
                "id": 8919,
                "type": "in",
                "source": "EQDCH6vT0MvVp0bBYNjoONpkgb51NMPNOJXFQWG54XoIAs5Y",
                "destination": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "value": "90256100000",
                "fee": {
                    "forward": 666672,
                    "ihr": 0
                },
                "message": {
                    "type": "text",
                    "body": "@StakingCATBot"
                }
            }]
        }, {
            "id": 2631,
            "address": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
            "utime": 1649923914,
            "logic_time": "27091186000003",
            "hash": "cS6h7HJC6U6qaapeZ7CzOnwwB+K6FNE4LTGj0F3eM10=",
            "fee": {
                "total": 6117043,
                "other_fee": 5820000,
                "storage_fee": 297043
            },
            "messages": [{
                "id": 8917,
                "type": "in",
                "source": "EQAWHRN4JIPqmEUl8ccX5q99BHi9I2H6MkuJwA-yMR1XidvK",
                "destination": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "value": "16000000",
                "fee": {
                    "forward": 666672,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "cGx1ZwAAGKOohKCBSy0F4AA=\\n"
                }
            }, {
                "id": 8918,
                "type": "out",
                "source": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "destination": "EQAWHRN4JIPqmEUl8ccX5q99BHi9I2H6MkuJwA-yMR1XidvK",
                "value": "3010180000",
                "fee": {
                    "forward": 666672,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "8Gx1ZwAAGKOohKCB\\n"
                }
            }]
        }, {
            "id": 2630,
            "address": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
            "utime": 1650060117,
            "logic_time": "27134281000003",
            "hash": "FTEtP0ygGi+R5Vu6xMNLtxxVf5q/OIezaU795d75+Xs=",
            "fee": {
                "total": 5764193,
                "other_fee": 5720000,
                "storage_fee": 44193
            },
            "messages": [{
                "id": 8915,
                "type": "in",
                "source": "EQAtrchuwcmaGVO9mJgtomIs03zqBtRS1hEJQ6Z5Kr9FiIpY",
                "destination": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "value": "16000000",
                "fee": {
                    "forward": 666672,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "cGx1ZwAAGK2xLiRBR3NZQAA=\\n"
                }
            }, {
                "id": 8916,
                "type": "out",
                "source": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "destination": "EQAtrchuwcmaGVO9mJgtomIs03zqBtRS1hEJQ6Z5Kr9FiIpY",
                "value": "2010280000",
                "fee": {
                    "forward": 666672,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "8Gx1ZwAAGK2xLiRB\\n"
                }
            }]
        }, {
            "id": 2629,
            "address": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
            "utime": 1650130976,
            "logic_time": "27156605000001",
            "hash": "j9UKpzRNigAsN+MKAMAOHPb2q48g9b8gR5uGH2G0jW0=",
            "fee": {
                "total": 9261992,
                "other_fee": 9239000,
                "storage_fee": 22992
            },
            "messages": [{
                "id": 8913,
                "type": "in",
                "source": "",
                "destination": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "value": "0",
                "fee": {
                    "forward": 0,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "OwPGcUa6lhMZc4+V6dv+aAdBiZyfqOrxBhdoGzSek8vh8ewq88HVUYfgLba1M67EQh8Ppptu4Hd6\\nlWWPnUIjCimpoxdiWwBZAAAAGgMAVevnPbetBMLNwC0VZXYltTItrqz8xLk4jvSFlZHIWdNAX14Q\\nAAAAAAAAAAAA\\n"
                }
            }, {
                "id": 8914,
                "type": "out",
                "source": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "destination": "EQBV6-c9t60Ews3ALRVldiW1Mi2urPzEuTiO9IWVkchZ02Xx",
                "value": "100000000",
                "fee": {
                    "forward": 666672,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "ZHN0cgAAAAAAAAAA\\n"
                }
            }]
        }, {
            "id": 2628,
            "address": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
            "utime": 1650130997,
            "logic_time": "27156612000001",
            "hash": "W2gWluged4jLozqL/Ew9BFq2O4d2U89e8d4znwpZnKE=",
            "fee": {
                "total": 9839007,
                "other_fee": 9839000,
                "storage_fee": 7
            },
            "messages": [{
                "id": 8911,
                "type": "in",
                "source": "",
                "destination": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "value": "0",
                "fee": {
                    "forward": 0,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "bth+pvmfNeA427SHGMRZ0KOPLO1B502DzJCmys7NDvW3sRJlGNAWw/c516tGDo7fKpSnAYgaJJh0\\nVto/U0CLBCmpoxdiWwBwAAAAGwMAEvydFktrW9fyRUeoibGEuljqy2TvpMw4aAjTLHCF5H5AX14Q\\nAAAAAAAAAAAA\\n"
                }
            }, {
                "id": 8912,
                "type": "out",
                "source": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "destination": "EQAS_J0WS2tb1_JFR6iJsYS6WOrLZO-kzDhoCNMscIXkfkBk",
                "value": "100000000",
                "fee": {
                    "forward": 666672,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "ZHN0cgAAAAAAAAAA\\n"
                }
            }]
        }, {
            "id": 2627,
            "address": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
            "utime": 1650131015,
            "logic_time": "27156615000001",
            "hash": "+hZ9nRkqinXFxqMTC3ENPrAkOWoYnvuTt8/hrBGNRr0=",
            "fee": {
                "total": 9239006,
                "other_fee": 9239000,
                "storage_fee": 6
            },
            "messages": [{
                "id": 8909,
                "type": "in",
                "source": "",
                "destination": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "value": "0",
                "fee": {
                    "forward": 0,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "A/J30uzEIyu8g2Nu+i5mKJDDN+Gg+n99A1SAuoIat5AtJNHhZJ3Mlu95+ZbJ56MdNqgS8icYpRf0\\nouoYYkRhBimpoxdiWwB6AAAAHAMALa3IbsHJmhlTvZiYLaJiLNN86gbUUtYRCUOmeSq/RYhAX14Q\\nAAAAAAAAAAAA\\n"
                }
            }, {
                "id": 8910,
                "type": "out",
                "source": "EQBKCMGcAoyyG85L3SIakVRLMfwhp7-xA13jTWAYO1jgpb81",
                "destination": "EQAtrchuwcmaGVO9mJgtomIs03zqBtRS1hEJQ6Z5Kr9FiIpY",
                "value": "100000000",
                "fee": {
                    "forward": 666672,
                    "ihr": 0
                },
                "message": {
                    "type": "raw",
                    "body": "ZHN0cgAAAAAAAAAA\\n"
                }
            }]
        }]
        """.data(using: .utf8)!
    }

}
