//
//  ViewController.swift
//  Project10
//
//  Created by Abdulkadir Oruç on 3.08.2023.
//

import UIKit

class ViewController: UICollectionViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate /*bu protokol bu uygulamamız için gerekli değil*/{
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {

            fatalError("Unable to dequeue PersonCell.")
        }
        let person = people[indexPath.item]
        cell.name.text = person.name

        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        // if we're still here it means we got a PersonCell, so we can return it
        return cell
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        //picker.sourceType = .camera //unavailable on simulator
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        //seçilen resim info dictionarysi ile geri döndürülür.
        let imageName = UUID().uuidString
        //dosyayı kaydetmek için id ile bir dosya ismi oluşturuyoruz.
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        //getDocumentsDirectory() metodundan geri dönen path e bizim image id mizi de ekliyoruz. Yani resmin kaydedileceği pathi belirlemiş oluyoruz.
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()

        dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
       
        
        let ac2 = UIAlertController(title: "Do you want to rename or delete?", message: nil, preferredStyle: .alert)
        ac2.addAction(UIAlertAction(title: "Rename", style: .default,handler: {[weak self] _ in
            self?.dismiss(animated: true) {
                let ac = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
                ac.addTextField()
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                ac.addAction(UIAlertAction(title: "Save", style: .default,handler: {[weak self, weak ac] _ in
                    guard let newName = ac?.textFields?[0].text else{return}
                    person.name = newName
                    self?.collectionView.reloadData()
                }))
                self?.present(ac, animated: true)
            }
        }))
        ac2.addAction(UIAlertAction(title: "Delete", style: .destructive,handler: {[weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.reloadData()
        }))
        present(ac2, animated: true)
    }
    
    

}

