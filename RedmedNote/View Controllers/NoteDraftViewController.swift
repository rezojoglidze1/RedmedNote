//
//  ViewController.swift
//  RedmedNote
//
//  Created by rezo on 4/4/20.
//  Copyright © 2020 Rezo Joglidze. All rights reserved.
//

import UIKit
import CoreData

class NoteDraftViewController: UIViewController, ManagedObjectContextDependentType, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var noteTableView: UITableView!
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<Note>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureFetchedResultsController()
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let alertController = UIAlertController(title: "Loading ShoutOuts Failed",
                                                    message: "There was a problem loading the list of ShoutOut drafts. Please try again.",
                                                    preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        noteTableView.dataSource = self
        noteTableView.delegate = self

    }
    
    func configureFetchedResultsController() {
        let shoutOutFetchRequest = NSFetchRequest<Note>(entityName: Note.entityName)
     //   let departmentSortDescriptor = NSSortDescriptor(key: #keyPath(ShoutOut.toEmployee.department), ascending: true)
        let lastNameSortDescriptor = NSSortDescriptor(key: #keyPath(Note.toEmployee.lastName), ascending: true)
        let firstNameSortDescriptor = NSSortDescriptor(key: #keyPath(Note.toEmployee.firstName), ascending: true)
        shoutOutFetchRequest.sortDescriptors = [lastNameSortDescriptor, firstNameSortDescriptor]
        
//        self.fetchedResultsController = NSFetchedResultsController<Note>(fetchRequest: shoutOutFetchRequest,
//                                                                         managedObjectContext: self.managedObjectContext,
//                                                                         sectionNameKeyPath: #keyPath(Note.toEmployee.lastName),
//                                                                         cacheName: nil)
        
        self.fetchedResultsController.delegate = self
    }
}










extension NoteDraftViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteTableViewCell", for: indexPath) as! NoteTableViewCell
        
        cell.titleLabelCell.text = "title label me"
        cell.subTitleLabelCell.text = "sub var me"
        
        return cell
    }
    
    
    //tableView delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
       
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           switch segue.identifier! {
           case "noteDetails":
               let destinationVC = segue.destination as! NoteDetailsViewController
               destinationVC.managedObjectContext = self.managedObjectContext
               
           case "addNote":
               let navigationController = segue.destination as! UINavigationController
               let destinationVC = navigationController.viewControllers[0] as! EditNoteViewController
               destinationVC.managedObjectContext = self.managedObjectContext
           default:
               break
           }
       }
    
}

