//
//  SeguePerformable.swift
//  Pigeon
//
//  Created by Yasin Cetin on 25.05.2023.
//

import Foundation
import UIKit

protocol SeguePerformable {
    func performSegue(identifier: String)
}

extension SeguePerformable where Self: UIViewController {
    func performSegue(identifier: String) {
        self.performSegue(withIdentifier: identifier, sender: self)
    }
}
