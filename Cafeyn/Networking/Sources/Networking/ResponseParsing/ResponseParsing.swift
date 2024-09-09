//
//  ResponseParsing.swift
//
//
//  Created by Azat Goktas on 06/09/2024.
//

import Foundation

/// Protocol to encapsulate parsing layer of the network calls
protocol ResponseParsing {
    static func parseResponse<T: Decodable>(
        data: Data,
        responseType: T.Type
    ) -> Result<T, NetworkError>
}
