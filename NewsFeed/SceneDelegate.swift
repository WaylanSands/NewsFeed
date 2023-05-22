//
//  SceneDelegate.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
       
        // Retrieve the UIWindowScene from the provided UIScene.
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Create a new UIWindow using the retrieved UIWindowScene.
        let window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        
        // Initialise the AppCoordinator
        let appCoordinator = AppCoordinator(navigationController: navigationController)

        // Set the root view controller of the window to the appCoordinator's navigationController.
        window.rootViewController = navigationController
        
        // Set the created window as the scene's UIWindow.
        self.window = window
        
        // Make the window the key window and set it as visible.
        window.makeKeyAndVisible()
        
//        #if DEBUG
//        if ProcessInfo.processInfo.environment["NEWS-FEED-TESTS"] != nil {
//            return
//        }
//        #endif
        
        // Push CategoriesViewController onto the navigation stack
        appCoordinator.start()
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

