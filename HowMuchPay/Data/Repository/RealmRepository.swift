//
//  RealmRepository.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/1/25.
//

import Foundation
import RealmSwift

class RealmRepository {
    let realm = try! Realm()
}

// MARK: - Create
extension RealmRepository {
    func addGiftDTO(_ item: GiftItem) {
        let userDTO = findOrCreateUserDTO(userItem: item.partner)
        let giftDTO = GiftDTO(item, userDTO: userDTO)
        
        try? realm.write { realm.add(giftDTO) }
    }
}

// MARK: - Read
extension RealmRepository {
    func fetchAllGiftDTO() -> [GiftItem] {
        let result = realm.objects(GiftDTO.self).map { $0.toDomain() }
        return Array(result)
    }
    
    func fetchAmountForAllData(_ type: GiftType) -> Int {
        let query = "giftType == \(type.rawValue)"
        let result = realm.objects(GiftDTO.self).filter(query).map { $0.toDomain() }
        var amount = 0
        result.forEach { amount += $0.amount }
        return amount
    }
    
    func fetchOneGiftData(_ id: String) -> GiftItem? {
        let result = realm.objects(GiftDTO.self).filter("id == '\(id)'").first.map { $0.toDomain() }
        Logger.print("Fetch One Gift Data : \(result?.partner.name)")
        return result
    }
    
    // 전체 유저 (검색어가 "" 일 때)
    func fetchAllFriendList() -> [FriendTableViewCellItem] {
        let allUser = realm.objects(UserInfoDTO.self)
        var allFriendList: [FriendTableViewCellItem] = []
        
        for user in allUser {
            let givenAmount: Int = realm.objects(GiftDTO.self)
                .filter("partner.id == %@ AND giftType == %@", user.id, GiftType.given.rawValue)
                .sum(ofProperty: "amount")
            
            let receivedAmount: Int = realm.objects(GiftDTO.self)
                .filter("partner.id == %@ AND giftType == %@", user.id, GiftType.received.rawValue)
                .sum(ofProperty: "amount")
            
            let item = FriendTableViewCellItem(
                partner: user.toDomain(),
                givenAmount: givenAmount,
                receivedAmount: receivedAmount
            )
            
            allFriendList.append(item)
        }
        
        return allFriendList.sorted { $0.partner.name < $1.partner.name } // 이름순 정렬
    }
    
    // 특정 유저 (검색어가 있을 때)
    func fetchFilteredFriendList(searchText: String) -> [FriendTableViewCellItem] {
        let filteredUsers = realm.objects(UserInfoDTO.self)
            .filter("name CONTAINS[c] %@", searchText) // 대소문자 구분 없이 포함된 문자열 검색
        
        var filteredFriendList: [FriendTableViewCellItem] = []
        
        for user in filteredUsers {
            let givenAmount: Int = realm.objects(GiftDTO.self)
                .filter("partner.id == %@ AND giftType == %@", user.id, GiftType.given.rawValue)
                .sum(ofProperty: "amount")
            
            let receivedAmount: Int = realm.objects(GiftDTO.self)
                .filter("partner.id == %@ AND giftType == %@", user.id, GiftType.received.rawValue)
                .sum(ofProperty: "amount")
            
            let item = FriendTableViewCellItem(
                partner: user.toDomain(),
                givenAmount: givenAmount,
                receivedAmount: receivedAmount
            )
            
            filteredFriendList.append(item)
        }
        
        return filteredFriendList.sorted { $0.partner.name < $1.partner.name } // 이름순 정렬
    }
}


// MARK: - Update
extension RealmRepository {
    // 특정 id를 가진 GiftDTO를 새로운 값으로 업데이트하는 함수
    func updateGiftData(_ newItem: GiftItem) {
        guard let giftDTO = realm.object(ofType: GiftDTO.self , forPrimaryKey: newItem.id) else {
            print("업데이트 실패: 해당 ID의 GiftDTO를 찾을 수 없음")
            return
        }
        
        let userDTO = findOrCreateUserDTO(userItem: newItem.partner)
        
        try? realm.write {
            giftDTO.giftType = newItem.giftType.rawValue
            giftDTO.amount = newItem.amount
            giftDTO.eventType = newItem.eventType.rawValue
            giftDTO.date = newItem.date
            giftDTO.memo = newItem.memo

            // partner 업데이트 (유저 정보가 변경될 수도 있으므로)
            giftDTO.partner = userDTO
        }
        
        removeUnusedUsers()
    }
}

// MARK: - Delete
extension RealmRepository {
    func deleteGiftDTO(id: String) {
        guard let giftDTO = realm.object(ofType: GiftDTO.self, forPrimaryKey: id) else { return }
        
        try? realm.write {
            realm.delete(giftDTO)
            Logger.print("Delete Success")
        }
        
        removeUnusedUsers()
    }
}


// MARK: - Private func
extension RealmRepository {
    // UserName을 이용해 UserInfoDTO를 찾고, 없으면 새로 생성하는 함수
    private func findOrCreateUserDTO(userItem: UserInfoItem) -> UserInfoDTO {
        if let existingUser = realm.objects(UserInfoDTO.self).filter("name == %@", userItem.name).first {
            return existingUser
        } else {
            let newUser = UserInfoDTO()
            newUser.id = userItem.id
            newUser.name = userItem.name
            
            try? realm.write { realm.add(newUser) }
            
            return newUser
        }
    }
    
    /// GiftDTO가 하나도 없는 UserInfoDTO를 삭제
    func removeUnusedUsers() {
        let allUsers = realm.objects(UserInfoDTO.self) // 모든 사용자 가져오기
        
        for user in allUsers {
            let giftCount = realm.objects(GiftDTO.self).filter("partner.id == %@", user.id).count
            Logger.print("User : \(user.name) ID: \(user.id) Count : \(giftCount)")
            
            if giftCount == 0 {
                if let userDTO = realm.object(ofType: UserInfoDTO.self, forPrimaryKey: user.id) {
                    try? realm.write {
                        realm.delete(userDTO)
                        Logger.print("Delete Success")
                    }
                }
            }
        }
    }
}
