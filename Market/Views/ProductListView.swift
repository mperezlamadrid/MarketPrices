//
//  ContentView.swift
//  Market
//
//  Created by Manuel Perez on 20/11/23.
//

import SwiftUI

struct ProductListView: View {
    @StateObject var viewModel = ProductViewModel()
    @State var modal: ModalType? = nil
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.products) { product in
                    Button {
                        modal = .update(product)
                    } label: {
                        HStack{
                            VStack(alignment: .leading) {
                                Text(product.name)
                                    .font(.title3)
                                    .foregroundStyle(Color(.label))
                                Text(product.description)
                                    .font(.caption)
                                    .foregroundStyle(Color(.label))
                            }
                            Spacer()
                            Text(String(product.price.formatted(.currency(code: "COP")))).foregroundStyle(Color(.label))
                        }
                    }
                }.onDelete(perform: viewModel.delete)
            }
            .refreshable {
                do {
                    try await viewModel.fetchProducts()
                } catch {
                    print("❌ error getting products \(error)")
                }
            }
            .listStyle(.plain)
            .navigationTitle(Text("🛒 Products"))
            .toolbar {
                Button {
                    modal = .add
                } label: {
                    Label("Add Product", systemImage: "plus.circle")
                }
            }
        }
        .sheet(item: $modal, onDismiss: {
            Task {
                do {
                    try await viewModel.fetchProducts()
                } catch {
                    print("❌ error getting products \(error)")
                }
            }
        }) { modal in
            switch modal {
            case .add:
                AddUpdateProductView(viewModel: AddUpdateProductViewModel())
            case .update(let product):
                AddUpdateProductView(viewModel: AddUpdateProductViewModel(currentProduct: product))
            }
        }
        .onAppear {
            Task {
                do {
                    try await viewModel.fetchProducts()
                } catch {
                    print("❌ error getting products \(error)")
                }
            }
        }
    }
}

#Preview {
    ProductListView()
}
