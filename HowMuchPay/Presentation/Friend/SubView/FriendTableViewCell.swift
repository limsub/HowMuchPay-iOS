//
//  FriendTableViewCell.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/2/25.
//

import UIKit

// MARK: - FriendTableViewCell
class FriendTableViewCell: BaseTableViewCell {

    // MARK: - UI Components
    let baseView = UIView().then {
        $0.backgroundColor = .systemBackground
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    let partnerNameLabel = UILabel().then {
        $0.text = "홍길동"
        $0.font = .body16b
    }
    
    let givenBar = UIView().then {
        $0.backgroundColor = .errorRed
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 2
    }
    let givenAmountLabel = UILabel().then {
        $0.font = .body14b
        $0.adjustsFontSizeToFitWidth = true
        $0.textAlignment = .right
    }
    
    let receivedBar = UIView().then {
        $0.backgroundColor = .mainBlue
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 2
    }
    let receivedAmountLabel = UILabel().then {
        $0.font = .body14b
        $0.adjustsFontSizeToFitWidth = true
        $0.textAlignment = .right
    }
    
    
    // MARK: - Layouts
    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(baseView)
        
        [partnerNameLabel, givenBar, givenAmountLabel, receivedBar, receivedAmountLabel].forEach {
            baseView.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        baseView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(18)
            make.verticalEdges.equalToSuperview().inset(6)
        }
        
        partnerNameLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(18)
        }
        
        givenAmountLabel.snp.makeConstraints { make in
            make.top.equalTo(partnerNameLabel.snp.bottom).offset(12)
            make.trailing.equalToSuperview().inset(18).priority(1000)
            make.width.equalTo(80)
        }
        givenBar.snp.makeConstraints { make in
            make.centerY.equalTo(givenAmountLabel)
            make.leading.equalToSuperview().inset(18).priority(1000)
            make.trailing.equalTo(givenAmountLabel.snp.leading).offset(-4).priority(200)
            make.width.equalTo(100)
            make.height.equalTo(4)
        }
        
        receivedAmountLabel.snp.makeConstraints { make in
            make.top.equalTo(givenAmountLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview().inset(18).priority(1000)
            make.width.equalTo(80)
        }
        receivedBar.snp.makeConstraints { make in
            make.centerY.equalTo(receivedAmountLabel)
            make.leading.equalToSuperview().inset(18).priority(1000)
            make.trailing.equalTo(receivedAmountLabel.snp.leading).offset(-4).priority(200)
            make.width.equalTo(100)
            make.height.equalTo(4)
            make.bottom.equalToSuperview().inset(26)
        }
    }
    
    
    override func configures() {
        super.configures()
        
        self.backgroundColor = .mainBackground
        contentView.backgroundColor = .mainBackground
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        layouts()
    }
    
    // MARK: - Functions
    func setUp(_ item: FriendTableViewCellItem) {
        let gm = item.givenAmount
        let rm = item.receivedAmount
        
        // Text
        partnerNameLabel.text = item.partner.name
        givenAmountLabel.text = Utils.formatWithComma(String(item.givenAmount))
        receivedAmountLabel.text = Utils.formatWithComma(String(item.receivedAmount))
        
        // Bar
        if (gm == 0 && rm == 0) { return }
        if gm > rm {
            let ratio = CGFloat(rm) / CGFloat(gm)
            givenBar.snp.remakeConstraints { make in
                make.centerY.equalTo(givenAmountLabel)
                make.leading.equalToSuperview().inset(18) // 왼쪽 고정
                make.trailing.equalTo(givenAmountLabel.snp.leading).offset(-4) // 오른쪽 고정
                make.height.equalTo(4) // 높이 유지
            }
            receivedBar.snp.remakeConstraints { make in
                make.centerY.equalTo(receivedAmountLabel)
                make.leading.equalToSuperview().inset(18).priority(1000)
                make.trailing.equalTo(receivedAmountLabel.snp.leading).offset(-4).priority(200)
                make.width.equalTo(givenBar.snp.width).multipliedBy(ratio)
                make.height.equalTo(4)
                make.bottom.equalToSuperview().inset(18)
            }
            
        } else {
            let ratio = CGFloat(gm) / CGFloat(rm)
            receivedBar.snp.remakeConstraints { make in
                make.centerY.equalTo(receivedAmountLabel)
                make.leading.equalToSuperview().inset(18)
                make.trailing.equalTo(receivedAmountLabel.snp.leading).offset(-4)
                make.height.equalTo(4)
                make.bottom.equalToSuperview().inset(18)
            }
            givenBar.snp.remakeConstraints { make in
                make.centerY.equalTo(givenAmountLabel)
                make.leading.equalToSuperview().inset(18).priority(1000)
                make.trailing.equalTo(givenAmountLabel.snp.leading).offset(-4).priority(200)
                make.width.equalTo(receivedBar.snp.width).multipliedBy(ratio)
                make.height.equalTo(4)
            }
        }
    }
}

