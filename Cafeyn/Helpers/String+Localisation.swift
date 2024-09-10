//
//  String+Localisation.swift
//  Cafeyn
//
//  Created by Azat Goktas on 09/09/2024.
//

import Foundation

extension String {
    var localised: String {
        NSLocalizedString(self, comment: "")
    }
}

