//
//  UIViewController+.swift
//  LifeMovie
//
//  Created by 임승섭 on 12/22/24.
//

import UIKit
import SnapKit


extension UIViewController {
    func setNavigationBackButton() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil
        )
        setNavigationTintColor(.mainBrown)
    }
    
    func setNavigationTintColor(_ color: UIColor) {
        self.navigationController?.navigationBar.tintColor = color
    }
    

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func setCustomNavigationBar(_ view: UIView) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        let navHeight = navigationBar.frame.size.height + 20
        let navWidth = navigationBar.frame.size.width
        
        view.snp.makeConstraints { make in
            make.width.equalTo(navWidth)
            make.height.equalTo(navHeight)
        }
        navigationItem.titleView = view
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil
        )
        self.navigationController?.navigationBar.tintColor = .white 
    }
    
    func showSingleAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: String(localized: "확인"), style: .default)
    
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}
