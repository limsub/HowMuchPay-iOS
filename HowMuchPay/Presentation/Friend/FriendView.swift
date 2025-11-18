//
//  FriendView.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/2/25.
//

import UIKit

class FriendView: BaseView {
    
    // MARK: - UI Components
    let titleView = UILabel().then {
        $0.text = "마음을 나눈 사람들"
        $0.font = .mg24
    }
    let searchBar = UISearchBar().then {
        $0.backgroundImage = UIImage()
        $0.placeholder = "검색어를 입력하세요"
    }
    let tableView = UITableView().then {
        $0.register(FriendTableViewCell.self , forCellReuseIdentifier: FriendTableViewCell.description())
        $0.keyboardDismissMode = .onDrag
        $0.separatorStyle = .none
        $0.backgroundColor = .mainBackground
    }
    
    let bannerView = GADBannerViewWrapper(type: .friendVCBanner)
    
    
    // MARK: - Layouts
    override func addSubViews() {
        super.addSubViews()
        
        [titleView, searchBar, tableView, bannerView].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        titleView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(-56)
            make.leading.equalToSuperview().inset(18)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
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
extension FriendView {
    
}
