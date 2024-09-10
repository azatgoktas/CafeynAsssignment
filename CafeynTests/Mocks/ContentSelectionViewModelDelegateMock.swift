//
//  ContentSelectionViewModelDelegateMock.swift
//  CafeynTests
//
//  Created by Azat Goktas on 10/09/2024.
//

import Foundation
@testable import Cafeyn

class ContentSelectionViewModelDelegateMock: ContentSelectionViewModelDelegate {
    var output: [ContentSelectionViewModelOutput] = []

    func handleViewModelOutput(_ output: ContentSelectionViewModelOutput) {
        self.output.append(output)
    }
}
