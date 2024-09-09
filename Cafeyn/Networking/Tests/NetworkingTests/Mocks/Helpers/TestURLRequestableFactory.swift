//
//  TestURLRequestableFactory.swift
//
//
//  Created by Azat Goktas on 06/09/2024.
//

import Foundation
@testable import Networking

enum TestURLRequestableFactory {
    static func makeURLRequestable(
        httpMethod: HTTPMethod,
        parameters: TestModel?,
        headers: [String: String] = [:]
    ) -> TestURLRequestable {
        TestURLRequestable(
            baseURL: "https://b2c-api.cafeyn.co",
            method: httpMethod,
            path: "test_resources",
            parameters: parameters,
            headers: headers
        )
    }
}
