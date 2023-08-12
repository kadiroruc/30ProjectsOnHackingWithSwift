//
//  ViewController.swift
//  ChallengeDay50
//
//  Created by Abdulkadir Oruç on 11.08.2023.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var photos = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openTapped))
        readWithUserDefaults()
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") else{fatalError()}
        cell.textLabel?.text = photos[indexPath.row].caption
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var image = UIImage()
        if let savedData = readFileFromDocumentsDirectory(fileName: photos[indexPath.row].fileName){
            if let img = UIImage(data: savedData){
                image = img
            }
        }
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController{
            vc.selectedImage = image
            vc.title = photos[indexPath.row].caption
            navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self](action, view, completion) in
            // Silme işlemini gerçekleştir
            self?.photos.remove(at: indexPath.row)
            self?.saveWithUserDefaults()
            tableView.reloadData()
            completion(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let renameAction = UIContextualAction(style: .normal, title: "Rename") {[weak self](action, view, completion) in
            let ac = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Save", style: .default,handler: { _ in
                self?.photos[indexPath.row].caption = ac.textFields?[0].text ?? ""
                self?.saveWithUserDefaults()
                tableView.reloadData()
            }))
            self?.present(ac,animated: true)
            
            completion(true)
        }
        renameAction.backgroundColor = .systemGreen
        let configuration = UISwipeActionsConfiguration(actions: [renameAction])
        return configuration
    }

    @objc func openTapped(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker,animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        
        if let jpegData = image.jpegData(compressionQuality: 0.5){
            saveFileToDocumentsDirectory(data: jpegData, fileName: imageName)
        }
        let photo = Photo(fileName: imageName, caption: "Unknown")
        photos.append(photo)
        saveWithUserDefaults()
        tableView.reloadData()
        dismiss(animated: true)
    }
    
    func saveFileToDocumentsDirectory(data: Data, fileName: String) -> URL? {
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent(fileName)
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Error saving file:", error)
            return nil
        }
    }

    func readFileFromDocumentsDirectory(fileName: String) -> Data? {
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent(fileName)
            let data = try Data(contentsOf: fileURL)
            return data
        } catch {
            print("Error reading file:", error)
            return nil
        }
    }
    
    func saveWithUserDefaults(){
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(photos){
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "photos")
        }
        else{
            print("Failed to save data")
        }
    }
    func readWithUserDefaults(){
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: "photos") as? Data{
            let jsonDecoder = JSONDecoder()
            do{
               photos = try jsonDecoder.decode([Photo].self, from: savedData)
            }catch{
                print("Error at reading")
            }
        }
    }
}

