//
//  ProfileView.swift
//  OnSwap
//
//  Created by Quentin Ducker on 12/13/23.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var currentUserObject: CurrentUserObject
    @StateObject var userBeingViewed: User
    
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [.indigo, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack{
                VStack{
                    if let uiImage = UIImage(data: userBeingViewed.profilePicture) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: 100, maxHeight: 100)
                            .clipShape(.circle)
                    }
                    Text(userBeingViewed.username)
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.white)
                    
                    VStack {
                        Text("Items for sale")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.white)
                        ZStack{
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(userBeingViewed.itemsSelling) { itemForSale in
                                        ZStack {
                                            if let uiImage = UIImage(data: itemForSale.image) {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .aspectRatio(1, contentMode: .fit)
                                                    .overlay(
                                                        Image(uiImage: uiImage)
                                                            .resizable()
                                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                                       )
                                                    .frame(width: 200, height: 200)
                                            }
                                            NavigationLink( destination: SingleProductView(product: itemForSale) ) {
                                                Text("")
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            }
                                        }
                                    }
                                }
                                .padding(.all, 5)
                            }
                            .frame(height: 210)
                            .transition(.move(edge: .bottom))
                        }
                        .background(.white)
                        .clipShape( RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)) )
                        
                        if(currentUserObject.currentUser == userBeingViewed) {
                            Text("Items saved")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title3)
                                .bold()
                                .foregroundStyle(.white)
                            ZStack {
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(userBeingViewed.itemsSaved) { itemSaved in
                                            ZStack {
                                                if let uiImage = UIImage(data: itemSaved.image) {
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .aspectRatio(1, contentMode: .fit)
                                                        .overlay(
                                                            Image(uiImage: uiImage)
                                                                .resizable()
                                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                           )
                                                        .frame(width: 200, height: 200)
                                                }
                                                NavigationLink( destination: SingleProductView(product: itemSaved) ) {
                                                    Text("")
                                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                }
                                            }
                                        }
                                    }
                                    .padding(.all, 5)
                                }
                                .frame(height: 210)
                                .transition(.move(edge: .bottom))
                            }
                            .background(.white)
                            .clipShape( RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)) )
                        }
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .environmentObject(currentUserObject)
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {dismiss()} , 
                       label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.white)
                })
            }
        }
    }
}
