//
//  String+.swift
//  LifeMovie
//
//  Created by 임승섭 on 12/26/24.
//

import Foundation

extension String {
    func localized() -> String {
        return String(localized: LocalizationValue(self))
    }
}
