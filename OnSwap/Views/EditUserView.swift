//
//  EditUserView.swift
//  OnSwap
//
//  Created by Quentin Ducker on 12/11/23.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditUserView: View {
    @Environment(\.modelContext) var context
    @Bindable var user : User
    
    
    @State private var productTitle: String = ""
    @State private var productDescription: String = ""
    @State private var productPrice: String = ""
    @State private var productLocation: String = ""
    @State private var productImage: PhotosPickerItem?
    @State private var imageData: Data?
    
    private let currencyFormat: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var body: some View {
        Form{
            TextField("username", text: $user.username)
            TextField("password", text: $user.password)
            Section {
                Picker("rating", selection: $user.rating) {
                    ForEach(Rating.allCases, id: \.self) { ratingOption in
                        let ratingString = ratingOption.stringValue()
                        Text(ratingString).tag(ratingOption)
                    }
                }
            }
            
            
            TextField("title", text: $productTitle)
            TextField("description", text: $productDescription, axis: .vertical)
            TextField("price", text: $productPrice)
                .keyboardType(.decimalPad)
            TextField("location", text: $productLocation)
            
            if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            }
            PhotosPicker(selection: $productImage, matching: .images, photoLibrary: .shared()) {
                Label("select an image of the item", systemImage: "photo")
            }
            
            Section("Products") {
                ForEach(user.itemsSelling) {itemSelling in
                    HStack {
                        Text(itemSelling.title)
                        Button("info") {
                            print(itemSelling.title)
                            print(itemSelling.soldBy!.username)
                            print(itemSelling.descriptionText)
                            print(itemSelling.price)
                            print(itemSelling.soldBy!.itemsSelling.count)
                        }
                    }
                }
            }
        }
        .toolbar {
            Button("Add", action: addProduct)
        }
        .navigationTitle(user.username)
        .task(id: productImage) {
            if let data = try? await productImage?.loadTransferable(type: Data.self) {
                imageData = data
            }
        }
    }
    
    func addProduct() {
        guard let imageData else { print("image data is null"); return }
        guard !productTitle.isEmpty else { print("prouct title is null"); return }
        guard let price = Double(productPrice) else { print("price invalid"); return }
        
        let product = Product(title: productTitle, descriptionText: productDescription, price: price, location: productLocation, image: imageData, soldBy: nil)
        context.insert(product)
        product.soldBy = user
        try? context.save()
        print("product added")
    }
}
