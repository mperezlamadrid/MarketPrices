//
//  AddUpdateProduct.swift
//  Market
//
//  Created by Manuel Perez on 20/11/23.
//

import SwiftUI

struct AddUpdateProductView: View {
    @ObservedObject var viewModel: AddUpdateProductViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("Data") {
                        TextField("Name", text: $viewModel.productName)
                        
                        TextField("Description", text: $viewModel.productDescription)
                        
                        TextField("Proce", value: $viewModel.productPrice, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                    }
                    Section{
                        HStack {
                            Spacer()
                            Button {
                                viewModel.addUpdateAction {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            } label: {
                                Text(viewModel.buttonTitle)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle(Text("🥩 Product"))
        }
    }
}

#Preview {
    AddUpdateProductView(viewModel: AddUpdateProductViewModel())
}
