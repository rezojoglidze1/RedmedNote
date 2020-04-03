//
//  Note.swift
//  RedmedNote
//
//  Created by rezo on 4/4/20.
//  Copyright © 2020 Rezo Joglidze. All rights reserved.
//

import Foundation
import CoreData


//cheulebrivi swift file shevqmeni. editor>>create NSManagedObject subclass-dan sheqmnis dros iqmneba ori dublirebuli file da kompilaciis dros errors urtyams.
class Note: NSManagedObject {
    //implement four properties witch we have in note model.
    @NSManaged var from: String?
    @NSManaged var message: String?
    @NSManaged var sentDate: String?
    @NSManaged var noteCategory: String
    
    @NSManaged var toEmployee: Employee
}

