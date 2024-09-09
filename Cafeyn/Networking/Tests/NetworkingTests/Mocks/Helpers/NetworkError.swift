//
//  NetworkError.swift
//
//
//  Created by Azat Goktas on 06/09/2024.
//

import Foundation
@testable import Networking

extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.noHTTPResponse, .noHTTPResponse),
             (.parse, .parse),
             (.clientError, .clientError),
             (.serverError, .serverError),
             (.unknown, .unknown),
             (.invalidURL, .invalidURL),
             (.serialization, .serialization),
             (.requestTimedOut, .requestTimedOut),
             (.noInternetConnection, .noInternetConnection),
             (.executionError, .executionError):
            return true
        default:
            return false
        }
    }
}
