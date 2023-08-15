//
//  ViewController.swift
//  Project8
//
//  Created by Abdulkadir Oruç on 9.07.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    //Basılan harfler için
    var solutions = [String]()
    //Oyunun cevapları

    var score = 0{

        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var level = 1
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)

        activatedButtons.append(sender)

        UIView.animate(withDuration: 1, delay: 0) {
            sender.alpha = 0
        }
    }

    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }

        if let solutionPosition = solutions.firstIndex(of: answerText) {
            //Cevapların olduğu arrayden kullanıcın metninin ilk geçtiği indexi bulduk
            activatedButtons.removeAll()

            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1

            if ((answersLabel.text?.contains("letters")) == false){
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        }
        else{
            score -= 1
            let ac = UIAlertController(title: "You're wrong.", message: "Try again", preferredStyle: .alert)
            present(ac, animated: true,completion: nil)
            let delayInSeconds: TimeInterval = 0.5
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
                ac.dismiss(animated: true, completion: nil)
            }
        }
    }

    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        
        for btn in activatedButtons {
            UIView.animate(withDuration: 1, delay: 0) {
                btn.alpha = 1
            }
        }
        
        activatedButtons.removeAll()
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)

        loadLevel()

        for btn in letterButtons {
            btn.isHidden = false
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        //Metin kaç satırlı olacak? 0 demek ne kadar yer alırsa o kadar satırlı olacak demek.
        answersLabel.textAlignment = .right
        view.addSubview(answersLabel)
        
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        view.addSubview(submit)
        
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)

        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        view.addSubview(clear)
        
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderColor = CGColor(gray: 0.6, alpha: 0.4)
        buttonsView.layer.borderWidth = 4
        view.addSubview(buttonsView)
        
        let width = 150
        let height = 80
        

        // create 20 buttons as a 4x5 grid
        for row in 0..<4 {
            for col in 0..<5 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)

                // give the button some temporary text so we can see it on-screen
                letterButton.setTitle("WWW", for: .normal)

                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame

                // add it to the buttons view
                buttonsView.addSubview(letterButton)

                // and also to our letterButtons array
                letterButtons.append(letterButton)
                
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }

        
        
        //.isActive = true demektense activate metoduna bir constraint array i veriyoruz.
        NSLayoutConstraint.activate([
                scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
                scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
                // pin the top of the clues label to the bottom of the score label
                cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),

                // pin the leading edge of the clues label to the leading edge of our layout margins, adding 100 for some space
                cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),

                // make the clues label 60% of the width of our layout margins, minus 100
                cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),

                // also pin the top of the answers label to the bottom of the score label
                answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),

                // make the answers label stick to the trailing edge of our layout margins, minus 100
                answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),

                // make the answers label take up 40% of the available space, minus 100
                answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),

                // make the answers label match the height of the clues label
                answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
                currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
                currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
                
                submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
                submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
                submit.heightAnchor.constraint(equalToConstant: 44),

                clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
                clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
                clear.heightAnchor.constraint(equalToConstant: 44),
                
                buttonsView.widthAnchor.constraint(equalToConstant: 750),
                buttonsView.heightAnchor.constraint(equalToConstant: 320),
                buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
                buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
                
        ])
    }
    
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()

        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                //Burada txt dosyasından satırları alıyoruz
                lines.shuffle()

                for (index, line) in lines.enumerated() {
                    //enumerated() metodu bir arrayin elemanlarına ve o elemanların indexlerine bir döngüyle erişmemimiz sağlar
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]

                    clueString += "\(index + 1). \(clue)\n"

                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    //replacingOccurrences(of:,with:) metodu bir string içerisinde of parametresi ile belirtilen karakterlerin olduğu yerleri with ile değiştirmemizi sağlar
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)

                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        // Now configure the buttons and labels
        
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        //trimmingCharacters metodu bir stringin başından ve sonundan belirtilen harfleri kırpıp döndürür. Bu metod çoğunlukla whitespacesAndNewlines parametresi ile kullanılır. Bu parametre baştaki ve sondaki boşlukları, satır boşluklarını("\n") ve tab("\t") leri içerir.

        letterBits.shuffle()

        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
}

