//
//  testView.swift
//  OnSwap
//
//  Created by Quentin Ducker on 12/12/23.
//

import SwiftUI
import PhotosUI
import SwiftData

struct SingleProductView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @Query private var products: [Product]
    @State private var isBought = false
    @State private var isSaved : Bool = false
    @Bindable var product : Product
    @EnvironmentObject var currentUserObject: CurrentUserObject
    
    var body: some View {
        if product.soldBy != nil {
            VStack {
                if let uiImage = UIImage(data: product.image) {
                    RoundedRectangle(cornerRadius: 10)
                        .aspectRatio(1, contentMode: .fit)
                        .overlay(
                            Image(uiImage: uiImage)
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        )
                        .frame(width: 380, height: 300)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                        .background(LinearGradient(colors: [.indigo, .blue], startPoint: .leading, endPoint: .trailing))
                    
                }
                HStack{
                    Text(product.title)
                        .bold()
                        .foregroundStyle(LinearGradient(colors: [.indigo, .blue], startPoint: .leading, endPoint: .trailing))
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(product.price, format: .currency(code: "USD"))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .bold()
                        .foregroundStyle(LinearGradient(colors: [.indigo, .blue], startPoint: .leading, endPoint: .trailing))
                }
                .padding(.horizontal, 20)
                
                Text(product.location)
                    .textScale(.secondary)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                ZStack {
                    LinearGradient(colors: [.indigo, .blue], startPoint: .leading, endPoint: .trailing)
                    Text(product.descriptionText)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(.all, 20)
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.all, 20)
                
                HStack {
                    Spacer()
                    
                    Button( isBought ? "Bought" : "Buy" ) {
                        guard !isBought && !product.isDeleted else { return }
                        
                        for theProduct in products {
                            if theProduct == product {
                                do {
                                    context.delete(theProduct)
                                    try context.save()
                                    isBought = true
                                    print("bought")
                                    dismiss()
                                } catch {
                                    dismiss()
                                    fatalError("Something went wrong while buying")
                                }
                            }
                        }
                    }
                    .foregroundStyle(.white)
                    .padding(.all, 10)
                    .background(.pink)
                    .clipShape(.capsule)
                    .disabled(isBought)
                    
                    Spacer()
                    
                    Button(isSaved ? "Saved" : "Save") {
                        guard !isSaved else { print("already saved"); return}
                        
                        currentUserObject.currentUser!.itemsSaved.append(product)
                        isSaved = true
                        print("added to saved")
                    }
                    .foregroundStyle(.white)
                    .padding(.all, 10)
                    .background(.blue)
                    .clipShape(.capsule)
                    .disabled(isSaved)
                    
                    Spacer()
                }
                ZStack {
                    LinearGradient(colors: [.indigo, .blue], startPoint: .leading, endPoint: .trailing)
                    
                    VStack {
                        
                        HStack {
                            if let userProfilePic = UIImage(data: product.soldBy!.profilePicture) {
                                Image(uiImage: userProfilePic)
                                    .resizable()
                                    .scaledToFit()
                                    .frame( maxWidth: 50, maxHeight: 50 )
                                    .clipShape(.circle)
                                    .padding(.leading, 20)
                                
                            }
                            Text(product.soldBy!.username)
                                .foregroundStyle(.white)
                                .bold()
                            Spacer()
                        }
                        HStack{
                            Spacer()
                            if product.soldBy!.rating != Rating.none {
                                ForEach( (1...Int(product.soldBy!.rating.stringValue())! ), id: \.self ){ star in
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(.yellow)
                                }
                            }
                            Spacer()
                                .frame(width: 0)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.vertical, 20)
                    NavigationLink(destination: ProfileView( userBeingViewed: product.soldBy! ) ) {
                        Text("")
                            .frame(maxWidth: .infinity, maxHeight: 100)
                        
                    }
                    .environmentObject(currentUserObject)
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .navigationBarBackButtonHidden()
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() } , label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.white)
                    })
                }
            }
            .onAppear() {
                isSaved = isItemSaved(user: currentUserObject.currentUser!, product: product)
                print(isSaved)
            }
        }
    }
    
    func isItemSaved(user: User, product: Product) -> Bool {
        print(product.title)
        if (currentUserObject.currentUser?.itemsSaved.count == 0) { return false }
        for item in user.itemsSaved {
            if item == product {
                return true
            }
        }
        return false
    }
}
