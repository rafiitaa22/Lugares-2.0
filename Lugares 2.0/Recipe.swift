//
//  Recipt.swift
//  MisRecetas
//
//  Created by Rafael Larrosa Espejo on 13/9/16.
//  Copyright © 2016 es.elviejoroblesabadell.xCode. All rights reserved.
//

import Foundation
import UIKit
class Recipe: NSObject {
    
    var name: String!
    var image: UIImage!
    var time: Int!
    var ingredients: [String]!
    var steps: [String]!
    // var isFavorite: Bool = false
    var rating : String = "rating"
    
    init(name: String, image: UIImage, time: Int, ingredients: [String], steps: [String]) {
        self.name = name
        self.image = image
        self.time = time
        self.ingredients = ingredients
        self.steps = steps
        
    }
    
}
