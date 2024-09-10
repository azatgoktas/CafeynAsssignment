//
//  TopicRepository.swift
//  Cafeyn
//
//  Created by Azat Goktas on 09/09/2024.
//

import Foundation

protocol TopicRepositoryProtocol {
    func getTopics() async -> Result<ContentSelectionPresentation, Error>
    func saveFavorites(presentations: [TopicPresnetation]) async
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
            print(topics)
            let favorites = getFavorites()
            let allTopicsExceptFavorites = topics.filter { topic in !favorites.contains(where: { $0.id == topic.id }) }
            let presentation = ContentSelectionPresentation(
                selectedTopics: map(favorites), 
                topics: map(allTopicsExceptFavorites),
                originalPositionedTopics: map(topics)
            )
            return .success(presentation)
        case .failure(let error):
            print(error)
            return .failure(error)
        }
    }

    func saveFavorites(presentations: [TopicPresnetation]) async {
        let favorites = topics.filter { topic in
            presentations.contains { $0.id == topic.id }
        }
        localService.saveFavorites(favorites)
    }

    func getFavorites() -> [CafeynTopic] {
        localService.getFavorites()
    }
}

private extension TopicRepository {
    func map(_ topics: [CafeynTopic]) -> [TopicPresnetation] {
            topics.map { TopicPresnetation(id: $0.id, name: $0.name.raw) }
    }
}
