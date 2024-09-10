//
//  CafeynServingMock.swift
//  CafeynTests
//
//  Created by Azat Goktas on 10/09/2024.
//

import Foundation
import Networking
@testable import Cafeyn

class CafeynServingMock: CafeynServing {

    var stubbedGetTopicsResult: Result<[CafeynTopic], NetworkError>!

    func getTopics() async -> Result<[CafeynTopic], NetworkError> {
        return stubbedGetTopicsResult
    }
}

