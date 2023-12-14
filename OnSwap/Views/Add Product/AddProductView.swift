//
//  AddProductView.swift
//  OnSwap
//
//  Created by Quentin Ducker on 12/10/23.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddProductView: View {
    
    @Bindable var user: User
    
    @State private var productImage: PhotosPickerItem?
    @State private var productImageData: Data?
    //@State private var product = Product()
    
    var body: some View {
            EmptyView()
    }
}
