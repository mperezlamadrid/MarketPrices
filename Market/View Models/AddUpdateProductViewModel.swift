//
//  AddUpdateProductViewModel.swift
//  Market
//
//  Created by Manuel Perez on 20/11/23.
//

import Foundation

final class AddUpdateProductViewModel: ObservableObject {
    @Published var productName = ""
    @Published var productDescription = ""
    @Published var productPrice = 0
    
    var productID: UUID?
    
    var isUpdating: Bool {
        productID != nil
    }
    
    var buttonTitle: String {
        productID != nil ?  "Update Product" : "Add Product"
    }
    
    init() {}
        
    init(currentProduct: Product) {
        self.productName = currentProduct.name
        self.productDescription = currentProduct.description
        self.productPrice = currentProduct.price
        self.productID = currentProduct.id
    }
    
    func addProduct() async throws {
        let urlString = Constants.baseURL + Endpoints.products
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        let product = Product(id: nil, name: productName, description: productDescription, price: productPrice)
        
        try await HttpClient.shared.sendData(to: url, object: product, httpMethod: HttpMethods.POST.rawValue)
    }
    
    func updateProduct() async throws {
        let urlString = Constants.baseURL + Endpoints.products
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        let productToUpdate = Product(id: productID, name: productName, description: productDescription, price: productPrice)
        
        try await HttpClient.shared.sendData(to: url, object: productToUpdate, httpMethod: HttpMethods.PUT.rawValue)
    }
    
    func addUpdateAction(completion: @escaping () -> Void) {
        Task {
            do {
                if isUpdating {
                    try await updateProduct()
                } else {
                    try await addProduct()
                }
            } catch {
                print("❌ error running the action \(error)")
            }
            completion()
        }
    }
}
