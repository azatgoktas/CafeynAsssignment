//
//  ContentSelectionContracts.swift
//  Cafeyn
//
//  Created by Azat Goktas on 09/09/2024.
//

import Foundation

protocol ContentSelectionViewModelProtocol: AnyObject {
    var delegate: ContentSelectionViewModelDelegate? { get set }
    func load()
    func save()
    func selectTopic(at index: Int)
    func deselectTopic(at index: Int)
    func moveTopic(from sourceIndex: Int, to destinationIndex: Int)
}

enum ContentSelectionViewModelOutput: Equatable {
    case updateTitle(String)
    case setLoading(Bool)
    case showError(String)
    case showTopics(presentation: ContentSelectionPresentation)
    case topicSelected(presentation: ContentSelectionPresentation, selectedIndex: Int, insertedIndex: Int)
    case topicDeselected(presentation: ContentSelectionPresentation, deselectedIndex: Int, insertedIndex: Int)
    case topicMoved(presentation: ContentSelectionPresentation, from: Int, to: Int)
}

protocol ContentSelectionViewModelDelegate: AnyObject {
    @MainActor
    func handleViewModelOutput(_ output: ContentSelectionViewModelOutput)
}
