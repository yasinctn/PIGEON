//
//  Collection+Extensions.swift
//  Pigeon
//
//  Created by Yasin Cetin on 27.05.2023.
//

import Foundation

extension Collection {
    
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

