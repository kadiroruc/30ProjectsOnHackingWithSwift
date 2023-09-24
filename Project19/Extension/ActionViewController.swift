//
//  ActionViewController.swift
//  Extension
//
//  Created by Abdulkadir Oruç on 20.08.2023.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!
    var pageTitle = ""
    var pageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""

                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
/*        // Get the item[s] we're handling from the extension context.
        
        // For example, look for an image and place it into an image view.
        // Replace this with something appropriate for the type[s] your extension supports.
        var imageFound = false
        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! {
                if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                    // This is an image. We'll load it, then place it in our image view.
                    weak var weakImageView = self.imageView
                    provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil, completionHandler: { (imageURL, error) in
                        OperationQueue.main.addOperation {
                            if let strongImageView = weakImageView {
                                if let imageURL = imageURL as? URL {
                                    strongImageView.image = UIImage(data: try! Data(contentsOf: imageURL))
                                }
                            }
                        }
                    })
                    
                    imageFound = true
                    break
                }
            }
            
            if (imageFound) {
                // We only handle one image, so stop looking for more.
                break
            }
        }*/
        
        
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]

        extensionContext?.completeRequest(returningItems: [item])
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        script.scrollIndicatorInsets = script.contentInset

        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }

}
