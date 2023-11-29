//
//  ProductViewModel.swift
//  Market
//
//  Created by Manuel Perez on 20/11/23.
//

import SwiftUI

class ProductViewModel: ObservableObject {
    @Published var products = [Product]()
        
    func fetchProducts() async throws {
        let urlString = Constants.baseURL + Endpoints.products
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        let productResponse: [Product] = try await HttpClient.shared.fetch(url: url)
        
        DispatchQueue.main.async {
            self.products = productResponse
        }
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { i in
            guard let productID = products[i].id else {
                return
            }
            
            guard let url = URL(string: Constants.baseURL + Endpoints.products + "/\(productID)") else {
                return
            }
            
            Task {
                do {
                    try await HttpClient.shared.delete(at: productID, url: url)
                } catch {
                    print("❌ error deleting product \(error)")
                }
            }
        }
        
        products.remove(atOffsets: offsets)
    }
}
