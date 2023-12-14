//
//  ContentView.swift
//  OnSwap
//
//  Created by Quentin Ducker on 12/9/23.
//

import SwiftUI
import SwiftData
import PhotosUI

struct ContentView: View {
    @Environment(\.modelContext) var context
    @Query private var users: [User]
    
    @State var selectedImage : PhotosPickerItem?
    @State var imageData : Data?
    
    @State private var showAddDialog = false
    @State private var username = ""
    @State private var password = ""
    @State private var rating: Rating = Rating.none
    
    var body: some View {
        NavigationStack {
            List {
                ForEach (users) { user in
                    NavigationLink(value: user) {
                        VStack{
                            Text(user.username)
                            Text(user.password)
                                .textScale(.secondary)
                                .foregroundStyle(.secondary)
                            Text(user.rating.stringValue())
                                .textScale(.secondary)
                                .foregroundStyle(.secondary)
                            Text(user.profilePicture != Data() ? "profile pic" : "no profile pic")
                                .textScale(.secondary)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteUser)
            }
            .navigationTitle("Users")
            .navigationDestination(for: User.self) { EditUserView(user: $0) }
            .toolbar {
//                Button("Add user") {
//                    showAddDialog = true
//                }
//                NavigationLink(destination: AllProducts() ) {
//                    Text("Main")
//                }
            }
            .sheet(isPresented: $showAddDialog) {
                NavigationStack {
                    Form {
                        TextField("username", text: $username)
                        TextField("password", text: $password)
                        
                        Section {
                            Picker("rating", selection: $rating) {
                                ForEach(Rating.allCases, id: \.self) { ratingOption in
                                    let ratingText = ratingOption.stringValue()
                                    Text( "\(ratingText)" ).tag(ratingOption)
                                }
                            }
                        }
                        
                        if let imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 50, maxHeight: 50)
                        }
                        
                        PhotosPicker(selection: $selectedImage, matching: .images, photoLibrary: .shared()) {
                            Label("Pick an image for the profile picture", systemImage: "photo")
                        }
                        .navigationTitle("New User")
                        .toolbar {
                            Button ("Dissmiss") {
                                showAddDialog.toggle()
                            }
                            Button("Save") {
                                guard let profilePicture = imageData else { return }
                                let user = User(username: username, password: password, rating: rating, profilePicture: profilePicture)
                                context.insert(user)
                                showAddDialog.toggle()
                            }
                        }
                        
                    }
                    .task(id: selectedImage) {
                        if let data = try? await selectedImage?.loadTransferable(type: Data.self) {
                            imageData = data
                        }
                    }
                }.presentationDetents([.medium])
            }
        }
    }
    
    func deleteUser(indexSet: IndexSet) {
        for index in indexSet {
            let user = users[index]
            context.delete(user)

        }
        
    }
}
