//
//  CafeynLocalService.swift
//  Cafeyn
//
//  Created by Azat Goktas on 09/09/2024.
//

import Foundation

protocol CafeynLocalServing {
    func getFavorites() -> [String]
    func saveFavorites(_ favorites: [String])
}

final class CafeynLocalService: CafeynLocalServing {
    private let favoritesKey = "favorites"
    private let userDefaults = UserDefaults.standard

    func saveFavorites(_ ids: [String]) {
        userDefaults.setValue(ids, forKey: favoritesKey)
    }

    func getFavorites() -> [String] {
        let favorites = userDefaults.value(forKey: favoritesKey) as? [String] ?? []
        return favorites
    }
}
