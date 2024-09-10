//
//  CafeynBaseUrlHaving.swift
//  Cafeyn
//
//  Created by Azat Goktas on 09/09/2024.
//

import Foundation
import Networking

protocol CafeynBaseUrlHaving: BaseURLHaving { }

// MARK: - Default implementation

extension CafeynBaseUrlHaving {
    var baseURL: String {
        "https://b2c-api.cafeyn.co/b2c/"
    }
}
