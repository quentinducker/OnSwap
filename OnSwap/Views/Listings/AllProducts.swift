//
//  AllProducts.swift
//  OnSwap
//
//  Created by Quentin Ducker on 12/12/23.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AllProducts: View {
    @State private var searchText = ""
    @EnvironmentObject var currentUserObject : CurrentUserObject
    
    var body: some View {
        AllProductsSearchResults(searchString: searchText)
            .navigationBarBackButtonHidden()
            .navigationTitle(Text("MarketPlace"))
            .foregroundStyle(LinearGradient(colors: [.indigo, .blue], startPoint: .leading, endPoint: .trailing))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink( destination: AddListingView( ) ) {
                        Image(systemName: "plus")
                            .padding(.all, 2)
                            .foregroundStyle(.white)
                            .background(LinearGradient(colors: [.indigo, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .clipShape(.circle)
                    }
                }
            
            ToolbarItem(placement: .bottomBar) {
                HStack{
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.white)
                    
                    TextField("Search", text: $searchText, prompt: Text("Search").foregroundStyle(.white))
                        .foregroundStyle(.white)
                    ZStack {
                        Image(systemName: "person")
                            .padding(.all, 5)
                            .background(.white)
                            .foregroundStyle(.blue)
                            .clipShape(.capsule)

                        NavigationLink(destination: ProfileView(userBeingViewed: currentUserObject.currentUser!)){}
                    }
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 3)
                .background( LinearGradient(colors: [.indigo, .blue], startPoint: .leading, endPoint: .center) )
                .clipShape(.capsule)
            }
            
            ToolbarItemGroup(placement: .keyboard) {
                Text(searchText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
        }
            .environmentObject(currentUserObject)
    }
}
