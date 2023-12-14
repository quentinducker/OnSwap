//
//  LoginView.swift
//  OnSwap
//
//  Created by Quentin Ducker on 12/13/23.
//

import SwiftUI
import SwiftData

class CurrentUserObject: ObservableObject {
    @Published var currentUser : User? = nil
}

struct LoginView: View {
    @Environment (\.modelContext) var context
    @Query private var users : [User]
    
    @StateObject var currentUserObject = CurrentUserObject()

    @State private var path = NavigationPath()
    
    @State private var username : String = "Quentin_ducker"
    @State private var password : String = "Password"
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                LinearGradient(colors: [.indigo, .blue], startPoint: .center, endPoint: .bottomLeading)
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 15){
                    HStack{
                        Spacer()
                        Text("MarketPlace")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    Spacer()
                    TextField("username", text: $username, prompt: Text("username").foregroundStyle(.white))
                        .foregroundStyle(.white)
                        .padding(10)
                        .overlay{
                            RoundedRectangle(cornerRadius: 10)
                                .stroke( LinearGradient(colors: [.white, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                        }
                        .padding(.horizontal)
                    
                    TextField("password", text: $password, prompt: Text("password").foregroundStyle(.white))
                        .foregroundStyle(.gray)
                        .padding(10)
                        .overlay{
                            RoundedRectangle(cornerRadius: 10)
                                .stroke( LinearGradient(colors: [.indigo, .white], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                        }
                        .padding(.horizontal)
                    Spacer()
                    HStack{
                        Spacer()
                        
                        Button( action: loginUser ){
                            Text("Sign In")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(LinearGradient(colors: [.indigo, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                        }
                        .padding(.all, 10)
                        .background( .white)
                        .clipShape(.capsule)
                        
                        Spacer()
                    }
                }
                
            }
            .navigationTitle("MarketPlace")
            .navigationBarHidden(true)
            .navigationDestination(for: String.self) { view in
                if view == "AllProducts" {
                    AllProducts()
                }
            }
        }
        .environmentObject(currentUserObject)
    }
    
    func loginUser(){
        for user in users{
            if username == user.username && password == user.password {
                currentUserObject.currentUser = user
                path.append("AllProducts")
                return
            }
        }
    }
}

#Preview {
    LoginView()
}
