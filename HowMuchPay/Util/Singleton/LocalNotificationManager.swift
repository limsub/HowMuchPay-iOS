//
//  LocalNotificationManager.swift
//  HowMuchPay
//
//  Created by 임승섭 on 4/27/25.
//

import Foundation
import UserNotifications

final class LocalNotificationManager {
    
    static let shared = LocalNotificationManager()
    
    static let sundayNotificationIdentifier = "com.BeTheCoach.sundayNotificationIdentifier"
    // 알림 설정 화면 없이, 시스테 알림 설정하면 무조건 알림 오도록 구현함.

    private init() { }
    
    func registerNotification() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted && error == nil {
                self.setDailyNotification(center: center)
            } else {
                Logger.print("Noti 거부 또는 오류 : \(error?.localizedDescription)")
            }
        }
    }
    
    private func setDailyNotification(center: UNUserNotificationCenter) {
        cancelAllNotifications()
        
        let content = UNMutableNotificationContent()
        content.title = String(localized: "이번 주 경조사비를 잊지 말고 기록해주세요!")
        content.body = String(localized: "이번주에도 누군가에게 마음을 전하셨나요?")
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.weekday = 1 // 1 : Sunday
        dateComponents.hour = 21   // 21:00
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: LocalNotificationManager.sundayNotificationIdentifier,
            content: content,
            trigger: trigger
        )
        
        center.add(request)
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("모든 로컬 알림 제거 완료")
    }
}
