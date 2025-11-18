//
//  GADBannerViewWrapper.swift
//  Yeoun
//
//  Created by 임승섭 on 10/18/25.
//

import UIKit
import GoogleMobileAds

final class GADBannerViewWrapper: BannerView {
    
    init(type: AdmobType) {
        // ✅ GADBannerView의 designated initializer를 명시적으로 호출
        super.init(adSize: AdSizeBanner, origin: .zero)
        setupBanner(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBanner(type: AdmobType) {
        self.alpha = 1
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let isMyDevice = UserDefaults.standard.bool(forKey: "isMyDevice")
        self.adUnitID = isMyDevice ? type.testBannerID : type.AdUnitID
        
        Logger.print("isMyDevice : \(isMyDevice)")
        
        let request = Request()
        self.load(request)
    }
}
