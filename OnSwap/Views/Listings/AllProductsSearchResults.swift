//
//  AllProductsSearchResults.swift
//  OnSwap
//
//  Created by Quentin Ducker on 12/14/23.
//

import SwiftUI
import SwiftData

struct AllProductsSearchResults: View {
    @Query var products : [Product]
    @EnvironmentObject var currentUserObject : CurrentUserObject
    
    init(searchString: String) {
        _products = Query(filter: #Predicate{
            if searchString.isEmpty {
                return true
            } else {
                return $0.title.localizedStandardContains(searchString)
            }
        })
    }

    
    var body: some View {
        List {
            ForEach(products) { product in
                VStack {
                    ZStack {
                        NavigationLink( destination: SingleProductView(product: product) ) {}
                        VStack {
                            Section {
                                if let uiImage = UIImage(data: product.image) {
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .aspectRatio(1, contentMode: .fit)
                                        .overlay(
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        )
                                }
                                HStack {
                                    Text(product.price , format: .currency(code: "USD"))
                                        .bold()
                                    Spacer()
                                    Text(product.title)
                                        .bold()
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                            }
                            .padding(.bottom, 10)
                        }
                        .environmentObject(currentUserObject)
                    }
                }
            }
        }
    }
}
