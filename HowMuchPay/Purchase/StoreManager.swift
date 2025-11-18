//
//  StoreManager.swift
//  HowMuchPay
//
//  Created by 임승섭 on 11/18/25.
//

import Foundation
import StoreKit

// 인앱 결제 관련 전체 로직을 관리하는 singleton
final class StoreManager: NSObject, ObservableObject {
    static let shared = StoreManager()
    
    @Published var isPurchased: Bool = UserDefaults.standard.bool(forKey: "isRemoveAdsPurchased")
    private var products: [SKProduct] = []          // App store에서 받아온 상품 리스트
    private var productID = "com.howmuchpay.noAds"  // 제품 ID (App Store Connect에 등록된 ID)
    
    // 구매 및 복원 완료를 알리는 notification
    // - 실시간으로 noti 받아서 banner를 hidden 처리하고, 구매 or 복원 성공 팝업 창을 띄워주기 위함
    static let purchaseCompletedNotification = Notification.Name("purchasedCompleted")
    static let restoreCompletedNotification = Notification.Name("restoreCompleted")
    
    private override init() {
        super.init()
        
        SKPaymentQueue.default().add(self)  // 결제 큐에 observer 등록 (결제 이벤트 수신)
    }
}


// ✅ Public functions
extension StoreManager {
    // MARK: 앱 초기 실행 시 구매 상태 복원 확인 (⚽️ AppDelegate에서 실행)
    func initializePurchaseStatus() {
        // 이미 UserDefaults가 true이면 추가 작업 불필요
        if UserDefaults.standard.bool(forKey: "isRemoveAdsPurchased") {
            Logger.print("이미 광고 제거 구매 상태로 저장되어 있음")
            
            isPurchased = true
            return;
        }
        
        // App Store로부터 복원 요청
        Logger.print("앱 시작 시 복원 요청 실행")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    
    // MARK: 상품 정보 요청 함수 (⚽️ AppDelegate 및 광고 제거 팝업 시 호출)
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: [productID])
        request.delegate = self
        request.start() // 요청 시작
    }
    
    
    // MARK: 결제 요청 (⚽️ 광고 제거 버튼 클릭 시 호출)
    func purchase() {
        guard let product = products.first else {
            // 상품이 없으면 종료
            return;
        }
        
        let payment = SKPayment(product: product)   // 결제 객체 생성
        SKPaymentQueue.default().add(payment)       // 결제 요청을 위해 큐에 추가
    }
    
    
    // MARK: 복원 요청 (⚽️ 광고 복원 버튼 클릭 시 호출)
    func restore() {
        SKPaymentQueue.default().restoreCompletedTransactions() // 복원 요청
    }
}


// ✅ Private functions
extension StoreManager {
    // 구매 성공 시 실행되는 completionHandler
    private func handlePurchaseSuccess() {
        isPurchased = true
        UserDefaults.standard.set(true, forKey: "isRemoveAdsPurchased")
        
        // noti
        NotificationCenter.default.post(name: StoreManager.purchaseCompletedNotification, object: nil)
    }
    
    // 복원 성공 시 실행되는 completionHandler
    private func handleRestoreSuccess() {
        isPurchased = true;
        UserDefaults.standard.set(true, forKey: "isRemoveAdsPurchased")
        
        // noti
        NotificationCenter.default.post(name: StoreManager.restoreCompletedNotification, object: nil)
    }
}


extension StoreManager: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    // App store에서 상품 정보를 성공적으로 받아왔을 때 호출
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products    // 상품 리스트 저장
    }
    
    
    // 결제 진행 중 상태가 변경될 때마다 호출
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        Logger.print(#function)
        
        for transaction in transactions {
            Logger.print(transaction.transactionState)

            switch transaction.transactionState {
            case .purchased:
                handlePurchaseSuccess()     // 구매 완료 처리
                SKPaymentQueue.default().finishTransaction(transaction) // 거래 종료
            
            case .restored:
                handleRestoreSuccess()      // 복원 완료 처리
                SKPaymentQueue.default().finishTransaction(transaction) // 거래 종료
                
            case .failed:
                if let error = transaction.error {
                    Logger.print("결제 실패 : \(error.localizedDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction) // 거래 종료
                
            default:
                break;
            }
        }
    }
}
