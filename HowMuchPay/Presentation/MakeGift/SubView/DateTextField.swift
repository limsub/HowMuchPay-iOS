//
//  DateTextField.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/1/25.
//

import UIKit
import RxSwift

class DateTextField: UITextField {
    private let disposeBag = DisposeBag()
    
    convenience init(_ placeholderText: String) {
        self.init()
        
        setUp(placeholderText)
        bind()
    }
    
    // clearButton 위치 조정하기 위한 오버라이딩
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.clearButtonRect(forBounds: bounds)
        return originalRect.offsetBy(dx: -8, dy: 0)
    }
    
    private func setUp(_ placeholderText: String) {
        // placeholder
        self.placeholder = placeholderText
        
        // background
        self.backgroundColor = .grey01
        
        // border
        self.clipsToBounds = true
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        
        // font
        self.font = .body18m
        
        // alighment
        self.textAlignment = .center 
    }
    
    func bind() {
        self.rx.text
            .subscribe(with: self) { owner, value in
                if value!.isEmpty {
                    owner.layer.borderColor = UIColor.clear.cgColor
                } else {
                    owner.layer.borderColor = UIColor.mainBlue.cgColor
                }
            }
            .disposed(by: disposeBag)
    }
}
