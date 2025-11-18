//
//  UserInfoItem.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/5/25.
//

import Foundation

struct UserInfoItem: Equatable {
    var id: String      // yyyyMMddHHmmss   - Realm 저장을 위한 아이디 하나 필요해보임
    var name: String
}
