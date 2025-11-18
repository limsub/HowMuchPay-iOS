//
//  SplashView.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/2/25.
//


import UIKit

class SplashView: BaseView {
    
    // MARK: - UI Components
    let titleLabel = UILabel().then {
        $0.font = .splashLogo
        $0.text = String(localized: "얼마냈지")
        $0.textColor = .white 
    }
    

    // MARK: - Layouts
    override func addSubViews() {
        super.addSubViews()
        
        [titleLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        titleLabel.snp.makeConstraints { make in
//            make.width.equalTo(180)
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview().offset(-18)
            make.center.equalToSuperview()
        }
    }
    
    
    override func configures() {
        super.configures()
        
        backgroundColor = .mainBlue
    }
    
    
    // MARK: - Functions
    
}

// MARK: - private func
extension SplashView {
    
}
