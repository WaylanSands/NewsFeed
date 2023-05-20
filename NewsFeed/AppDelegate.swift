//
//  AppDelegate.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Create an AppCoordinator instance for devices less than iOS 13.
        if #unavailable(iOS 13.0) {
            startAppCoordinator()
        }

        return true
    }
    
    private func startAppCoordinator() {
        // Create a new UIWindow instance.
        window = UIWindow()
        
        let navigationController = UINavigationController()
        
        // Initialise the AppCoordinator
        let appCoordinator = AppCoordinator(navigationController: navigationController)
        
        // Set the root view controller to the appCoordinator's navigationController.
        window?.rootViewController = navigationController
        
        // Make the window key and visible.
        window?.makeKeyAndVisible()
        
        // Push CategoriesViewController onto the navigation stack
        appCoordinator.start()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

