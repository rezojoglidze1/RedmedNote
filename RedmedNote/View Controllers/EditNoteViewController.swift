//
//  EditNoteViewController.swift
//  RedmedNote
//
//  Created by rezo on 4/4/20.
//  Copyright © 2020 Rezo Joglidze. All rights reserved.
//


import UIKit
import CoreData

class EditNoteViewController: UIViewController, ManagedObjectContextDependentType {
    

    var managedObjectContext: NSManagedObjectContext!

    var note: Note!

    @IBOutlet weak var toEmployeePicker: UIPickerView!
    @IBOutlet weak var noteCategoryPicker: UIPickerView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var fromTextField: UITextField!

    let noteCategories = [
        "სამუშაო დროის შესახებ",
        "ხელფასის შესახებ",
        "ხვალინდელი გეგმა",
        "მითინგის შესახებ",
        "სპრინტის ამოცანები",
        "აუცილებელი შეტყობინება!"
    ]


   // toEmployeePicker-s monacemebs wamovigeb persistentStore-dan.
    var employees: [Employee]!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEmployees()

        toEmployeePicker.delegate = self
        toEmployeePicker.dataSource = self
        toEmployeePicker.tag = 0

        noteCategoryPicker.delegate = self
        noteCategoryPicker.dataSource = self
        noteCategoryPicker.tag = 1

        
        self.note = self.note ?? NSEntityDescription.insertNewObject(forEntityName: Note.entityName, into: self.managedObjectContext) as! Note  /////////

        setUIValues()

        messageTextView.layer.borderWidth = CGFloat(0.5)
        messageTextView.layer.cornerRadius = 5
        messageTextView.clipsToBounds = true
    }

    
       func setUIValues() {
           let selectedEmployeeRow = self.employees.firstIndex(of: self.note.toEmployee) ?? 0
           self.toEmployeePicker.selectRow(selectedEmployeeRow, inComponent: 0, animated: false)
           
           let selectedShoutCategoryRow = self.noteCategories.firstIndex(of: self.note.noteCategory) ?? 0
           self.noteCategoryPicker.selectRow(selectedShoutCategoryRow, inComponent: 0, animated: false)
           
           self.messageTextView.text = self.note.message
           self.fromTextField.text = self.note.from
       }
    
    
    //get employees from managedObjectContex.fetch
    func fetchEmployees() {

        let employeeFetchRequest = NSFetchRequest<Employee>(entityName: Employee.entityName)

        let primarySortDescription = NSSortDescriptor(key: #keyPath(Employee.lastName), ascending: true)
        let secondarySortDescription = NSSortDescriptor(key: #keyPath(Employee.firstName), ascending: true)

        employeeFetchRequest.sortDescriptors = [primarySortDescription, secondarySortDescription]
//self.managedObjectContext is nil, make sure you assign it and change the declaration to var managedObjectContext: NSManagedObjectContext?
        do {
            self.employees = try self.managedObjectContext.fetch(employeeFetchRequest)
        } catch {
            self.employees = []
            print("Something went wrong: \(error)")
        }
    }
    
   
    



    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.managedObjectContext.rollback()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
     let selectedEmployeeIndex = self.toEmployeePicker.selectedRow(inComponent: 0)
     let selectedEmployee = self.employees[selectedEmployeeIndex]
     self.note.toEmployee = selectedEmployee

     let selectedNoteCategoryIndex = self.noteCategoryPicker.selectedRow(inComponent: 0)
     let selectedNoteCategory = self.noteCategories[selectedNoteCategoryIndex]
     self.note.noteCategory = selectedNoteCategory

     self.note.message = self.messageTextView.text
     self.note.from = self.fromTextField.text ?? "Anonymous"

     do {
         try self.managedObjectContext.save() // save() Attempts to commit unsaved changes to registered objects to the context’s parent store.

         self.dismiss(animated: true, completion: nil)
     } catch {
         let alert = UIAlertController(title: "Trouble Saving",
                                       message: "Something went wrong when trying to save the ShoutOut.  Please try again...",
                                       preferredStyle: .alert)
         let okAction = UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: {(action: UIAlertAction) -> Void in
                                         self.managedObjectContext.rollback()
                                        self.note = NSEntityDescription.insertNewObject(forEntityName: Note.entityName, into: self.managedObjectContext) as? Note
         })
         alert.addAction(okAction)
         self.present(alert, animated: true, completion: nil)
     }

    }
}


extension EditNoteViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == 0 ? self.employees.count : self.noteCategories.count /////////
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 0 {
            let employee = self.employees[row]
            
            return "\(employee.firstName) \(employee.lastName)"
        } else {
            return noteCategories[row]
        }
    }
}
