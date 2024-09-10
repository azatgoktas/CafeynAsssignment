//
//  ContentSelectionSectionHeaderView.swift
//  Cafeyn
//
//  Created by Azat Goktas on 09/09/2024.
//

import Foundation
import UIKit

final class ContentSelectionSectionHeaderView: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(title: String) {
        super.init(frame: .zero)
        setupView()
        label.text = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .systemBackground
        addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
