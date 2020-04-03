//
//  ViewController.swift
//  RedmedNote
//
//  Created by rezo on 4/4/20.
//  Copyright © 2020 Rezo Joglidze. All rights reserved.
//

import UIKit
import CoreData

class NoteDraftViewController: UIViewController, ManagedObjectContextDependentType {

    @IBOutlet weak var noteTableView: UITableView!
    var managedObjectContext: NSManagedObjectContext!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTableView.dataSource = self
        noteTableView.delegate = self

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

