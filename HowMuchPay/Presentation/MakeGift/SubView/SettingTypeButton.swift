//
//  SettingTypeButton.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/1/25.
//

import UIKit 

class SettingTypeButton: UIButton {
    
    convenience init(_ title: String ) {
        self.init()
        
        self.setupUI()
        self.setTitle(title, for: .normal)
    }

    private func setupUI() {
        self.layer.cornerRadius = 12
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.setTitleColor(.gray, for: .normal)
        self.backgroundColor = UIColor(white: 0.9, alpha: 1.0) // 연한 회색
    }
    
    func setUp(_ selected: Bool) {
        self.backgroundColor = selected
            ? .mainBlue.withAlphaComponent(0.15)
            : UIColor(white: 0.9, alpha: 1.0)
        
        self.setTitleColor(selected
                           ? .mainBlue
                           : .gray
                           , for: .normal)
    }
}
