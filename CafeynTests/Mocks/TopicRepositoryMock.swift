//
//  TopicRepositoryMock.swift
//  CafeynTests
//
//  Created by Azat Goktas on 10/09/2024.
//

import Foundation
@testable import Cafeyn
import XCTest

class TopicRepositoryMock: TopicRepositoryProtocol {

    var stubbedGetTopicsResult: Result<ContentSelectionPresentation, Error>!
    var expectation: XCTestExpectation?
    func getTopics() async -> Result<ContentSelectionPresentation, Error> {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { // simulate async operation
            self.expectation?.fulfill()
        }
        return stubbedGetTopicsResult
    }

    func saveFavorites(presentations: [TopicPresnetation]) {
        // Mock implementation
    }
}
