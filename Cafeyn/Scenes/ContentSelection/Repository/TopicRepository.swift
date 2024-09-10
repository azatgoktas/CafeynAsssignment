//
//  TopicRepository.swift
//  Cafeyn
//
//  Created by Azat Goktas on 09/09/2024.
//

import Foundation

protocol TopicRepositoryProtocol {
    func getTopics() async -> Result<ContentSelectionPresentation, Error>
    func saveFavorites(presentations: [TopicPresnetation])
}

final class TopicRepository: TopicRepositoryProtocol {
    let apiService: CafeynServing
    let localService: CafeynLocalServing
    var topics: [CafeynTopic] = []

    init(apiService: CafeynServing, localService: CafeynLocalServing) {
        self.apiService = apiService
        self.localService = localService
    }

    func getTopics() async -> Result<ContentSelectionPresentation, Error> {
        let result = await apiService.getTopics()

        switch result {
        case .success(let topics):
            self.topics = topics.flatMap { [$0] + ($0.subTopics ?? []) }
            let favorites = getFavorites()
            var favoriteTopics = [CafeynTopic]()
            for favorite in favorites {
                if let favTopic = topics.first(where: { $0.id == favorite }) {
                    favoriteTopics.append(favTopic)
                }
            }
            let allTopicsExceptFavorites = topics.filter { topic in !favoriteTopics.contains(where: { $0.id == topic.id }) }
            let presentation = ContentSelectionPresentation(
                selectedTopics: map(favoriteTopics),
                topics: map(allTopicsExceptFavorites),
                originalPositionedTopics: map(topics)
            )
            return .success(presentation)
        case .failure(let error):
            return .failure(error)
        }
    }

    func saveFavorites(presentations: [TopicPresnetation]) {
        var favorites = [String]()
        for presentation in presentations {
            for topic in topics {
                if topic.id == presentation.id {
                    favorites.append(topic.id)
                }
            }
        }
        localService.saveFavorites(favorites)
    }

    func getFavorites() -> [String] {
        localService.getFavorites()
    }
}

private extension TopicRepository {
    func map(_ topics: [CafeynTopic]) -> [TopicPresnetation] {
            topics.map { TopicPresnetation(id: $0.id, name: $0.name.raw) }
    }
}
