//
//  SettingSubtitleLabel.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/1/25.
//

import UIKit 

class SettingTitleLabel: UILabel {
    convenience init(_ text: String) {
        self.init()
        
        self.text = text
        self.textColor = .grey06
        self.font = .body14m
    }
}
