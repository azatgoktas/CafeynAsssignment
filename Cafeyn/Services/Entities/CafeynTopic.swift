//
//  CafeynTopic.swift
//  Cafeyn
//
//  Created by Azat Goktas on 09/09/2024.
//

import Foundation

struct CafeynTopic: Codable {
    let id: String
    let name: CafeynTopicName
    let subTopics: [CafeynTopic]?
}

struct CafeynTopicName: Codable {
    let raw: String
}
