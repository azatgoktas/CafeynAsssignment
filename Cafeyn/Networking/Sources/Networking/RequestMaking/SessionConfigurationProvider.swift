//
//  SessionConfigurationProvider.swift
//
//
//  Created by Azat Goktas on 06/09/2024.
//

import Foundation

enum SessionConfigurationProvider {
    static let sessionConfiguration: URLSessionConfiguration = {
        return URLSessionConfiguration.default // can be customised when needed, I'll keep it as default.
    }()
}
