//
//  ContentSelectionPresentation.swift
//  Cafeyn
//
//  Created by Azat Goktas on 09/09/2024.
//

import Foundation

final class ContentSelectionPresentation: Equatable {
    var selectedTopics: [TopicPresnetation] = []
    var topics: [TopicPresnetation] = []
    var originalPositionedTopics: [TopicPresnetation] = []

    init(
        selectedTopics: [TopicPresnetation] = [],
        topics: [TopicPresnetation],
        originalPositionedTopics: [TopicPresnetation]
    ) {
        self.selectedTopics = selectedTopics
        self.topics = topics
        self.originalPositionedTopics = originalPositionedTopics
    }

    static func == (lhs: ContentSelectionPresentation, rhs: ContentSelectionPresentation) -> Bool {
        return lhs.selectedTopics == rhs.selectedTopics && lhs.topics == rhs.topics
    }
}
