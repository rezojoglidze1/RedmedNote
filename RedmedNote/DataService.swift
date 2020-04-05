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
        let employee0 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName, into: self.managedObjectContext) as! Employee //Cast the reurned NSManagedObject to the correct  NSManagedObject subclass Type
        //set properties
        employee0.firstName = "Rezo"
        employee0.lastName = "Joglidze"
        
        let employee1 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName, into: self.managedObjectContext) as! Employee
        employee1.firstName = "Giorgi"
        employee1.lastName = "Shaimshelashvili"
        
        let employee2 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName, into: self.managedObjectContext) as! Employee
        employee2.firstName = "Ilia"
        employee2.lastName = "Khaburdzania"
        
        let employee3 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName, into: self.managedObjectContext) as! Employee
        employee3.firstName = "Irakli"
        employee3.lastName = "Iobashvili"
        
        let employee4 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName, into: self.managedObjectContext) as! Employee
        employee4.firstName = "Giorgi"
        employee4.lastName = "Japiashvili"
        
        let employee5 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName, into: self.managedObjectContext) as! Employee
        employee5.firstName = "Giorgi"
        employee5.lastName = "Gelisashvili"
        
     
        //USe NSManagedObjectContext's save() method to insert objects into the persistence store. The save() method can throw, so you must wrap the call in a do-catch block.
        do{
            try self.managedObjectContext.save()
            print("save employees")
            
        } catch{
            print("somthing went wrong\(error)")
            self.managedObjectContext.rollback()//managedObjectContext back to its original pre-insert new object state.
        }  
    }
}


