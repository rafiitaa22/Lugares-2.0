//
//  Place.swift
//  Lugares 2.0
//
//  Created by Rafael Larrosa Espejo on 11/10/16.
//  Copyright © 2016 Rafael Larrosa Espejo. All rights reserved.
//

import Foundation
import UIKit

class Place {
    var name = ""
    var type = ""
    var location = ""
    var telephone = ""
    var website = ""
    var image : UIImage!
    var rating = "rating"

    init(name: String, type: String, location: String, image: UIImage, telephone: String, website: String) {
        self.name = name
        self.type = type
        self.location = location
        self.image = image
        self.telephone = telephone
        self.website = website
    }
    
    
}
