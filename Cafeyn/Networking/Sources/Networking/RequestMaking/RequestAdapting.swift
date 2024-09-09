//
//  RequestAdapting.swift
//
//
//  Created by Azat Goktas on 06/09/2024.
//

import Foundation

public protocol RequestAdapting: AnyObject {
    func adapt(request: URLRequest) -> URLRequest
}
