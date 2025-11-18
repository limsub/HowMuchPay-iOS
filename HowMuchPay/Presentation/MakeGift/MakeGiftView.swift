//
//  MakeGiftView.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/1/25.
//

import UIKit

class MakeGiftView: BaseView {
    
    // MARK: - UI Components
    // 1. 상대 이름
    // 1.5. 기존 상대 정보 - 보류. 걍 알아서 검색해서 수정하든가 하라고 할까.
    // 2. 전한 or 받은
    // 3. 금액
    // 4. 이벤트 (결혼식, 돌잔치, 장례식, 기타) - 기타는 알아서 메모에 적도록. 최대한 선택지 많이 주기. - 싫어.
    // 5. 날짜 - 디폴트는 오늘 날짜
    // 6. 메모 (기타 선택한 사람은 이게 필요할 수도 있으니까.
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    // 1. 상대 이름
    let partnerNameLabel        = SettingTitleLabel(String(localized: "이름 입력"))
    let partnerNameTextField    = SettingTextField("이름을 입력해주세요")
    
    // 2. 전한 or 받은
    let giftTypeLabel           = SettingTitleLabel(String(localized: "유형 선택"))
    let givenButton      = SettingTypeButton(GiftType.given.description)
    let receivedButton    = SettingTypeButton(GiftType.received.description)
    lazy var giftTypeButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.distribution = .fillEqually
    }
    
    // 3. 금액
    let amountLabel         = SettingTitleLabel(String(localized: "금액 입력"))
    let amountTextField     = PriceTextFieldView()
     
    // 4. 이벤트
    let eventTypeLabel          = SettingTitleLabel(String(localized: "경조사 종류 선택"))
    let weddingButton       = SettingTypeButton(EventType.wedding.description)
    let firstBirthButton    = SettingTypeButton(EventType.firstBirth.description)
    let funeralButton       = SettingTypeButton(EventType.funeral.description)
    let otherButton         = SettingTypeButton(EventType.other.description)
    lazy var eventTypeButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.distribution = .fillEqually
    }
    
    // 5. 날짜
    let dateLabel           = SettingTitleLabel(String(localized: "날짜 입력"))
    lazy var dateTextField  = DateTextField("0000.00.00")
    let datePicker = UIDatePicker().then {
        $0.preferredDatePickerStyle = .wheels
        $0.datePickerMode = .date
    }

    // 6. 메모
    let memoLabel           = SettingTitleLabel(String(localized: "메모 입력"))
    let memoTextView        = SettingTextView(placeholderText: String(localized: "추가로 기록할 내용이 있나요?"), limitCnt: 200)
    let memoSubtitleLabel   = SettingSubtitleLabel(String(localized: "200자 내로 입력해주세요"))
    
    
    
    // MARK: - Layouts
    override func addSubViews() {
        super.addSubViews()
        
        // scrollView
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // stackView
        [givenButton, receivedButton].forEach {
            giftTypeButtonStackView.addArrangedSubview($0)
        }
        [weddingButton, firstBirthButton, funeralButton, otherButton].forEach {
            eventTypeButtonStackView.addArrangedSubview($0)
        }
        
        // contentView
        [partnerNameLabel, partnerNameTextField,
         giftTypeLabel, giftTypeButtonStackView,
         amountLabel, amountTextField,
         eventTypeLabel, eventTypeButtonStackView,
         dateLabel, dateTextField,
         memoLabel, memoTextView, memoSubtitleLabel
        ].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        // 0. 스크롤뷰
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalTo(self)
        }
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView)
            make.horizontalEdges.bottom.equalTo(scrollView.contentLayoutGuide)
            make.height.greaterThanOrEqualTo(scrollView.snp.height).priority(.low)
            make.width.equalTo(scrollView)
        }
        
        // 1. 상대 이름
        partnerNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(36)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        partnerNameTextField.snp.makeConstraints { make in
            make.top.equalTo(partnerNameLabel.snp.bottom).offset(8)
            make.height.equalTo(52)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        // 2. 전한 or 받은
        giftTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(partnerNameTextField.snp.bottom).offset(36)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        giftTypeButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(giftTypeLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        // 3. 금액
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(giftTypeButtonStackView.snp.bottom).offset(36)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(8)
            make.height.equalTo(52)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        // 4. 이벤트
        eventTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(36)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        eventTypeButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(eventTypeLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        // 5. 날짜
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(eventTypeButtonStackView.snp.bottom).offset(36)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.height.equalTo(52)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        // 6. 메모
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(36)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(8)
            make.height.equalTo(260)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        memoSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(memoTextView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(contentView).inset(12)
        }
    }
    
    
    override func configures() {
        super.configures()
        
        self.backgroundColor = .systemBackground
        dateTextField.inputView = datePicker
        dateTextField.text = Date().toString(of: .yearMonthDayWithDot)
    }
    
    
    // MARK: - Functions
    func setUp(_ item: GiftItem) {
        partnerNameTextField.text           = item.partner.name
        
        setGiftTypeButton(item.giftType)
        
        amountTextField.textField.text      = Utils.formatWithComma(String(item.amount))
        
        setEventTypeButton(item.eventType)
        
        dateTextField.text = item.date.toDate(to: .yearMonthDay)?.toString(of: .yearMonthDayWithDot)
        memoTextView.text = item.memo
    }
    
    func setGiftTypeButton(_ type: GiftType) {
        switch type {
        case .given:
            givenButton.setUp(true )
            receivedButton.setUp(false )
            
        case .received:
            givenButton.setUp(false )
            receivedButton.setUp(true )
        }
    }
    
    func setEventTypeButton(_ type: EventType) {
        switch type {
        case .wedding:
            weddingButton.setUp(true )
            firstBirthButton.setUp(false )
            funeralButton.setUp(false )
            otherButton.setUp(false )
            
        case .firstBirth:
            weddingButton.setUp(false )
            firstBirthButton.setUp(true )
            funeralButton.setUp(false )
            otherButton.setUp(false )
            
        case .funeral:
            weddingButton.setUp(false)
            firstBirthButton.setUp(false)
            funeralButton.setUp(true)
            otherButton.setUp(false)
            
        case .other:
            weddingButton.setUp(false)
            firstBirthButton.setUp(false)
            funeralButton.setUp(false)
            otherButton.setUp(true)
        }
    }
}

// MARK: - private func
extension MakeGiftView {
    
}
