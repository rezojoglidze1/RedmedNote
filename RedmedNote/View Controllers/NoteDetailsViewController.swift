//
//  NoteDetailsViewController.swift
//  RedmedNote
//
//  Created by rezo on 4/4/20.
//  Copyright © 2020 Rezo Joglidze. All rights reserved.
//

import UIKit
import CoreData

class NoteDetailsViewController: UIViewController, ManagedObjectContextDependentType {
    
    var note: Note?
    var managedObjectContext: NSManagedObjectContext!
 
    @IBOutlet weak var noteCategoryLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
                
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextDidSave,
                                               object: nil,
                                               queue: nil,
                                               using: {//ამ ბლოკში არ შემოდის საერთოდ
                                                (notification: Notification) in
                                                //The userInfo  dictionary contains the following keys: NSInsertedObjectsKey, NSUpdatedObjectsKey, and NSDeletedObjectsKey.
                                                if  let updatedNotes = notification.userInfo?[NSUpdatedObjectsKey] as? Set<Note> {
                                                    self.note = updatedNotes.first
                                                    self.setUIValues()
                                                }
        })
        
        setUIValues()
    }
        
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    func setUIValues() {
        self.noteCategoryLabel.text = self.note?.noteCategory //
        self.messageTextView.text = self.note?.message
        self.fromLabel.text = self.note?.from
    }



    @IBAction func deleteButtonTapped(_ sender: Any) {

        let alertController = UIAlertController(title: "Delete Note",
                                                message: "Are you sure you want to delete this Note?",
                                                preferredStyle: .actionSheet)

            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
                (_) -> Void in

                self.managedObjectContext.delete(self.note!)

                do {
                    try self.managedObjectContext?.save()
                } catch {
                    self.managedObjectContext?.rollback()
                    print("Something went wrong: \(error)")
                }

                let _ = self.navigationController?.popViewController(animated: true)
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)

            self.present(alertController, animated: true, completion: nil)
        }



       // MARK: - Navigation
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           let navigationController = segue.destination as! UINavigationController
           let destinationVC = navigationController.viewControllers[0] as! EditNoteViewController
           destinationVC.managedObjectContext = self.managedObjectContext
       }

}
