//
//  HistoryVC.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/1/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class HistoryVC: BaseViewController, View {

    let mainView = HistoryView()
    
    // MARK: - Initialize
    init(_ reactor: HistoryVM) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycle
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isUserInteractionEnabled = false
        
        setTableView()
        
        updateAdVisibility(for: mainView.bannerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
}

// MARK: - ReactorKit
extension HistoryVC {
    func bind(reactor: HistoryVM) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: HistoryVM) {
        mainView.plusButton.rx.tap
            .subscribe(with: self) { owner , _ in
                owner.showMakeVC()
            }
            .disposed(by: disposeBag)
    
        mainView.headerView.noAdsButton.rx.tap
            .subscribe(with: self) { owner , _ in
                Logger.print(#function)
                RemoveAdsAlert.show(in: self)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: HistoryVM) {
        reactor.state.map { $0.itemList }
            .distinctUntilChanged()
            .subscribe(with: self) { owner , _ in
                owner.mainView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.price }
            .subscribe(with: self) { owner , value  in
                owner.mainView.headerView.setUp(
                    givenAmount: value.0,
                    receivedAmount: value.1
                )
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - TableView
extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reactor?.currentState.itemList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = reactor?.currentState.itemList[indexPath.row] else { return UITableViewCell() }
        
        if isHeaderCell(row: indexPath.row) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCellForMonth.description()) as? HistoryTableViewCellForMonth else { return UITableViewCell() }
            cell.setUp(item.itemInfo.date)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.description()) as? HistoryTableViewCell else { return UITableViewCell() }
            
            cell.setUp(item)
            
            cell.xButton.rx.tap
                .subscribe(with: self) { owner , _ in
                    owner.showCancelPopUp(indexPath.row)
                }
                .disposed(by: cell.disposeBag)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isHeaderCell(row: indexPath.row) ? 60 : 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showEditGiftVC(indexPath.row)
    }
}


// MARK: - private func
extension HistoryVC {
    private func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    private func isHeaderCell(row: Int) -> Bool {
        guard let itemList = reactor?.currentState.itemList else { return false }
        
        return itemList[row].itemInfo.date.count == 6
    }
    
    private func showMakeVC() {
        let vc = MakeGiftVC(MakeGiftVM(), type: .create)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav , animated: true)
    }
    
    private func loadData() {
        reactor?.action.onNext(.loadData)
    }
    
    private func showCancelPopUp(_ row: Int) {
        guard let partnerName = reactor?.currentState.itemList[row].itemInfo.partner.name else { return }
        
        let popup = ReportPopupViewController(
            title: String(localized: "해당 마음를 삭제할까요?"),
            message: String(localized: "\(partnerName)님과의 거래를 삭제할까요?"),
            cancelTitle: String(localized: "취소"),
            actionTitle: String(localized: "삭제"),
            cancelHandler: {
            },
            actionHandler: {
                self.reactor?.action.onNext(.deleteData(row))
                self.reactor?.action.onNext(.loadData)
            }
        )

        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .crossDissolve
        present(popup, animated: true, completion: nil)
    }
    
    private func showEditGiftVC(_ row: Int) {
        guard let id = reactor?.currentState.itemList[row].itemInfo.id else { return }
        let vc = MakeGiftVC(MakeGiftVM(), type: .edit(id: id))
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
}
