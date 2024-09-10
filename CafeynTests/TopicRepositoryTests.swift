//
//  TopicRepositoryTests.swift
//  CafeynTests
//
//  Created by Azat Goktas on 10/09/2024.
//

import Foundation
import XCTest
@testable import Cafeyn
import Networking

final class TopicRepositoryTests: XCTestCase {
    var sut: TopicRepository!
    var apiServiceMock: CafeynServingMock!
    var localServiceMock: CafeynLocalServingMock!

    override func setUp() {
        super.setUp()
        apiServiceMock = CafeynServingMock()
        localServiceMock = CafeynLocalServingMock()
        sut = TopicRepository(apiService: apiServiceMock, localService: localServiceMock)
    }

    override func tearDown() {
        sut = nil
        apiServiceMock = nil
        localServiceMock = nil
        super.tearDown()
    }

    func test_get_topics_success() async {
        // Given
        let expectedTopics = [CafeynTopic(id: "1", name: .init(raw: "test"), subTopics: nil)]
        apiServiceMock.stubbedGetTopicsResult = .success(expectedTopics)

        // When
        let result = await sut.getTopics()

        // Then
        switch result {
        case .success(let presentation):
            XCTAssertEqual(presentation.topics.count, 1)
            XCTAssertEqual(presentation.topics.first?.id, "1")
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }

    func test_get_topics_failure() async {
        // Given
        let expectedError = NetworkError.executionError(.generic)
        apiServiceMock.stubbedGetTopicsResult = .failure(expectedError)

        // When
        let result = await sut.getTopics()

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        }
    }

    func test_save_favorites() async {
        // Given
        let topic1 = TopicPresnetation(id: "1", name: "Topic 1")
        let topic2 = TopicPresnetation(id: "2", name: "Topic 2")
        sut.topics = [CafeynTopic(id: "1", name: .init(raw: "Topic 1"), subTopics: nil),
                      CafeynTopic(id: "2", name: .init(raw: "Topic 2"), subTopics: nil)]

        // When
        await sut.saveFavorites(presentations: [topic1, topic2])

        // Then
        XCTAssertEqual(localServiceMock.savedFavorites.count, 2)
        XCTAssertEqual(localServiceMock.savedFavorites.first?.id, "1")
        XCTAssertEqual(localServiceMock.savedFavorites[1].name.raw, "Topic 2")
    }
}
