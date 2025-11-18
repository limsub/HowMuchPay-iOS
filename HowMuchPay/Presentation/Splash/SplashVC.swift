//
//  SplashVC.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/2/25.
//


import UIKit
import ReactorKit

class SplashVC: BaseViewController {
    
    let mainView = SplashView()
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showHomeView()
    }
}


// MARK: - private func
extension SplashVC {
    private func showHomeView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let vc = HomeTabViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .overFullScreen
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true)
        }
    }
}
