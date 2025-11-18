//
//  PopUpVC.swift
//  PayNote
//
//  Created by 임승섭 on 1/28/25.
//

import UIKit

class ReportPopupViewController: UIViewController {

    private let popupView = BaseView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
    }
    private let titleLabel = UILabel().then {
        $0.font = .title24b
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    private let messageLabel = UILabel().then {
        $0.font = .body18m
        $0.textColor = .darkGray
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    private let cancelButton = UIButton(type: .system).then {
        $0.setTitleColor(.mainBlue, for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.mainBlue.cgColor
    }
    private let actionButton = UIButton(type: .system).then {
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .mainBlue
        $0.layer.cornerRadius = 8
    }

    private var cancelHandler: (() -> Void)?
    private var actionHandler: (() -> Void)?

    init(title: String, message: String, cancelTitle: String, actionTitle: String, cancelHandler: (() -> Void)?, actionHandler: (() -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title
        self.messageLabel.text = message
        self.cancelButton.setTitle(cancelTitle, for: .normal)
        self.actionButton.setTitle(actionTitle, for: .normal)
        self.cancelHandler = cancelHandler
        self.actionHandler = actionHandler
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupActions()
    }

    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        view.addSubview(popupView)
        
        [titleLabel, messageLabel, cancelButton, actionButton].forEach {
            popupView.addSubview($0)
        }
    }

    private func setupLayout() {
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(200)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(popupView).offset(24)
            make.horizontalEdges.equalTo(popupView).inset(20)
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(popupView).inset(20)
        }

        cancelButton.snp.makeConstraints { make in
            make.left.equalTo(popupView).offset(16)
            make.bottom.equalTo(popupView).offset(-16)
            make.height.equalTo(44)
            make.width.equalTo(popupView).multipliedBy(0.43)
        }

        actionButton.snp.makeConstraints { make in
            make.right.equalTo(popupView).offset(-16)
            make.bottom.equalTo(popupView).offset(-16)
            make.height.equalTo(44)
            make.width.equalTo(popupView).multipliedBy(0.43)
        }
    }

    private func setupActions() {
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(actionHandlerTriggered), for: .touchUpInside)
    }

    @objc private func cancelAction() {
        dismiss(animated: true) {
            self.cancelHandler?()
        }
    }

    @objc private func actionHandlerTriggered() {
        dismiss(animated: true) {
            self.actionHandler?()
        }
    }
}
