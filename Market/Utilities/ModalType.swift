//
//  ModalType.swift
//  Market
//
//  Created by Manuel Perez on 20/11/23.
//

import Foundation

enum ModalType: Identifiable {
    var id: String {
        switch self {
        case .add: return "add"
        case .update: return "update"
        }
    }
    
    case add
    case update(Product)
}
