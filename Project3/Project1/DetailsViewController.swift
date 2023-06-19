//
//  DetailsViewController.swift
//  Project1
//
//  Created by Abdulkadir Oruç on 15.06.2023.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage:String?
    var imageNumber:Int?
    var cellCount:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let number = imageNumber, let count = cellCount{
            title = "Picture \(number) of \(count)"
        }else{
            title = selectedImage
        }
        
        //set large title configuration to never for this VC
        navigationItem.largeTitleDisplayMode = .never
        //target parameter says where shareTapped method is
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        if let image = selectedImage{
            imageView.image = UIImage(named: image)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }

        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }


}
