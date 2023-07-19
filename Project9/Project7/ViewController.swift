//
//  ViewController.swift
//  Project7
//
//  Created by Abdulkadir Oruç on 7.07.2023.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        navigationController?.isToolbarHidden = false
        
        // let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        var urlString = ""

        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else if  navigationController?.tabBarItem.tag == 1{
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        else{
            let ac = UIAlertController(title: "Credits", message: "This datas come from: We The People API of the Whitehouse", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self.parse(json: data)
                }
                else{
                    self.showError()
                }
            }
            else{
                self.showError()
            }
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }

    @objc func search(){
        
        let ac = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?[0].placeholder = "Type some text here"
        let action = UIAlertAction(title: "Search", style: .default) { [weak self] action in
            guard var fpetitions = self?.filteredPetitions else { return }
            guard var petitions = self?.petitions else { return }
            
            if let userText = ac.textFields?[0].text{
                for petition in petitions{
                    if petition.body.contains("\(userText)"){
                        fpetitions.append(petition)
                        
                    }
                }
            }
            print(fpetitions.count)
            self?.petitions = fpetitions
            self?.tableView.reloadData()
        }
        ac.addAction(action)
        present(ac, animated: true)
    }

}

