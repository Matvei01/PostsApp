//
//  AppDelegate.swift
//  PostsApp
//
//  Created by Matvei Khlestov on 16.07.2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var storageManager = StorageManager.shared

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(
            rootViewController: PostsViewController()
        )
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        storageManager.saveContext()
    }
}

