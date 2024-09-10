//
//  CafeynLocalServingMock.swift
//  CafeynTests
//
//  Created by Azat Goktas on 10/09/2024.
//

import Foundation
@testable import Cafeyn

class CafeynLocalServingMock: CafeynLocalServing {
    var savedFavorites: [CafeynTopic] = []

    func saveFavorites(_ topics: [CafeynTopic]) {
        savedFavorites = topics
    }

    func getFavorites() -> [CafeynTopic] {
        return savedFavorites
    }
}
