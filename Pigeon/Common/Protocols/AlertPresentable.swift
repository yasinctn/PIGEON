//
//  AlertPresentable.swift
//  Pigeon
//
//  Created by Yasin Cetin on 25.05.2023.
//

import Foundation
import UIKit

protocol AlertPresentable {
    func presentAlert(_ message:String)
    func presentAlertWithAction(identifier: String, alertTitle: String, actionTitle: String)
    func popToRootViewControllerWithAlert(alertTitle: String, actionTitle: String)
}

extension AlertPresentable where Self: UIViewController {
    
    func presentAlert(_ message:String) {
        
        let allert = UIAlertController(title: "Warning!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        allert.addAction(action)
        self.present(allert, animated: true)
    }
    
    func presentAlertWithAction(identifier: String, alertTitle: String, actionTitle: String) {
        let allert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { action in
            self.performSegue(withIdentifier: identifier, sender: action)
        }
        allert.addAction(action)
        self.present(allert, animated: true)
    }
    
    func popToRootViewControllerWithAlert(alertTitle: String, actionTitle: String) {
        let allert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { action in
            self.navigationController?.popToRootViewController(animated: true)
        }
        allert.addAction(action)
        self.present(allert, animated: true)
    }
}
