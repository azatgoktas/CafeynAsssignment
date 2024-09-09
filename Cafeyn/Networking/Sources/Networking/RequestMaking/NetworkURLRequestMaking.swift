//
//  NetworkURLRequestMaking.swift
//
//
//  Created by Azat Goktas on 06/09/2024.
//

import Foundation

public protocol NetworkURLRequestMaking {
    func makeURLRequest(with requestable: URLRequestable) throws -> URLRequest
}
