//
//  DataService.swift
//  RedmedNote
//
//  Created by rezo on 4/4/20.
//  Copyright © 2020 Rezo Joglidze. All rights reserved.
//

import Foundation
import CoreData

struct DataService: ManagedObjectContextDependentType {
    var managedObjectContext: NSManagedObjectContext!
    
    func seedEmployees() {
        
        //initialize a new Entity instance with NSEntityDescription.insertNewObject.  Supply the entity name in the form of a string and Supply an instance of NSManagedObjectContext. Returns an NSManagedObject instance and must cast result to NSManagedObject subclass Type.
        let employee1 = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: managedObjectContext) as! Employee //Cast the reurned NSManagedObject to the correct  NSManagedObject subclass Type
        
        //set properties
        employee1.firstName = "Rezo"
        employee1.lastName = "Joglidze"
        
        
        //USe NSManagedObjectContext's save() method to insert objects into the persistence store. The save() method can throw, so you must wrap the call in a do-catch block.
        do{
       try self.managedObjectContext.save()
        } catch{
            print("somthing went wrong\(error)")
            self.managedObjectContext.rollback()//managedObjectContext back to its original pre-insert new object state.
        }
    }
}

