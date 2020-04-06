//
//  RedmedNoteTests.swift
//  RedmedNoteTests
//
//  Created by rezo on 4/4/20.
//  Copyright © 2020 Rezo Joglidze. All rights reserved.
//

import XCTest
import UIKit
import CoreData

@testable import RedmedNote

class RedmedNoteTests: XCTestCase {
    
    var systemUnderTest: NoteDraftViewController!

    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: Bundle.main)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        systemUnderTest = navigationController.viewControllers[0] as? NoteDraftViewController

        UIApplication.shared.keyWindow!.rootViewController = systemUnderTest
        
        
        // Using the preloadView() extension method
        navigationController.preloadView()
        systemUnderTest.preloadView()
    }

    
    func testManagedObjectContext() {
        let managedObjectContext = createMainContextInMemory()
        self.systemUnderTest.managedObjectContext = managedObjectContext
        
        XCTAssertNotNil(self.systemUnderTest.managedObjectContext)
    }
    

    
    
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {

        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}




func createMainContextInMemory() -> NSManagedObjectContext {
    
    // Initialize NSManagedObjectModel
    let modelURL = Bundle.main.url(forResource: "Note", withExtension: "momd")
    guard let model = NSManagedObjectModel(contentsOf: modelURL!) else { fatalError("model not found") }
    
    // Configure NSPersistentStoreCoordinator with an NSPersistentStore
    let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    try! psc.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
    
    // Create and return NSManagedObjectContext
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    context.persistentStoreCoordinator = psc
    
    return context
}






//damatebulia ekutvnis chem damatebuls
extension UIViewController {
    func preloadView() {
        _ = view
    }
}
