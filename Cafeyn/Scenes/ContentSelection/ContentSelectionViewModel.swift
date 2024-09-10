//
//  ContentSelectionViewModel.swift
//  Cafeyn
//
//  Created by Azat Goktas on 09/09/2024.
//

import Foundation

final class ContentSelectionViewModel: ContentSelectionViewModelProtocol {
    weak var delegate: ContentSelectionViewModelDelegate?
    private let repository: TopicRepositoryProtocol
    var presentation: ContentSelectionPresentation?

    init(delegate: ContentSelectionViewModelDelegate, repository: TopicRepositoryProtocol) {
        self.delegate = delegate
        self.repository = repository
    }

    @MainActor
    func load() {
        let title = "center-of-interests".localised
        delegate?.handleViewModelOutput(.updateTitle(title))
        delegate?.handleViewModelOutput(.setLoading(true))
        getTopics()
    }

    func save() {
        Task {
            await repository.saveFavorites(presentations: presentation?.selectedTopics ?? [])
        }
    }

    @MainActor
    func selectTopic(at index: Int) {
        guard let presentation else { return }
        let item = presentation.topics.remove(at: index)
        presentation.selectedTopics.append(item)
        delegate?.handleViewModelOutput(
            .topicSelected(
                presentation: presentation,
                selectedIndex: index,
                insertedIndex: presentation.selectedTopics.count - 1)
        )
    }

    @MainActor
    func deselectTopic(at index: Int) {
        guard let presentation,
        presentation.selectedTopics.count > index else {
            return
        }
        let item = presentation.selectedTopics.remove(at: index)
        let calculatedIndex = calculateItemPosition(item: item)
        presentation.topics.insert(item, at: calculatedIndex)
        self.presentation = presentation
        delegate?.handleViewModelOutput(
            .topicDeselected(
                presentation: presentation,
                deselectedIndex: index,
                insertedIndex: calculatedIndex
            )
        )
    }

    @MainActor
    func moveTopic(from sourceIndex: Int, to destinationIndex: Int) {
        guard let presentation else { return }
        let movedItem = presentation.selectedTopics.remove(at: sourceIndex)
        presentation.selectedTopics.insert(movedItem, at: destinationIndex)
        delegate?.handleViewModelOutput(
            .topicMoved(
                presentation: presentation,
                from: sourceIndex,
                to: destinationIndex
            )
        )
    }

    private func getTopics() {
        Task {
            let result = await repository.getTopics()
            switch result {
            case .success(let topics):
                self.presentation = topics
                await delegate?.handleViewModelOutput(.showTopics(presentation: topics))
            case .failure(let failure):
                await delegate?.handleViewModelOutput(.showError(failure.localizedDescription))
            }
            await delegate?.handleViewModelOutput(.setLoading(false))
        }
    }

    private func calculateItemPosition(item: TopicPresnetation) -> Int {
        guard let presentation else { return 0 }
        var index = 0
        for topic in presentation.originalPositionedTopics {
            if item.id == topic.id {
                break
            }

            if !presentation.selectedTopics.contains(topic) {
                index += 1
            }
        }
        return index
    }
}
