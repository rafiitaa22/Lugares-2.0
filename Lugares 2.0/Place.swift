//
//  Place.swift
//  Lugares 2.0
//
//  Created by Rafael Larrosa Espejo on 11/10/16.
//  Copyright © 2016 Rafael Larrosa Espejo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Place : NSManagedObject{
    @NSManaged var name : String!
    @NSManaged var type : String!
    @NSManaged var location : String!
    @NSManaged var telephone: String?
    @NSManaged var website : String?
    @NSManaged var image : NSData?
    @NSManaged var rating : String?
    
    
    
    
}
