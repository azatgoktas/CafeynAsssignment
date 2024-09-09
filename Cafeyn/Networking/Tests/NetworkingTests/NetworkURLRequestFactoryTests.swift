//
//  NetworkURLRequestFactoryTests.swift
//
//
//  Created by Azat Goktas on 06/09/2024.
//

import Foundation
@testable import Networking
import XCTest

class NetworkURLRequestFactoryTests: XCTestCase {

    struct MockRequest: URLRequestable {
        var baseURL: String
        var path: String
        var parameters: Encodable?
        var headers: [String: String]?
        var method: HTTPMethod
    }

    func test_url_request_withh_url_encoding() {
        let factory = NetworkURLRequestFactory()
        let requestable = MockRequest(
            baseURL: "https://api.example.com",
            path: "/endpoint",
            parameters: ["key": "value"],
            headers: ["Header": "Value"],
            method: .get
        )

        do {
            let request = try factory.makeURLRequest(with: requestable)
            XCTAssertEqual(request.url?.absoluteString, "https://api.example.com/endpoint?key=value")
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Header"), "Value")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_url_request_withh_json_encoding()  {
        let factory = NetworkURLRequestFactory()
        let requestable = MockRequest(
            baseURL: "https://api.example.com",
            path: "/endpoint",
            parameters: ["key": "value"],
            headers: ["Header": "Value"],
            method: .post
        )

        do {
            let request = try factory.makeURLRequest(with: requestable)
            XCTAssertEqual(request.url?.absoluteString, "https://api.example.com/endpoint")
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Header"), "Value")
            XCTAssertNotNil(request.httpBody)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_invalid_url() {
        let factory = NetworkURLRequestFactory()
        let requestable = MockRequest(
            baseURL: "",
            path: "/endpoint",
            parameters: ["key": "value"],
            headers: ["Header": "Value"],
            method: .get
        )

        XCTAssertThrowsError(try factory.makeURLRequest(with: requestable)) { error in
            guard case NetworkError.invalidURL = error else {
                return XCTFail("Expected invalid URL error, but got: \(error)")
            }
        }
    }
}
