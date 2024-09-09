//
//  RequestAdapterMock.swift
//
//
//  Created by Azat Goktas on 06/09/2024.
//

import Foundation
@testable import Networking

final class RequestAdapterMock: RequestAdapting {
    var invokedAdapt = false

    func adapt(request: URLRequest) -> URLRequest {
        invokedAdapt = true
        return request
    }
}
