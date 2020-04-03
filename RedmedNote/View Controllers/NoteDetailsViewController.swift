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
    
    var managedObjectContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
       // MARK: - Navigation
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           let navigationController = segue.destination as! UINavigationController
           let destinationVC = navigationController.viewControllers[0] as! EditNoteViewController
           destinationVC.managedObjectContext = self.managedObjectContext
       }
}
