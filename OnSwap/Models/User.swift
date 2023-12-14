//
//  User.swift
//  OnSwap
//
//  Created by Quentin Ducker on 12/9/23.
//

import Foundation
import SwiftData

@Model
class User : ObservableObject {
    @Attribute(.unique) var username : String
    var password : String
    var rating : Rating
    var profilePicture : Data
    
    
    
    init( username: String = "", password: String = "", rating: Rating = Rating.none, profilePicture: Data = Data() ) {
        self.username = username
        self.password = password
        self.rating = rating
        self.profilePicture = profilePicture
        self.itemsSelling = []
        self.itemsSaved = []
    }
    
    @Relationship(deleteRule: .cascade, inverse: \Product.soldBy)
    var itemsSelling : [Product]
    var itemsSaved : [Product]
}

enum Rating : Int, CaseIterable, Codable {
    case none = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    
    func stringValue() -> String {
        switch(self) {
        case .none:
            return "none"
        case .one:
            return "1"
        case .two:
            return "2"
        case .three:
            return "3"
        case .four:
            return "4"
        case .five:
            return "5"
        }
    }
}
