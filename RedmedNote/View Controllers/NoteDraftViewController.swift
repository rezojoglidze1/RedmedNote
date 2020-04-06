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
            try self.fetchedResultsController?.performFetch()
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
        let noteFetchRequest = NSFetchRequest<Note>(entityName: Note.entityName)
        //   let departmentSortDescriptor = NSSortDescriptor(key: #keyPath(ShoutOut.toEmployee.department), ascending: true)
        let lastNameSortDescriptor = NSSortDescriptor(key: #keyPath(Note.toEmployee.lastName), ascending: true)
        let firstNameSortDescriptor = NSSortDescriptor(key: #keyPath(Note.toEmployee.firstName), ascending: true)
        noteFetchRequest.sortDescriptors = [lastNameSortDescriptor, firstNameSortDescriptor]
        
        self.fetchedResultsController = NSFetchedResultsController<Note>(fetchRequest: noteFetchRequest,
                                                                         managedObjectContext: self.managedObjectContext,
                                                                         sectionNameKeyPath: #keyPath(Note.toEmployee.lastName),
                                                                         cacheName: nil)
        
        self.fetchedResultsController?.delegate = self
    }
    
    
    
    
    // MARK: NSFetchedResultsController Delegate methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.noteTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.noteTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let insertIndexPath = newIndexPath {
                self.noteTableView.insertRows(at: [insertIndexPath], with: .fade)
            }
        case .delete:
            if let deleteIndexPath = indexPath {
                self.noteTableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }
        case .update:
            if let updateIndexPath = indexPath {
                let cell = self.noteTableView.cellForRow(at: updateIndexPath) as! NoteTableViewCell
                let updatedShoutOut = self.fetchedResultsController.object(at: updateIndexPath)
                
                cell.titleLabelCell.text = "\(updatedShoutOut.toEmployee.firstName) \(updatedShoutOut.toEmployee.lastName)"
                cell.subTitleLabelCell.text = updatedShoutOut.noteCategory //message
            }
        case .move:
            if let deleteIndexPath = indexPath {
                self.noteTableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }
            
            if let insertIndexPath = newIndexPath {
                self.noteTableView.insertRows(at: [insertIndexPath], with: .fade)
            }
        default:
            print("something happen")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        let sectionIndexSet = NSIndexSet(index: sectionIndex) as IndexSet
        
        switch type {
        case .insert:
            self.noteTableView.insertSections(sectionIndexSet, with: .fade)
        case .delete:
            self.noteTableView.deleteSections(sectionIndexSet, with: .fade)
        default:
            break
        }
    }
}






extension NoteDraftViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: TableView Data Source methods
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = self.fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = self.fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.name
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultsController.sections {
            return sections[section].numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //    let cell = tableView.dequeueReusableCell(withIdentifier: "noteTableViewCell", for: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteTableViewCell", for: indexPath) as! NoteTableViewCell
        
        let note = self.fetchedResultsController?.object(at: indexPath)
        
        cell.titleLabelCell.text = "\(note?.toEmployee.firstName ?? "") \(note?.toEmployee.lastName ?? "")"
        cell.subTitleLabelCell.text = note?.noteCategory
        //  print(shoutOut.toEmployee.department)
        return cell
    }
    
    // MARK: TableView Delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "noteDetails":
            let destinationVC = segue.destination as! NoteDetailsViewController
            destinationVC.managedObjectContext = self.managedObjectContext
            
            
            let selectedIndexPath = self.noteTableView.indexPathForSelectedRow!
            let selectedNote = self.fetchedResultsController.object(at: selectedIndexPath)
            
            destinationVC.note = selectedNote
            
        case "addNote":
            let navigationController = segue.destination as! UINavigationController
            let destinationVC = navigationController.viewControllers[0] as! EditNoteViewController
            destinationVC.managedObjectContext = self.managedObjectContext
        default:
            break
        }
    }
    
}

