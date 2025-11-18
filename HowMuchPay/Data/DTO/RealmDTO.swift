//
//  RealmDTO.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/1/25.
//

import Foundation
import RealmSwift

class GiftDTO: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var partner: UserInfoDTO?
    @Persisted var giftType: Int    // enum GiftType
    @Persisted var amount: Int
    @Persisted var eventType: Int   // enum EventType
    @Persisted var date: String
    @Persisted var memo: String
    
    convenience init(_ item: GiftItem, userDTO: UserInfoDTO) {  // 기존에 있는 유저라면, realm에서 찾아서 파라미터로 넣어줌.
        self.init()
        
        self.id = item.id
        self.partner = userDTO
        self.giftType = item.giftType.rawValue
        self.amount = item.amount
        self.eventType = item.eventType.rawValue
        self.date = item.date
        self.memo = item.memo
    }
    
    func toDomain() -> GiftItem {
        return .init(
            id: id ,
            partner: partner?.toDomain() ?? UserInfoItem(id: "-1", name: "-1"),
            giftType: GiftType(rawValue: giftType) ?? .given,
            amount: amount,
            eventType: EventType(rawValue: eventType) ?? .other,
            date: date ,
            memo: memo
        )
    }
}


class UserInfoDTO: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    
    // TODO: 나와 거래 내역 종합해서, 얼마 줬고 얼마 받았는지 정보.
    // => 굳이 데이터로 저장하지 않고, 그때그때 추출해서 연산해도 될듯.
    
    convenience init(_ item: UserInfoItem) {
        self.init()
        
        self.id = item.id
        self.name = item.name
    }
    
    func toDomain() -> UserInfoItem {
        return .init(id: id, name: name)
    }
}
