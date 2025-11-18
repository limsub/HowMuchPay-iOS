//
//  AdmobType.swift
//  Yeoun
//
//  Created by 임승섭 on 10/18/25.
//

import UIKit
import GoogleMobileAds

enum AdmobType {
    case tabbarBanner
    case friendVCBanner

    var AdUnitID: String {
        switch self {
        case .tabbarBanner:
            return "ca-app-pub-8155830639201287/7243221927"
        case .friendVCBanner:
            return "ca-app-pub-8155830639201287/9332984594"
        }
    }
    
    var testBannerID: String {
        return "ca-app-pub-3940256099942544/2435281174"
    }
}
