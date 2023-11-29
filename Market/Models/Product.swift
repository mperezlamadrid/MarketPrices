//
//  Product.swift
//  Market
//
//  Created by Manuel Perez on 20/11/23.
//

import Foundation

struct Product: Identifiable, Codable {
    let id: UUID?
    var name: String
    var description: String
    var price: Int
}
