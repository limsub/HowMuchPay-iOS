//
//  PriceTextFieldView.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/1/25.
//

import UIKit
import RxSwift

class PriceTextFieldView: BaseView {
    
    private var disposeBag = DisposeBag()
        
    // MARK: - UI Components
    let iconLabel = UILabel().then {
        $0.font = .body16m
        $0.text = String(localized: "원")
        $0.backgroundColor = .clear
        $0.textColor = .lightGray
    }
    lazy var textField = UITextField().then {
        $0.backgroundColor = .clear
        $0.placeholder = "20,00,000"
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
        $0.keyboardType = .numberPad
        $0.addTarget(self , action: #selector(formatText), for: .editingChanged)
        $0.textAlignment = .right
    }
    
    
    // MARK: - Layouts
    override func addSubViews() {
        super.addSubViews()
        
        [textField, iconLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        iconLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
        }
        textField.snp.makeConstraints { make in
            make.trailing.equalTo(iconLabel.snp.leading).offset(-8).priority(1000)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
        }
    }
    
    
    override func configures() {
        super.configures()
        
        self.backgroundColor = .grey01
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        // border
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        
        self.textField.rx.text
            .subscribe(with: self) { owner, value in
                if value!.isEmpty {
                    owner.layer.borderColor = UIColor.clear.cgColor
                } else {
                    owner.layer.borderColor = UIColor.mainBlue.cgColor
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - Functions
}

extension PriceTextFieldView {
    @objc
    private func formatText() {
        self.textField.text = Utils.formatWithComma(self.textField.text ?? "")
    }
}

