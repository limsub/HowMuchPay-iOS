//
//  FriendVC.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/2/25.
//

import UIKit
import ReactorKit

class FriendVC: BaseViewController, View {
    
    let mainView = FriendView()
    
    init(_ reactor: FriendVM) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        
        updateAdVisibility(for: mainView.bannerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
}

// MARK: - ReactorKit
extension FriendVC {
    func bind(reactor: FriendVM) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: FriendVM) {
        mainView.searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .map { FriendVM.Action.loadData($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: FriendVM) {
        reactor.state.map { $0.itemList }
            .subscribe(with: self) { owner , _ in
                owner.mainView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - TableView
extension FriendVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reactor?.currentState.itemList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.description()) as? FriendTableViewCell else { return UITableViewCell() }
        
        if let item = reactor?.currentState.itemList[indexPath.row] {
            cell.setUp(item)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


// MARK: - private func
extension FriendVC {
    private func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    private func loadData() {
        reactor?.action.onNext(.loadData(""))
    }
}
