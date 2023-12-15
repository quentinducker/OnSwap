//
//  AddListingView.swift
//  OnSwap
//
//  Created by Quentin Ducker on 12/13/23.
//

import SwiftUI
import PhotosUI
import SwiftData

struct AddListingView: View {
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var currentUserObject : CurrentUserObject
    
    @State private var productTitle: String = ""
    @State private var productDescription: String = ""
    @State private var productPrice: String = ""
    @State private var productLocation: String = ""
    @State private var productImage: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var isPosted = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack{
                
                if let imageData , let uiImage = UIImage(data: imageData) {
                    HStack{
                        RoundedRectangle(cornerRadius: 10)
                            .aspectRatio(1, contentMode: .fit)
                            .overlay(
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            )
                            .frame(width: 380, height: 300)
                            .background(.clear)
                    }
                }
                
                VStack{
                    TextField("title", text: $productTitle)
                    TextField("price", text: $productPrice)
                    TextField("location", text: $productLocation)
                    TextField("description", text: $productDescription, axis: .vertical)
                    PhotosPicker (selection: $productImage, matching: .images) {
                        Label("Select product image", systemImage: "photo")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.all, 5)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                
                HStack {
                    Spacer()
                    Button(action: addProduct){
                        Text(isPosted ? "Posted" : "Post")
                        .foregroundStyle(LinearGradient(colors: [.blue, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(.all, 10)
                        .disabled(isPosted)
                    }
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))


                }.padding(.top, 20)
            }
            .padding(.horizontal, 20)
            .task(id: productImage ) {
                if let data = try? await productImage?.loadTransferable(type: Data.self)
                {
                    imageData = data
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {dismiss()} ,
                       label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.white)
                })
            }
        }
    }
    
    func addProduct() {
        guard !isPosted, let imageData, let productPrice = Double(productPrice), !productTitle.isEmpty else { print("form invalid"); return }
        
        let product = Product(title: productTitle, descriptionText: productDescription, price: productPrice, location: productLocation, image: imageData, soldBy: nil)
            context.insert(product)
            product.soldBy = currentUserObject.currentUser
            isPosted = true
            dismiss()
    }
}
