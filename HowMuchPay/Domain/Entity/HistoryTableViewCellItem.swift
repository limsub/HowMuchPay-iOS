//
//  HistoryTableViewCellItem.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/1/25.
//

import Foundation

struct HistoryTableViewCellItem: Equatable {
    let itemInfo: GiftItem
    
    // For tableView
    let pos: TopMiddleBottom

    enum TopMiddleBottom {
        case top
        case middle
        case bottom
        case single
    }
}

