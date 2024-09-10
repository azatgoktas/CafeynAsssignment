//
//  CafeynTopicRequest.swift
//  Cafeyn
//
//  Created by Azat Goktas on 09/09/2024.
//

import Foundation
import Networking

struct CafeynTopicRequest: CafeynServiceRequest {
    var method: HTTPMethod = .get
    var path: String = "topics/signup"
    var parameters: Encodable?

    init(parameters: Parameters) {
        self.parameters = parameters
    }

    struct Parameters: Encodable {
        let maxDepth: Int
    }
}
