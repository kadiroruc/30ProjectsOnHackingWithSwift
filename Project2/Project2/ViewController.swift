//
//  ViewController.swift
//  Project2
//
//  Created by Abdulkadir Oruç on 17.06.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctFlag = 0
    var questionNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        askQuestion()
    }
    
    func askQuestion(action : UIAlertAction! = nil) {
        
        countries.shuffle()
        correctFlag = Int.random(in: 0...2)
        title = countries[correctFlag].uppercased() + "                       Score:\(score)"
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button1.imageView?.layer.borderWidth = 1
        button1.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button2.imageView?.layer.borderWidth = 1
        button2.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        button3.imageView?.layer.borderWidth = 1
        button3.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var alertTitle: String
        if sender.tag == correctFlag {
            alertTitle = "Correct"
            score += 1
            questionNumber += 1
        } else {
            alertTitle =
            """
            Wrong
            The choosen flag is \(countries[sender.tag].uppercased())
            """
            score -= 1
            questionNumber += 1
        }
        
        if questionNumber == 3{
            questionNumber = 0
            let ac = UIAlertController(title:"Finish", message: "Your score is \(score).", preferredStyle: .alert)
            score = 0
            ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: askQuestion))
            let closeAction = UIAlertAction(title: "Kapat", style: .destructive) { _ in
                UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
            }
            ac.addAction(closeAction)
            present(ac, animated: true)
        }
        
        
        let ac = UIAlertController(title: alertTitle, message: "Your score is \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
}

