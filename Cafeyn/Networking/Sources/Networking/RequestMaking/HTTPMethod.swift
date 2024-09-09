//
//  HTTPMethod.swift
//
//
//  Created by Azat Goktas on 06/09/2024.
//

import Foundation

public enum HTTPMethod: String, Codable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
