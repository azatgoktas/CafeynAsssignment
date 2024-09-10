//
//  ContentSelectionViewModelTests.swift
//  CafeynTests
//
//  Created by Azat Goktas on 10/09/2024.
//

import XCTest
@testable import Cafeyn
import Networking

final class ContentSelectionViewModelTests: XCTestCase {
    var viewModel: ContentSelectionViewModel!
    var delegateMock: ContentSelectionViewModelDelegateMock!
    var repositoryMock: TopicRepositoryMock!

    override func setUp() {
        super.setUp()
        delegateMock = ContentSelectionViewModelDelegateMock()
        repositoryMock = TopicRepositoryMock()
        viewModel = ContentSelectionViewModel(delegate: delegateMock, repository: repositoryMock)
    }

    override func tearDown() {
        viewModel = nil
        delegateMock = nil
        repositoryMock = nil
        super.tearDown()
    }

    func test_load_topic_success() async {
        // Given
        let expectation = XCTestExpectation(description: "Load topics success")
        let topics = [TopicPresnetation(id: "1", name: "Topic 1")]
        let expectedTopics = ContentSelectionPresentation(topics: topics, originalPositionedTopics: topics)
        repositoryMock.stubbedGetTopicsResult = .success(expectedTopics)
        repositoryMock.expectation = expectation

        // When
        await viewModel.load()

        // Then
        await fulfillment(of: [expectation])
        XCTAssertEqual(delegateMock.output.count, 4)
        XCTAssertEqual(delegateMock.output[0], .updateTitle("Centers of interest"))
        XCTAssertEqual(delegateMock.output[1], .setLoading(true))
        XCTAssertEqual(delegateMock.output[2], .showTopics(presentation: expectedTopics))
        XCTAssertEqual(delegateMock.output[3], .setLoading(false))
    }

    func test_load_topic_failure() async {
        // Given
        let expectation = XCTestExpectation(description: "Load topics failure")
        let expectedError = NetworkError.executionError(.generic)
        repositoryMock.stubbedGetTopicsResult = .failure(expectedError)
        repositoryMock.expectation = expectation

        // When
        await viewModel.load()

        // Then
        await fulfillment(of: [expectation])

        XCTAssertEqual(delegateMock.output.count, 4)
        XCTAssertEqual(delegateMock.output[0], .updateTitle("Centers of interest"))
        XCTAssertEqual(delegateMock.output[1], .setLoading(true))
        XCTAssertEqual(delegateMock.output[2], .showError(expectedError.localizedDescription))
        XCTAssertEqual(delegateMock.output[3], .setLoading(false))
    }

    func test_select_topic() async {
        // Given
        let topics = [TopicPresnetation(id: "1", name: "Topic 1")]

        let presentation = ContentSelectionPresentation(topics: [TopicPresnetation(id: "1", name: "Topic 1")], originalPositionedTopics: topics)
        viewModel.presentation = presentation

        // When
        await viewModel.selectTopic(at: 0)

        // Then
        XCTAssertEqual(delegateMock.output.count, 1)
        XCTAssertEqual(delegateMock.output[0], .topicSelected(presentation: presentation, selectedIndex: 0, insertedIndex: 0))
        XCTAssertEqual(presentation.selectedTopics.count, 1)
    }

    func test_deselect_topic() async {
        // Given
        let topic = TopicPresnetation(id: "1", name: "Topic 1")
        let presentation = ContentSelectionPresentation(selectedTopics: [topic], topics: [topic], originalPositionedTopics: [topic])
        viewModel.presentation = presentation

        // When
        await viewModel.deselectTopic(at: 0)

        // Then
        XCTAssertEqual(delegateMock.output.count, 1)
        XCTAssertEqual(delegateMock.output[0], .topicDeselected(presentation: presentation, deselectedIndex: 0, insertedIndex: 0))
        XCTAssertEqual(presentation.selectedTopics.count, 0)
    }

    func test_move_topic() async {
        // Given
        let topic1 = TopicPresnetation(id: "1", name: "Topic 1")
        let topic2 = TopicPresnetation(id: "2", name: "Topic 2")
        let presentation = ContentSelectionPresentation(selectedTopics: [topic1, topic2], topics: [], originalPositionedTopics: [topic1, topic2])
        viewModel.presentation = presentation

        // When
        await viewModel.moveTopic(from: 0, to: 1)

        // Then
        XCTAssertEqual(delegateMock.output.count, 1)
        XCTAssertEqual(delegateMock.output[0], .topicMoved(presentation: presentation, from: 0, to: 1))
        XCTAssertEqual(presentation.selectedTopics[0], topic2)
        XCTAssertEqual(presentation.selectedTopics[1], topic1)
    }
}
