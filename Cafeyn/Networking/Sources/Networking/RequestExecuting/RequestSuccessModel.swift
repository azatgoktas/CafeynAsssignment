//
//  RequestSuccessModel.swift
//
//
//  Created by Azat Goktas on 06/09/2024.
//

import Foundation

// Encapsulates response after a successful network call
public struct RequestSuccessModel {
    let data: Data
    let response: URLResponse
}
