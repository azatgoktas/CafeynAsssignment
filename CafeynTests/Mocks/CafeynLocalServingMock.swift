//
//  CafeynLocalServingMock.swift
//  CafeynTests
//
//  Created by Azat Goktas on 10/09/2024.
//

import Foundation
@testable import Cafeyn

class CafeynLocalServingMock: CafeynLocalServing {
    var savedFavorites: [String] = []

    func saveFavorites(_ topics: [String]) {
        savedFavorites = topics
    }

    func getFavorites() -> [String] {
        return savedFavorites
    }
}
