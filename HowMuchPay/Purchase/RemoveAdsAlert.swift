//
//  RemoveAdsAlert.swift
//  HowMuchPay
//
//  Created by 임승섭 on 11/18/25.
//

import UIKit

final class RemoveAdsAlert {
    // 광고 제거 팝업 표시 함수
    static func show(in vc: UIViewController) {
        Logger.print(#function)
    
        StoreManager.shared.fetchProducts()
        
        let alert = UIAlertController(
            title: String(localized: "광고 제거🍀"),
            message: String(localized: "앱 사용 시 표기되는 광고를 제거할 수 있습니다."),
            preferredStyle: .alert
        )
        
        // 광고 제거
        let purchaseAction = UIAlertAction(title: String(localized: "광고 제거"), style: .default) { _ in
            StoreManager.shared.purchase()  // 인앱 결제 요청
        }
        
        // 구매 복원
        let restoreAction = UIAlertAction(title: String(localized: "구매 복원"), style: .default) { _ in
            StoreManager.shared.restore()   // 복원 요청
        }
        
        alert.addAction(purchaseAction)
        alert.addAction(restoreAction)
        
        // ✅ NotificationCenter 등록 (구매/복원 완료 시 메시지 표시)
        NotificationCenter.default.addObserver(forName: StoreManager.purchaseCompletedNotification, object: nil, queue: .main) { _ in
            showTemporaryMessage(String(localized: "구매가 정상적으로 완료되었어요"), in: vc, dismissing: alert)
        }
        NotificationCenter.default.addObserver(forName: StoreManager.restoreCompletedNotification, object: nil, queue: .main) { _ in
            showTemporaryMessage(String(localized: "복원이 정상적으로 완료되었어요"), in: vc, dismissing: alert)
        }
        
        // 팝업 표시
        vc.present(alert, animated: true) {
            // alert 표시 이후 실행되는 completion 블록
            
            // 배경 터치 감지를 위한 gesture recognizer 추가
            let tapGesture = UITapGestureRecognizer(target: alert, action: #selector(alert.dismissOnOutsideTap))
            alert.view.superview?.subviews.first?.addGestureRecognizer(tapGesture)
        }
    }
    
    /// ✅ 1초짜리 자동 dismiss 메시지 표시 함수
    private static func showTemporaryMessage(_ text: String, in viewController: UIViewController, dismissing alert: UIAlertController) {
        let messageAlert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        viewController.present(messageAlert, animated: true)
        
        // 1초 뒤 모든 alert 닫기
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            messageAlert.dismiss(animated: true)
            alert.dismiss(animated: true)
            NotificationCenter.default.removeObserver(self)
        }
    }
}

private extension UIAlertController {
    // Alert 바깥 터치 시 닫히도록 하는 함수
    @objc func dismissOnOutsideTap() {
        self.dismiss(animated: true)
    }
}
