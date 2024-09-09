//
//  NetworkURLRequestFactoryMock.swift
//
//
//  Created by Azat Goktas on 06/09/2024.
//

import Foundation
@testable import Networking

final class NetworkURLRequestFactoryMock: NetworkURLRequestMaking {
    var invokedMakeURLRequest = false
    var invokedMakeURLRequestCount = 0
    var invokedMakeURLRequestParameters: (requestable: Any, Void)?
    var invokedMakeURLRequestParametersList = [(requestable: Any, Void)]()
    var stubbedMakeURLRequestError: NetworkError?
    var stubbedMakeURLRequestResult = URLRequest(url: URL(string: "https://b2c-api.cafeyn.co")!)

    func makeURLRequest(with requestable: URLRequestable) throws -> URLRequest {
        invokedMakeURLRequest = true
        invokedMakeURLRequestCount += 1
        invokedMakeURLRequestParameters = (requestable, ())
        invokedMakeURLRequestParametersList.append((requestable, ()))
        if let error = stubbedMakeURLRequestError {
            throw error
        }
        return stubbedMakeURLRequestResult
    }
}
