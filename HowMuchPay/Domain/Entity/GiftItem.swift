//
//  HistoryItem.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/1/25.
//

import UIKit

struct GiftItem: Equatable {
    var id: String              // yyyyMMddHHmmss
    var partner: UserInfoItem   // 상대 정보
    var giftType: GiftType      // 준 vs. 받은
    var amount: Int             // 금액
    var eventType: EventType    // 결혼식, 돌잔치, 장례식, 기타
    var date: String            // 날짜. yyyyMMdd
    var memo: String            // 메모
}




enum GiftType: Int {
    case given
    case received
    
    var description: String {
        switch self {
        case .given:
            return String(localized: "전한 마음")
        case .received:
            return String(localized: "받은 마음")
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .given:
            return .errorRed
        case .received:
            return .mainBlue
        }
    }
}


enum EventType: Int {
    case wedding
    case firstBirth
    case funeral
    case other
    
    var description: String {
        switch self {
        case .wedding:
            return "결혼식"
        case .firstBirth:
            return "돌잔치"
        case .funeral:
            return "장례식"
        case .other:
            return "기타"
        }
    }
}
