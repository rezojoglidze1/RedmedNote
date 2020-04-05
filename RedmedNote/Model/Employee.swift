//
//  Employee.swift
//  RedmedNote
//
//  Created by rezo on 4/4/20.
//  Copyright © 2020 Rezo Joglidze. All rights reserved.
//

import Foundation
import CoreData

class Employee: NSManagedObject {
    @NSManaged var firstName: String
    @NSManaged var lastName: String

    
    @NSManaged var notes: NSSet?
    
    static var entityName: String {
           return "Employee"
       }
}

