//
//  MainTabVC.swift
//  HowMuchPay
//
//  Created by 임승섭 on 2/1/25.
//

import UIKit


class HomeTabViewController: UITabBarController {
    
    let historyVC = HistoryVC(HistoryVM())
    let friendVC = FriendVC(FriendVM())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setValue(CustomTabBar(), forKey: "tabBar")
        
        
        view.backgroundColor = .clear
        

        
        UITabBar.clearShadow()
        tabBar.layer.applyShadow()
        
        tabBar.tintColor = .mainBlue
        
        tabBarController?.tabBar.backgroundColor = .white
    
        tabBar.layer.cornerRadius = 30
        

        
        historyVC.tabBarItem.image = UIImage(systemName: "creditcard")
        friendVC.tabBarItem.image = UIImage(systemName: "list.bullet.clipboard")
        
        
        [historyVC, friendVC].forEach { vc in
            vc.tabBarItem.imageInsets = UIEdgeInsets(
                top: -10,
                left: 0,
                bottom: 0,
                right: 0
            )
            vc.title = nil
        }

        let navHistoryVC = UINavigationController(rootViewController: historyVC)
        let navFriendVC = UINavigationController(rootViewController: friendVC)

        let tabItem = [navHistoryVC, navFriendVC]
        self.viewControllers = tabItem
        
        setViewControllers(tabItem, animated: true)
    }
}



extension CALayer {
    // Sketch 스타일의 그림자를 생성한다
    func applyShadow(color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4) {
        
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
}

extension UITabBar {
    // 기본 그림자 스타일을 초기화해서, 커스텀 스타일을 적용할 준비를 한다
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}


class CustomTabBar:  UITabBar {
    private let customHeight: CGFloat = 70
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = customHeight
        return sizeThatFits
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let offsetY: CGFloat = 20  // 아이콘을 위로 이동시킬 높이
        for subview in subviews {
            if let tabBarButton = subview as? UIControl {
                tabBarButton.frame.origin.y += offsetY
            }
        }
    }
}
