//
//  Product.swift
//  OnSwap
//
//  Created by Quentin Ducker on 12/9/23.
//

import Foundation
import SwiftData
import PhotosUI

@Model
class Product : ObservableObject {
    var title : String
    var descriptionText : String
    var price : Double
    var location : String
    var image : Data
        
    init(title: String = "", descriptionText: String = "", price: Double = 0.00, location: String = "", image: Data = Data(), soldBy: User? ) {
        self.title = title
        self.descriptionText = descriptionText
        self.price = price
        self.location = location
        self.image = image
        self.soldBy = soldBy
    }
    
    @Relationship(deleteRule: .nullify)
    var soldBy : User?
}
