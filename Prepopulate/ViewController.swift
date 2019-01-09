//
//  ViewController.swift
//  Prepopulate
//
//  Created by Soulchild on 09/01/2019.
//  Copyright © 2019 fluffy. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var peopleTableView: UITableView!
    var people: [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // This will print out the application support folder path for this app
         print(NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).last!);
        
        self.peopleTableView.register(UINib(nibName: String(describing: PersonTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: PersonTableViewCell.self))
        self.peopleTableView.rowHeight = UITableView.automaticDimension
        self.peopleTableView.estimatedRowHeight = 94.0
        
        self.peopleTableView.dataSource = self
        self.peopleTableView.delegate = self
        
        /*
         calling fetchAllRecords before copying seed data will
         create an empty sqlite database in
         /Library/Application Support/<Your app name>.sqlite
        */
        fetchAllRecords()
        peopleTableView.reloadData()
    }
    
    // MARK: IBAction
    
    @IBAction func prepopulateTapped(_ sender: UIButton) {
        sender.isEnabled = false
        
        Person.prepopulateUsingSeed()

        sender.isEnabled = true
        
        fetchAllRecords()
        peopleTableView.reloadData()
    }
    
    private func fetchAllRecords() {
        print("fetching all records")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PersonTableViewCell.self), for: indexPath) as! PersonTableViewCell
            let person = people[indexPath.row]
            cell.configureWith(person: person)
            return cell
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
