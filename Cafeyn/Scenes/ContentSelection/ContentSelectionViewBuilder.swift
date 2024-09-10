//
//  ContentSelectionViewBuilder.swift
//  Cafeyn
//
//  Created by Azat Goktas on 09/09/2024.
//

import Foundation
final class ContentSelectionViewBuilder {
    static func make() -> ContentSelectionViewController {
        let viewController = ContentSelectionViewController()
        let apiService = CafeynApiService()
        let localService = CafeynLocalService()
        let repository = TopicRepository(apiService: apiService, localService: localService)
        let viewModel = ContentSelectionViewModel(delegate: viewController, repository: repository)
        viewController.viewModel = viewModel
        return viewController
    }
}
