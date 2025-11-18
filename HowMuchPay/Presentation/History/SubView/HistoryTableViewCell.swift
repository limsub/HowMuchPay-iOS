//
//  HistoryTableViewCell.swift
//  PayNote
//
//  Created by 임승섭 on 1/29/25.
//

import UIKit

// MARK: - 1. Cell For Month
class HistoryTableViewCellForMonth: BaseTableViewCell {

    // MARK: - UI Components
    let yearMonthLabel = UILabel().then {
        $0.font = .title20b
        $0.text = "January 20"
    }
    
    // MARK: - Layouts
    override func addSubViews() {
        super.addSubViews()
        
        [yearMonthLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        yearMonthLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(24)
        }
    }
    
    
    override func configures() {
        super.configures()
        
        self.selectionStyle = .none
    }
    
    
    
    
    // MARK: - Functions
    func setUp(_ yearMonth: String) {
        self.yearMonthLabel.text = yearMonth.toDate(to: .yearMonth)?.toStringYearMonthLocalized()
    }
}


// MARK: - 2. Cell For Item
class HistoryTableViewCell: BaseTableViewCell {
    
    // Left For Date
    let leftDateLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.text = "1st"
        view.textColor = .black
        return view
    }()
    
    let dotView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        view.backgroundColor = .mainBlue
        return view
    }()
    let topLineView = {
        let view = UIView()
        view.backgroundColor = .mainBlue
        return view
    }()
    let bottomLineView = {
        let view = UIView()
        view.backgroundColor = .mainBlue
        return view
    }()
    
    
    // Right For Item
    let baseView = UIView().then {
        $0.backgroundColor = .systemBackground
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    let xButton = UIButton().then {
        $0.setImage(.xButton, for: .normal)
        $0.tintColor = .grey03
    }

    let nameLabel = UILabel().then {
        $0.font = .body16b
    }
    
    let priceLabel = UILabel().then {
        $0.font = .body16m
    }
    
    let typeLabel = UILabel().then {
        $0.font = .body14b
        $0.backgroundColor = UIColor(hexString: "#F8F8FA")
        $0.textColor = .mainBlue
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
    }
    
    let eventTypeLabel = UILabel().then {
        $0.font = .body14m
        $0.textColor = .grey06
    }

    override func addSubViews() {
        super.addSubViews()
        
        [xButton, nameLabel, priceLabel, typeLabel, eventTypeLabel].forEach {
            baseView.addSubview($0)
        }
        
        [leftDateLabel, topLineView, bottomLineView, dotView, baseView].forEach { item in
            contentView.addSubview(item)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        // left date
        leftDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(24)
            make.top.equalTo(contentView).inset(26)
            make.width.equalTo(36)
        }
        
        // dot
        dotView.snp.makeConstraints { make in
            make.size.equalTo(6)
            make.leading.equalTo(leftDateLabel.snp.trailing).offset(12)
            make.centerY.equalTo(leftDateLabel)
        }
        topLineView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.centerX.equalTo(dotView)
            make.bottom.equalTo(dotView.snp.centerY)
            make.width.equalTo(1)
        }
        bottomLineView.snp.makeConstraints { make in
            make.top.equalTo(dotView.snp.centerY)
            make.centerX.equalTo(dotView)
            make.bottom.equalTo(contentView)
            make.width.equalTo(1)
        }
        
        // base
        baseView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(dotView.snp.centerX).offset(14)
            make.height.equalTo(110)    // 셀 높이 140으로 맞출 예정
            make.trailing.equalTo(contentView).inset(18)
        }
        
        xButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
            make.size.equalTo(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.horizontalEdges.equalToSuperview().inset(18)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(nameLabel)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
            make.leading.equalTo(nameLabel)
            make.height.equalTo(20)
        }

        eventTypeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(typeLabel)
            make.leading.equalTo(typeLabel.snp.trailing).offset(8)
            make.height.equalTo(20)
        }
    }
    
    override func configures() {
        super.configures()
        
        self.selectionStyle = .none
    }
    
    func setUp(_ cellItem: HistoryTableViewCellItem) {
        
        // 1. dateLabel
        if cellItem.itemInfo.date.count == 8 {
            let dayString = String(cellItem.itemInfo.date.suffix(2))
            let lastDigitString = String(cellItem.itemInfo.date.suffix(1))
            if let lastDigit = Int(lastDigitString) {
                var text = dayString
                let suffix: String
                switch lastDigit {
                case 1:
                    suffix = "st"
                case 2:
                    suffix = "nd"
                case 3:
                    suffix = "rd"
                default:
                    suffix = "th"
                }
                text += suffix
                leftDateLabel.text = text
            }
        }
            
        // 2. top / bottom line
        let pos = cellItem.pos
        topLineView.isHidden = (pos == .top) ? true : false
        bottomLineView.isHidden = (pos == .bottom) ? true : false
        if pos == .single {
            topLineView.isHidden = true
            bottomLineView.isHidden = true
        }
        
        nameLabel.text = cellItem.itemInfo.partner.name
        priceLabel.text = String(
            localized: "\(Utils.formatWithComma(String(cellItem.itemInfo.amount)))원"
        )
        typeLabel.text = "  \(cellItem.itemInfo.giftType.description)  "
        typeLabel.textColor = cellItem.itemInfo.giftType.tintColor
        
        eventTypeLabel.text = "  #\(cellItem.itemInfo.eventType.description)  "
    }
}
