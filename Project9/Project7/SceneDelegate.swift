//
//  SceneDelegate.swift
//  Project7
//
//  Created by Abdulkadir Oruç on 7.07.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        //UITabBarController initial vc olduğu için rootViewController diyoruz.
        if let tabBarController = window?.rootViewController as? UITabBarController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //You don't need to provide a bundle, because nil means "use my current app bundle."
            let nc = storyboard.instantiateViewController(withIdentifier: "NavController")
           //Bu yöntem storyboard da Storyboard ID ile belirtilen id ye sahip view controllerdan oluşturur yani kopyalar. Burada navigation controller ı aldık çünkü TabBarController içerisinde Navigation Controller gömmüştük. Alttaki kodlarla birlikte de Tab Bar a yeni buton ekliyoruz. Bu botunda yeni bir navigation controller olmuş oluyor.
            //View Controller ın da hangi navigation controller la geldiğini anlamak için tabBarItem ına tag değeri veriyoruz. VC içinde navigationController?.tabBarItem.tag == 0 şeklinde kontrol ediyoruz.
            nc.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 1)
            
            let nc2 = storyboard.instantiateViewController(withIdentifier: "NavController")
            nc2.tabBarItem = UITabBarItem(title: "Credits", image: UIImage(systemName: "info"), tag: 2)
            tabBarController.viewControllers?.append(nc)
            tabBarController.viewControllers?.append(nc2)
        }
        
        //the code creates a duplicate ViewController wrapped inside a navigation controller, gives it a new tab bar item to distinguish it from the existing tab, then adds it to the list of visible tabs. This lets us use the same class for both tabs without having to duplicate things in the storyboard.
        //The reason we gave a tag of 1 to the new UITabBarItem is because it's an easy way to identify it. Remember, both tabs contain a ViewController, which means the same code is executed.
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

