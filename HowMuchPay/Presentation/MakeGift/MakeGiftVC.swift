//
//  MakeGiftVC.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/1/25.
//

import UIKit
import ReactorKit

class MakeGiftVC: BaseViewController, View {
    
    let mainView = MakeGiftView()
    var type: VCPurPose? = nil
    
    init(_ reactor: MakeGiftVM, type: VCPurPose) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
        self.type = type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        setupKeyboardNotifications()
        hideKeyboardWhenTappedAround()
        setItemForEdit()
    }
}

// MARK: - ReactorKit
extension MakeGiftVC {
    func bind(reactor: MakeGiftVM) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: MakeGiftVM) {
        // 1. 상대방 이름
        mainView.partnerNameTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { MakeGiftVM.Action.partnerNameChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 2. 받은 or 준
        mainView.givenButton.rx.tap
            .map { MakeGiftVM.Action.giftTypeSelected(.given) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        mainView.receivedButton.rx.tap
            .map { MakeGiftVM.Action.giftTypeSelected(.received) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 3. 금액
        mainView.amountTextField.textField.rx.text.orEmpty
            .map { Utils.removeCommas($0) }
            .distinctUntilChanged()
            .map { Int($0) ?? 0 }
            .map { MakeGiftVM.Action.amountChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 4. 이벤트
        mainView.weddingButton.rx.tap
            .map { MakeGiftVM.Action.eventTypeSeleted(.wedding) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        mainView.firstBirthButton.rx.tap
            .map { MakeGiftVM.Action.eventTypeSeleted(.firstBirth) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        mainView.funeralButton.rx.tap
            .map { MakeGiftVM.Action.eventTypeSeleted(.funeral) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        mainView.otherButton.rx.tap
            .map { MakeGiftVM.Action.eventTypeSeleted(.other) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 5. 날짜
        mainView.datePicker.rx.date
            .map { $0.toString(of: .yearMonthDay) }
            .distinctUntilChanged()
            .map { MakeGiftVM.Action.dateChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 6. 메모
        mainView.memoTextView.rx.text.orEmpty
            .distinctUntilChanged()
            .map { MakeGiftVM.Action.memoChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    private func bindState(_ reactor: MakeGiftVM) {
        reactor.state.map { $0.dataForEdit }
            .distinctUntilChanged()
            .subscribe(with: self) { owner , item in
                if let item {
                    owner.mainView.setUp(item)
                }
            }
            .disposed(by: disposeBag)
        
        // 2. 전한 or 받은
        reactor.state.map { $0.currentData.giftType }
            .distinctUntilChanged()
            .subscribe(with: self) { owner , type  in
                owner.mainView.setGiftTypeButton(type)
            }
            .disposed(by: disposeBag)
        
        // 4. 이벤트
        reactor.state.map { $0.currentData.eventType }
            .distinctUntilChanged()
            .subscribe(with: self) { owner , type  in
                owner.mainView.setEventTypeButton(type)
            }
            .disposed(by: disposeBag)
        
        // 5. 날짜
        reactor.state.map { $0.currentData.date }
            .map { $0.toDate(to: .yearMonthDay)?.toString(of: .yearMonthDayWithDot) }
            .distinctUntilChanged()
            .subscribe(with: self) { owner , str  in
                owner.mainView.dateTextField.text = str
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - private func
extension MakeGiftVC {
    private func setItemForEdit() {
        if case .edit(let id) = self.type {
            reactor?.action.onNext(.loadDataForEdit(id: id))
        }
    }
}


// MARK: - Keyboard
extension MakeGiftVC {
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        print(#function)
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        // 키보드 높이에 따라 텍스트뷰의 inset 조정
        mainView.scrollView.contentInset.bottom = keyboardHeight
        mainView.scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
        
//        // 커서 위치를 키보드 위로 올리기
//        if let selectedRange = mainView.memoTextView.selectedTextRange {
//            mainView.memoTextView.scrollRangeToVisible(mainView.memoTextView.selectedRange)
//            DispatchQueue.main.async {
//                let caretRect = self.mainView.memoTextView.caretRect(for: selectedRange.start)
//                self.mainView.scrollView.scrollRectToVisible(caretRect, animated: true)
//            }
//        }
    }
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        print(#function)
        // 키보드가 내려갈 때 inset 초기화
        mainView.scrollView.contentInset.bottom = 0
        mainView.scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
}


// MARK: - Navigation
extension MakeGiftVC {
    private func setNavigation() {
        let cancelButton = UIBarButtonItem(
            image: .xButton,
            style: .plain,
            target: self ,
            action: #selector(cancelButtonClicked)
        )
        
        let saveButton = UIBarButtonItem(
            title: self.type?.completeButtonName,
            style: .plain ,
            target: self ,
            action: #selector(saveButtonClicked)
        )
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = saveButton
        
        setNavigationTintColor(.black)
        navigationItem.title = String(localized: "기록")
    }
    
    @objc
    private func cancelButtonClicked() {
        Logger.print(#function)
        self.dismiss(animated: true)
    }
    
    @objc
    private func saveButtonClicked() {
        Logger.print(#function)
        if case .create = self.type {
            reactor?.action.onNext(.save)
        } else {
            reactor?.action.onNext(.edit)
        }
        
        self.dismiss(animated: true)
    }
}


// MARK: - VCPurpose
extension MakeGiftVC {
    enum VCPurPose {
        case create
        case edit(id: String)
        
        var completeButtonName: String {
            switch self {
            case .create:
                return String(localized: "저장")
            case .edit(let id):
                return String(localized: "수정")
            }
        }
    }
}
