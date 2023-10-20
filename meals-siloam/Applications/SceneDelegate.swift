//
//  SceneDelegate.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 20/10/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.backgroundColor = UIColor.white
        
        if let window = window {
            let mainVC = FindMealsViewController()
            let navigationController = UINavigationController.init(rootViewController: mainVC)
            navigationController.navigationBar.tintColor = .black
            window.rootViewController = navigationController
        }
        window?.overrideUserInterfaceStyle = .light
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
    }
}

