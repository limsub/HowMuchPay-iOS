//
//  Utils.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/1/25.
//

import Foundation

class Utils {
    static func formatWithComma(_ input: String) -> String {
        // 기존 쉼표 제거 후 숫자로 변환 시도
        let cleanedInput = input.replacingOccurrences(of: ",", with: "")
        
        guard let number = Double(cleanedInput) else { return input } // 숫자로 변환 불가 시 원본 반환

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // 3자리마다 쉼표 추가 스타일
        formatter.maximumFractionDigits = 0 // 소수점 제거

        return formatter.string(from: NSNumber(value: number)) ?? input
    }
    
    static func removeCommas(_ input: String) -> String {
        return input.replacingOccurrences(of: ",", with: "")
    }
    
    static func convertPayItemToHistoryTableViewCellItem(_ itemList: [GiftItem]) -> [HistoryTableViewCellItem] {
        
        var result: [HistoryTableViewCellItem] = []
        var currentMonth: String? = nil
        
        let sortedItemList = itemList.sorted { $0.date > $1.date }
        
        for (index, item) in sortedItemList.enumerated() {
            let dateMonth = String(item.date.prefix(6))   // yyyyMM 추출
            
            // 매 달의 처음에는 "yyyyMM" 데이터 삽입
            if currentMonth != dateMonth {
                currentMonth = dateMonth
                
                // 의미 없는 값
                let headerData = HistoryTableViewCellItem(
                    itemInfo: GiftItem(
                        id: "-1",
                        partner: UserInfoItem(
                            id: "-1",
                            name: "-1"
                        ),
                        giftType: .given,
                        amount: -1,
                        eventType: .other,
                        date: dateMonth,    // "yyyyMM" 형태
                        memo: "-1"
                    ),
                    pos: .single   // 헤더는 혼자로 간주
                )
                
                result.append(headerData)
            }
            
            // 각 데이터의 위치(Top/Middle/Bottom/Single) 결정
            let pos: HistoryTableViewCellItem.TopMiddleBottom

            let isFirstInMonth = index == 0 || String(sortedItemList[index - 1].date.prefix(6)) != dateMonth
            let isLastInMonth = index == sortedItemList.count - 1 || String(sortedItemList[index + 1].date.prefix(6)) != dateMonth


            if isFirstInMonth && isLastInMonth {
                pos = .single
            } else if isFirstInMonth {
                pos = .top
            } else if isLastInMonth {
                pos = .bottom
            } else {
                pos = .middle
            }
            
            // 실제 데이터를 변환하여 추가
            let cellItem = HistoryTableViewCellItem(
                itemInfo: GiftItem(
                    id: item.id ,
                    partner: item.partner,
                    giftType: item.giftType,
                    amount: item.amount,
                    eventType: item.eventType,
                    date: item.date,
                    memo: item.memo
                ),
                pos: pos
            )
            result.append(cellItem)
        }
        return result
    }

}
