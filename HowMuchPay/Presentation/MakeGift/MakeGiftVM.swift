//
//  MakeGiftVM.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/1/25.
//

import ReactorKit
import Foundation

class MakeGiftVM: Reactor {
    
    let repo = RealmRepository()
    
    enum Action {
        case loadDataForEdit(id: String)
        
        case partnerNameChanged(String)
        case giftTypeSelected(GiftType)
        case amountChanged(Int)
        case eventTypeSeleted(EventType)
        case dateChanged(String)
        case memoChanged(String)
        
        case save
        case edit
    }
    
    enum Mutation {
        case setDataForEdit(GiftItem?)
        
        case setPartnerName(String)
        case setGiftType(GiftType)
        case setAmount(Int)
        case setEventType(EventType)
        case setDate(String)
        case setMemo(String)
        
        case pass
    }
    
    struct State {
        var dataForEdit: GiftItem?
        
        var currentData: GiftItem = GiftItem(
            id: Date().toString(of: .dtoID),
            partner: UserInfoItem(
                id: Date().toString(of: .dtoID),
                name: ""
            ),
            giftType: .given,
            amount: 0,
            eventType: .other,
            date: Date().toString(of: .yearMonthDay),
            memo: ""
        )
    }
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadDataForEdit(let id):
            let result = repo.fetchOneGiftData(id)
            return .just(.setDataForEdit(result))
            
        case .partnerNameChanged(let name):
            return .just(.setPartnerName(name))
        case .giftTypeSelected(let gift):
            return .just(.setGiftType(gift))
        case .amountChanged(let amount):
            return .just(.setAmount(amount))
        case .eventTypeSeleted(let event):
            return .just(.setEventType(event))
        case .dateChanged(let date):
            return .just(.setDate(date))
        case .memoChanged(let memo):
            return .just(.setMemo(memo))
            
        case .save:
            let item = currentState.currentData
            repo.addGiftDTO(item)
            return .just(.pass)
            
        case .edit:
            let item = currentState.currentData
            repo.updateGiftData(item)
            return .just(.pass)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setDataForEdit(let item):
            newState.dataForEdit = item
            if let item {
                newState.currentData = item
            }
            
        case .setPartnerName(let name):
            newState.currentData.partner = UserInfoItem(id: Date().toString(of: .dtoID), name: name)
            Logger.print("setPartnerName")
        case .setGiftType(let gift):
            newState.currentData.giftType = gift
            Logger.print("setGiftType : \(gift)")
        case .setAmount(let amount):
            newState.currentData.amount = amount
            Logger.print("set Amount")
        case .setEventType(let event):
            newState.currentData.eventType = event
            Logger.print("set EventType")
        case .setDate(let date):
            newState.currentData.date = date
            Logger.print("set Data")
        case .setMemo(let memo):
            newState.currentData.memo = memo
            Logger.print("set Memo")
        case .pass:
            Logger.print("-- pass --")
        }
        
        return newState
    }
}
