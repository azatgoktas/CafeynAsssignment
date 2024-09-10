//
//  ContentItemPresentation.swift
//  Cafeyn
//
//  Created by Azat Goktas on 09/09/2024.
//

import Foundation
import UIKit

struct ContentItemPresentation {
    let text: String
    let textColor: UIColor
    let iconName: String
    let iconColor: UIColor
    let isSelected: Bool

    static func forItem(_ item: String, isSelected: Bool) -> ContentItemPresentation {
        if isSelected {
            return ContentItemPresentation(
                text: item,
                textColor: .red,
                iconName: "minus.circle",
                iconColor: .red,
                isSelected: true
            )
        } else {
            return ContentItemPresentation(
                text: item,
                textColor: .black,
                iconName: "plus.circle",
                iconColor: .black,
                isSelected: false
            )
        }
    }
}
