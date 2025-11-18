//
//  SettingTitleLabel.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/1/25.
//

import UIKit 

class SettingSubtitleLabel: UILabel {
    convenience init(_ text: String) {
        self.init()
        
        self.text = text
        self.textColor = .grey05
        self.font = .body14m
    }
    
    func update(_ enabled: Bool, enabledText: String, disabledText: String) {
        self.textColor = enabled ? .grey05 : .errorRed
        self.text = enabled ? enabledText : disabledText
    }
}
