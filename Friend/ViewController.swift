//
//  ViewController.swift
//  Friend
//
//  Created by Henry Calderon on 6/15/20.
//  Copyright © 2020 Henry Calderon. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var people: [NSManagedObject] = []
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        //2
        let fetchRequest =  NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        //3
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    //MARK: Save
    func save(name: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        // 3
        person.setValue(name, forKeyPath: "name")
        // 4
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print(error.userInfo)
        }
        
    }
    
    //MARK: IBAction
    @IBAction func addButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "New Friend", message: "Add the name of your friend", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Add Now", style: .default) { [unowned self] action in
            
            guard let textField = alert.textFields?.first, let nameToSave = textField.text else { return }
            
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)  -> UITableViewCell {
        
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String
        return cell
        
        
    }
    
    
}

