//
//  CafeynService.swift
//  Cafeyn
//
//  Created by Azat Goktas on 09/09/2024.
//

import Foundation
import Networking

protocol CafeynServing {
    func getTopics() async -> Result<[CafeynTopic], NetworkError>
}

final class CafeynApiService: CafeynServing {
    private let network: NetworkProviding

    init(network: NetworkProviding = Networking()) {
        self.network = network
    }

    func getTopics() async -> Result<[CafeynTopic], NetworkError> {
        return await network.request(
            requestable: CafeynTopicRequest(parameters: .init(maxDepth: 2)),
            responseType: [CafeynTopic].self
        )
    }
}
