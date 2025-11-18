//
//  FriendVM.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/2/25.
//

import Foundation
import ReactorKit

class FriendVM: Reactor {
    
    let repo = RealmRepository()
    
    enum Action {
        case loadData(String)
    }
    
    enum Mutation {
        case setItemList([FriendTableViewCellItem])
        case pass
    }
    
    struct State {
        var itemList: [FriendTableViewCellItem] = []
    }
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadData(let searchText):
            if searchText.isEmpty {
                let result = repo.fetchAllFriendList()
                return .just(.setItemList(result))
            } else {
                let result = repo.fetchFilteredFriendList(searchText: searchText)
                Logger.print("SearchText : \(searchText)")
                Logger.print("result : \(result)")
                return .just(.setItemList(result))
            }
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setItemList(let newList):
            newState.itemList = newList
            
        case .pass:
            Logger.print("-- pass --")
        }
        
        return newState
    }
}
