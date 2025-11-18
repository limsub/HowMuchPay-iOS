//
//  UIViewController+Purchase.swift
//  HowMuchPay
//
//  Created by 임승섭 on 11/18/25.
//

import UIKit
import GoogleMobileAds

extension UIViewController {
    func updateAdVisibility(for bannerView: GADBannerViewWrapper) {
        // 구매 여부에 따라 bannerView hidden 결정
        let hasRemoveAds = StoreManager.shared.isPurchased
        bannerView.isHidden = hasRemoveAds
        
        Logger.print("hasRemoveAds : \(hasRemoveAds)")
        
        // noti 등록해두고, 변경점이 있으면 바로 동작하도록
        NotificationCenter.default.addObserver(forName: StoreManager.purchaseCompletedNotification, object: nil, queue: .main) { _ in
            bannerView.isHidden = true
        }
        NotificationCenter.default.addObserver(forName: StoreManager.restoreCompletedNotification, object: nil, queue: .main) { _ in
            bannerView.isHidden = true
        }
    }
}
