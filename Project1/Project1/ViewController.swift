//
//  ViewController.swift
//  Project1
//
//  Created by Abdulkadir Oruç on 15.06.2023.
//

import UIKit

class ViewController: UITableViewController {
    var items = [String]()
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Storm Viewer"
        //activate large title feature
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //Accessing to folders of our app
        //shared object of FileManager
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        //set to the contents of the directory at a path
        do{
            items = try fm.contentsOfDirectory(atPath: path)
        }catch{
            print(error)
        }
        
        for item in items{
            if item.hasPrefix("nssl"){
                pictures.append(item)
            }
        }
        pictures.sort()
    }
    
    //showing our pictures in basic type cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //a reference to DetailsViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Details") as? DetailsViewController{
            vc.selectedImage = pictures[indexPath.row]
            vc.imageNumber = indexPath.row + 1
            vc.cellCount = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}


