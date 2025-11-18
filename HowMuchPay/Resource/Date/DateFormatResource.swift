//
//  DateFormatResource.swift
//  LifeMovie
//
//  Created by 임승섭 on 12/26/24.
//

import Foundation

extension Date {
    func toString(of type: DateFormatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        
        if let locale = type.locale {
            dateFormatter.locale = type.locale
        }
        
        return dateFormatter.string(from: self)
    }
    
    // MARK: - for localized
    func toDetailViewLocalized() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = String(localized: "yyyy년 M월 d일 a h시 mm분") // January 26, 2025, 4:48 PM
        return dateFormatter.string(from: self)
    }
    
    func toStringYearMonthLocalized() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = String(localized: "yyyy년 M월") // January 26, 2025, 4:48 PM
        return dateFormatter.string(from: self)
    }
}

extension String {
    func toDate(to type: DateFormatType) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.date(from: self)
    }
}

enum DateFormatType: String {
    case monthDayWithSlash = "MM/dd"
    case yearMonth = "yyyyMM"
    case yearMonthDay = "yyyyMMdd"
    case yearMonthDayWithDot = "yyyy.MM.dd"
    case dtoID = "yyyyMMddHHmmss"
}

extension DateFormatType {
    var locale: Locale? {
        switch self {
//        case .onlyDay:
//            return Locale(identifier: "en_US_POSIX")
//            
//        case .fulldate, .yearMonthKorean, .fullKorean:
//            return Locale(identifier: "en")
//            
        default:
            return nil
        }
    }
}
