//
//  TopicPresnetation.swift
//  Cafeyn
//
//  Created by Azat Goktas on 09/09/2024.
//

import Foundation

final class TopicPresnetation: Equatable {
    let id: String
    let name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    static func == (lhs: TopicPresnetation, rhs: TopicPresnetation) -> Bool {
        return lhs.id == rhs.id
    }
}
