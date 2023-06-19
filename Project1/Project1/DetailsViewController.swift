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
    


}
