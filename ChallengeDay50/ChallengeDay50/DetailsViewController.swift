//
//  DetailsViewController.swift
//  ChallengeDay50
//
//  Created by Abdulkadir Oruç on 11.08.2023.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = selectedImage
        // Do any additional setup after loading the view.
    }


}
