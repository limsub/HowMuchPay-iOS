//
//  HistoryHeaderView.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/1/25.
//

import UIKit

class HistoryHeaderView: BaseView {
    
    // MARK: - UI Components
    let titleLabel = UILabel().then {
        $0.font = .mg24
    }
    let settingButton = UIButton().then {
        $0.setImage(.settingButton, for: .normal)
        $0.tintColor = .black
    }
    // 빌려준 채권 레이블
    let lentTitleLabel = UILabel().then {
        $0.font = .body16b
    }
    let borrowedTitleLabel = UILabel().then {
        $0.font = .body16b
    }
    lazy var titleLabelStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.distribution = .fillEqually
    }
    
    private let lentAmountLabael = UILabel().then {
        $0.font = .title20b
        $0.textColor = .errorRed
        $0.text = "20,000,000원"
    }
    private let borrowedAmountLabel = UILabel().then {
        $0.font = .title20b
        $0.textColor = .mainBlue
        $0.text = "20,000,000원"
    }
    lazy var amountLabelStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.distribution = .fillEqually
    }
    
    let noAdsImageView = UIImageView().then {
        $0.image = .noAdsImage
    }
    let noAdsButton = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    
    // MARK: - Layouts
    override func addSubViews() {
        super.addSubViews()
        
        [lentTitleLabel, borrowedTitleLabel].forEach {
            titleLabelStackView.addArrangedSubview($0)
        }
        [lentAmountLabael, borrowedAmountLabel].forEach {
            amountLabelStackView.addArrangedSubview($0)
        }
        [titleLabel, settingButton, titleLabelStackView, amountLabelStackView, noAdsImageView, noAdsButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(-56)
            make.leading.equalToSuperview().inset(18)
        }
        
        noAdsImageView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(22)
            make.size.equalTo(30)
        }
        noAdsButton.snp.makeConstraints { make in
            make.center.equalTo(noAdsImageView)
            make.size.equalTo(50)
        }

        titleLabelStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.horizontalEdges.equalToSuperview().inset(18)
        }
        
        amountLabelStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabelStackView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(18)
        }
    }
    
    
    override func configures() {
        super.configures()
    }
    
    
    // MARK: - Functions
    func setUp(givenAmount: Int, receivedAmount: Int) {
        titleLabel.text = String(localized: "얼마냈지")
        lentAmountLabael.text = String(localized: "\(Utils.formatWithComma(String(givenAmount)))원")
        borrowedAmountLabel.text = String(localized: "\(Utils.formatWithComma(String(receivedAmount)))원")
    }
}

// MARK: - private func
extension HistoryHeaderView {
    
}
