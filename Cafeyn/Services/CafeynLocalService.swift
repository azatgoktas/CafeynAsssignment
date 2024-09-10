//
//  CafeynLocalService.swift
//  Cafeyn
//
//  Created by Azat Goktas on 09/09/2024.
//

import Foundation

protocol CafeynLocalServing {
    func getFavorites() -> [CafeynTopic]
    func saveFavorites(_ favorites: [CafeynTopic])
}

final class CafeynLocalService: CafeynLocalServing {
    private let favoritesKey = "favorites"

    func saveFavorites(_ favorites: [CafeynTopic]) {
        do {
            let encodedData = try JSONEncoder().encode(favorites)
            UserDefaults.standard.set(encodedData, forKey: favoritesKey)
        } catch {
            print("Error encoding favorites: \(error)")
        }
    }

    func getFavorites() -> [CafeynTopic] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey) else { return [] }
        do {
            let favorites = try JSONDecoder().decode([CafeynTopic].self, from: data)
            return favorites
        } catch {
            print("Error decoding favorites: \(error)")
            return []
        }
    }
}
