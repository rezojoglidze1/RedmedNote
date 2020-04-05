//
//  CoreDataStack.swift
//  RedmedNote
//
//  Created by rezo on 4/4/20.
//  Copyright © 2020 Rezo Joglidze. All rights reserved.
//

/*AppDelegate-shi unda gaushva es
    "//how to context can be created
    let mainContext = createMainContext()" */
    


import Foundation
import CoreData

//!!!!!!!!!!!!!CoreDataStack !!!!!!!!!!!!



//this function is responsiple to create NSManagerObjectContext for the rest of my app.
func createMainContext() -> NSManagedObjectContext {

    //initialize NSManagerObjectModel

    //Note.xcdatamodeld complilaciis shemded mici rezoulicia icvleba Note.momd.  Note.momd inaxeba application Bundle fileshi. to work with the application bundle there is a special class name bundle with an API that let  get accses main Application bundle and do like obtain URLs for resources found within it.   // A bundle is a directory in the file system that groups executable code and related resources such as images and sounds together in one place.
    let modelURL = Bundle.main.url(forResource: "Note", withExtension: "momd")//now i can supply that url to the NSManagedObjectModel initializer.
    //bundle.main.url return the optional url but the initializer need URL, not an optional URL. amis gamo unda gavaketot unwrap. tanac (contentsOf: URL) es optional abrunebs da safeunwrap gvinda radgan es gashvebamde daiqrasheboda.
    guard let model = NSManagedObjectModel(contentsOf: modelURL!) else { fatalError("Model not found") }


    //configure NSPersistentStoreCoordinator with an NSPersistentStore
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)

    /*NSPersistentSrore configurate. there's method romlis instance aris NSPersistentStoreCoordinator-is da shen daamateb persistent store particular tipebisstvis.
     at: <#T##URL?#>,- nishnavs rom sad unda moxdes shenaxva, amistvis unda vicodet shemdegi rameebi
     1. fileManager class lets us to developer interact  with the file system on the user deveice.
     2. it's standart pratice to want a URL to a file  located in the user's document directory... es imito rom roca device sheicvlis sync dros icloud-is meshveobit agdges data.
     3. if file doesnot exist(არსებობს) , the file manager should create it.
     */

    // rom mivigot ful file URL, gamoviyenebt appendingPathComponent-s.
    let storeURL = URL.documentsURL.appendingPathComponent("Note.sqlite")//I get URL from persistens store


    //TODO: Use migrations!  migracias vaketeb imitom rom, raimes roca davamateb Note-s mashin gamoidzaxeba es, radgan erti versiidan meoreze gadavdivart. tundac roca carili gaq mashinac gamoidzaxebs, radgan carieli aris mara misi object sheqmnilia mexsierebashi da am dzveli versiidan axal versaize gadasasvlelad migraciis gaketeba unda.
    try! FileManager.default.removeItem(at: storeURL)


    try!  persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)

    //create and return NSManagedObjectContext
    let context = NSManagedObjectContext (concurrencyType: .mainQueueConcurrencyType) // so i have instance NSManagedObjectContext
    context.persistentStoreCoordinator = persistentStoreCoordinator

    return context


}
extension URL {
    static var documentsURL: URL{
        return try! FileManager
         .default
         .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
}

protocol ManagedObjectContextDependentType {
    var managedObjectContext: NSManagedObjectContext! { get set}
}






//
//
