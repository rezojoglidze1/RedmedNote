//
//  SaveAccessDelete.swift
//  RedmedNoteTests
//
//  Created by rezo on 4/4/20.
//  Copyright © 2020 Rezo Joglidze. All rights reserved.
//

import XCTest
import CoreData

@testable import RedmedNote

class SaveAccessDelete: XCTestCase {
    
    var managedObjectContext: NSManagedObjectContext!
    var dataService: DataService!
      override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.managedObjectContext = createMainContextInMemory()
        self.dataService = DataService(managedObjectContext: managedObjectContext)
        self.dataService.seedEmployees()
        
            // In UI tests it is usually best to stop immediately when a failure occurs.
          //  continueAfterFailure = false
    
            // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
           // XCUIApplication().launch()
    
            // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        }
    
    //    override func tearDown() {
    //        // Put teardown code here. This method is called after the invocation of each test method in the class.
    //    }
    //
    //    func testExample() {
    //        // Use recording to get started writing UI tests.
    //        // Use XCTAssert and related functions to verify your tests produce the correct results.
    //    }

    
    
    func testFetchAllEmployees() {
        //        let managedObjectContext = createMainContextInMemory() // NSManagedObjectContext instance
        //        let dataService =  DataService(managedObjectContext: managedObjectContext) //DataService instance
        //        dataService.seedEmployees() // to get all employees which we have in persistent store
        //
        //        //initialize NSFetchRequest
        //        let employeeFetchRequest = NSFetchRequest<Employee>(entityName: Employee.entityName)
        //
        //        do{
        //        //execute with NSManagedObjectContext
        //            let employees = try managedObjectContext.fetch(employeeFetchRequest)
        //        //work with the result
        //            print(employees)
        //        } catch {
        //            print("there is a problem fech employees: \(error)")
        //        }
        //
        
        let employeeFetchRequest = NSFetchRequest<Employee>(entityName: Employee.entityName)
        
        do {
            let employees = try managedObjectContext.fetch(employeeFetchRequest)
            print(employees)
        } catch {
            print("Something went wrong fetching employees: \(error)")
        }
    }
    
    
    //NSPredicate filtering data with NSPredicate. dasortilis dabruneba tu gvinda mashin unda gamoviyenot NSSortDescriptor.
    func testFilterNotes() {
        seedNoteForTesting(managedObjectContext: managedObjectContext)
        
        //initialize NSFetchRequest
        let NoteFetchRequest = NSFetchRequest<Note>(entityName: Note.entityName)
        
        /*initialize NSFetchRequest... %K is a placeholder for the key(Attribute) containing values for comparison.        == is a Comparison operator.   %@is an object placeholder that values in the key(%K) placeholder will be compared to

        "%K --> #keyPath(Note.noteCategory)   %@ --> "Great Job!" */
        let noteCategoryEqualityPredicate = NSPredicate(format: "%K == %@", #keyPath(Note.noteCategory), "Great Job!")
        //Assign predicate to NSFetchReques instance
        NoteFetchRequest.predicate = noteCategoryEqualityPredicate
        
        do {
            let filteredNotes = try managedObjectContext.fetch(NoteFetchRequest)
            print("----------First Result Set----------")
            printNotes(notes: filteredNotes)
        } catch {
            print("Something went wrong fetching ShoutOuts: \(error)")
        }
        
        let noteCategoryINPredicate = NSPredicate(format: "%K IN %@", #keyPath(Note.noteCategory), "Great Job!, Well Done!")
        NoteFetchRequest.predicate = noteCategoryINPredicate
        
        do {
            let filteredNotes = try managedObjectContext.fetch(NoteFetchRequest)
            print("----------Second Result Set----------")
            printNotes(notes: filteredNotes)
        } catch {
            print("Something went wrong fetching ShoutOuts: \(error)")
        }
        
        let beginsWithPredicate = NSPredicate(format: "%K BEGINSWITH %@", #keyPath(Note.toEmployee.lastName), "Joglidze")
        NoteFetchRequest.predicate = beginsWithPredicate
        
        do {
            let filteredNotes = try managedObjectContext.fetch(NoteFetchRequest)
            print("----------Third Result Set----------")
            printNotes(notes: filteredNotes)
        } catch {
            print("Something went wrong fetching ShoutOuts: \(error)")
        }
    }
    
    
    
    func seedNoteForTesting(managedObjectContext: NSManagedObjectContext) {
        let employeeFetchRequest = NSFetchRequest<Employee>(entityName: Employee.entityName)
        
        do {
            let employees = try managedObjectContext.fetch(employeeFetchRequest)
            
            let note1 = NSEntityDescription.insertNewObject(forEntityName: Note.entityName,
                                                                into: managedObjectContext) as! Note
            note1.noteCategory = "Great Job!"
            note1.message = "Hey, great job on that project!"
            note1.toEmployee = employees[0]
            
            let note2 = NSEntityDescription.insertNewObject(forEntityName: Note.entityName,
                                                                into: managedObjectContext) as! Note
            note2.noteCategory = "Great Job!"
            note2.message = "Couldn't have presented better at the conference last week!"
            note2.toEmployee = employees[1]
            
            let note3 = NSEntityDescription.insertNewObject(forEntityName: Note.entityName,
                                                                into: managedObjectContext) as! Note
            note3.noteCategory = "Awesome Work!"
            note3.message = "You always do awesome work!"
            note3.toEmployee = employees[2]
            
            let note4 = NSEntityDescription.insertNewObject(forEntityName: Note.entityName,
                                                                into: managedObjectContext) as! Note
            note4.noteCategory = "Awesome Work!"
            note4.message = "You've done an amazing job this year!"
            note4.toEmployee = employees[3]
            
            let note5 = NSEntityDescription.insertNewObject(forEntityName: Note.entityName,
                                                                into: managedObjectContext) as! Note
            note5.noteCategory = "Well Done!"
            note5.message = "I'm impressed with the results of your prototoype!"
            note5.toEmployee = employees[4]
            
            let note6 = NSEntityDescription.insertNewObject(forEntityName: Note.entityName,
                                                                into: managedObjectContext) as! Note
            note6.noteCategory = "Well Done!"
            note6.message = "Keep up the good work!"
            note6.toEmployee = employees[5]

            do {
                try managedObjectContext.save()
            } catch {
                print("Something went wrong with saving Notes: \(error)")
                managedObjectContext.rollback()
            }
        } catch {
            print("Something went wrong fetching employees: \(error)")
        }
    }
    
    
    
    func testSortShoutOuts() {
        seedNoteForTesting(managedObjectContext: managedObjectContext)
        
        let notesFetchRequest = NSFetchRequest<Note>(entityName: Note.entityName)
        
        do {
            let notes = try managedObjectContext.fetch(notesFetchRequest)
            print("----------Unsorted Notes----------")
            printNotes(notes: notes)
        } catch _ {}
        
        let noteCategorySortDescriptor = NSSortDescriptor(key: #keyPath(Note.noteCategory), ascending: true)
        let lastNameSortDescriptor = NSSortDescriptor(key: #keyPath(Note.toEmployee.lastName), ascending: true)
        let firstNameSortDescriptor = NSSortDescriptor(key: #keyPath(Note.toEmployee.firstName), ascending: true)
        
        //assign array of NSSortDescriptor instance of NSFetchRequest instance
        notesFetchRequest.sortDescriptors = [noteCategorySortDescriptor, lastNameSortDescriptor, firstNameSortDescriptor]
        
        do {
            let notes = try managedObjectContext.fetch(notesFetchRequest)
            print("----------Sorted Notes----------")
            printNotes(notes: notes)
        } catch _ {}
    }
    
    
    
    func printNotes(notes: [Note]) {
        for note in notes {
            print("\n----------Notes----------")
            print("Note Category: \(note.noteCategory)")
            print("Message: \(note.message)")
            print("To: \(note.toEmployee.firstName) \(note.toEmployee.lastName)")
        }
    }
}
