//
//  HistoryView.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/1/25.
//

import UIKit

class HistoryView: BaseView {

    // MARK: - UI Components
    let headerView = HistoryHeaderView().then {
        $0.lentTitleLabel.text = String(localized: "전한 마음")
        $0.borrowedTitleLabel.text = String(localized: "받은 마음")
    }

    let tableView = UITableView().then {
        $0.register(HistoryTableViewCellForMonth.self , forCellReuseIdentifier: HistoryTableViewCellForMonth.description())
        $0.register(HistoryTableViewCell.self , forCellReuseIdentifier: HistoryTableViewCell.description())
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .mainBackground
    }
    
    let plusButton = UIButton().then {
        $0.setImage(.plusButton, for: .normal)
    }
    
    let bannerView = GADBannerViewWrapper(type: .tabbarBanner)
    
    // MARK: - Layouts
    override func addSubViews() {
        super.addSubViews()
        
        [headerView, tableView, plusButton, bannerView].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        headerView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(self)
            make.height.equalTo(208)
        }
        
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(208)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        plusButton.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(self).inset(130)
        }
        
        bannerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self).inset(70)
        }
    }
    
    
    override func configures() {
        super.configures()
        
        
    }
    
    
    // MARK: - Functions
    
}

// MARK: - private func
extension HistoryView {
    
}


