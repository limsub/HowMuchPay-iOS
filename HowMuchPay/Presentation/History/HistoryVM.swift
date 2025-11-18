//
//  HistoryVM.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/1/25.
//

import Foundation
import ReactorKit

class HistoryVM: Reactor {
    
    let repo = RealmRepository()
    
    enum Action {
        case loadData
        case deleteData(Int)
    }
    
    enum Mutation {
        case setList([HistoryTableViewCellItem])
        case setPrice(Int, Int)
        case pass
    }
    
    struct State {
        var itemList: [HistoryTableViewCellItem] = []
        var price: (Int, Int) = (0, 0)
    }
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadData:
            let itemList = repo.fetchAllGiftDTO()
            let newList = Utils.convertPayItemToHistoryTableViewCellItem(itemList)
            
            let gm = repo.fetchAmountForAllData(.given)
            let rm = repo.fetchAmountForAllData(.received)
            
            return .concat([
                .just(.setList(newList)),
                .just(.setPrice(gm , rm ))
            ])
            
        case .deleteData(let row):
            if row >= currentState.itemList.count { return .just(.pass) }
            let item = currentState.itemList[row]
            Logger.print("selected item : \(item.itemInfo.partner.name)")
            repo.deleteGiftDTO(id: item.itemInfo.id)
            
            return .just(.pass)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setList(let newList):
            newState.itemList = newList
            
        case .setPrice(let gm , let rm):
            newState.price = (gm, rm)
            
        case .pass:
            Logger.print("-- pass --")
        }
        
        return newState
    }
}
