//
//  ViewController.swift
//  ShoppingList
//
//  Created by Abdulkadir Oruç on 6.07.2023.
//

import UIKit

class ViewController: UITableViewController {
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteObjects))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell",for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
            }
            else if cell.accessoryType == .none{
                cell.accessoryType = .checkmark
            }
            cell.isSelected = false
        }
        
    }
    
    @objc func add(){
        let ac = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default){[weak self, weak ac] action in
            guard let item = ac?.textFields?[0].text else { return }
            self?.shoppingList.append(item)
            let indexPath = IndexPath(row: (self?.shoppingList.count)! - 1, section: 0)
            self?.tableView.insertRows(at: [indexPath] , with: .automatic)
        }
        ac.addAction(submitAction)
        present(ac,animated: true)
    }
    
    @objc func deleteObjects(){
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    

}

