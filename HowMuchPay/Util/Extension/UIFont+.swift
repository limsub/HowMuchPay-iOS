//
//  Font.swift
//  LifeMovie
//
//  Created by 임승섭 on 12/21/24.
//

import UIKit

enum MainFont: String {
    case black = "Pretendard-Black"
    case bold = "Pretendard-Bold"
    case extraBold = "Pretendard-ExtraBold"
    case extraLight = "Pretendard-ExtraLight"
    case light = "Pretendard-Light"
    case medium = "Pretendard-Medium"
    case regular = "Pretendard-Regular"
    case semiBold = "Pretendard-SemiBold"
    case thin = "Pretendard-Thin"
    case moneygraphy = "Moneygraphy-Rounded"
}

extension UIFont {
    static let title24b = UIFont(name: MainFont.bold.rawValue, size: 24)!
    static let title20b = UIFont(name: MainFont.bold.rawValue, size: 20)!
    static let body18b = UIFont(name: MainFont.bold.rawValue, size: 18)!
    static let body18m = UIFont(name: MainFont.medium.rawValue, size: 18)!
    static let body16b = UIFont(name: MainFont.bold.rawValue, size: 16)!
    static let body16m = UIFont(name: MainFont.medium.rawValue, size: 16)!
    static let body14b = UIFont(name: MainFont.bold.rawValue, size: 14)!
    static let body14m = UIFont(name: MainFont.medium.rawValue, size: 14)!
    static let body14r = UIFont(name: MainFont.regular.rawValue, size: 14)!
    static let body12sb = UIFont(name: MainFont.semiBold.rawValue, size: 12)!
    static let body12r = UIFont(name: MainFont.regular.rawValue, size: 12)!
    
    static let mg24 = UIFont(name: MainFont.moneygraphy.rawValue, size: 24)!
    static let splashLogo = UIFont(name: MainFont.moneygraphy.rawValue, size: 40)!
}
