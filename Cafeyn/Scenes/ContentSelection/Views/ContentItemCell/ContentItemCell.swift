//
//  ContentItemCell.swift
//  Cafeyn
//
//  Created by Azat Goktas on 09/09/2024.
//

import Foundation
import UIKit

class ContentItemCell: UITableViewCell {
    private let dragHandleImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "line.3.horizontal"))
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        contentView.addSubview(dragHandleImageView)

        NSLayoutConstraint.activate([
            dragHandleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            dragHandleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            dragHandleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
        ])
    }

    func configure(with presentation: ContentItemPresentation) {
        textLabel?.text = presentation.text
        textLabel?.textColor = presentation.textColor
        imageView?.image = UIImage(systemName: presentation.iconName)?.withRenderingMode(.alwaysTemplate)
        imageView?.tintColor = presentation.iconColor
        dragHandleImageView.isHidden = !presentation.isSelected
    }
}
