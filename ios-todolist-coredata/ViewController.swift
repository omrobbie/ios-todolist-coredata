//
//  ViewController.swift
//  ios-todolist-coredata
//
//  Created by omrobbie on 29/06/20.
//  Copyright © 2020 omrobbie. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get data folder
        print(NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).last! as String)

        setupList()
        loadData()
    }

    private func setupList() {
        title = "Todo List"
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func saveData() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
            return
        }
    }

    private func loadData() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()

        do {
            items = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
            return
        }
    }

    @IBAction func btnAddTapped(_ sender: Any) {
        var textField = UITextField()

        let alertVC = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        let actionAdd = UIAlertAction(title: "Add", style: .default) { (_) in
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.status = false

            self.items.append(newItem)
            self.tableView.reloadData()
            self.saveData()
        }

        alertVC.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item..."
            textField = alertTextField
        }

        alertVC.addAction(actionCancel)
        alertVC.addAction(actionAdd)

        present(alertVC, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.status ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].status = !items[indexPath.row].status
        tableView.reloadData()
        saveData()
    }
}
