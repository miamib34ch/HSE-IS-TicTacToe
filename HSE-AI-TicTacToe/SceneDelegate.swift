//
//  SceneDelegate.swift
//  HSE-AI-TicTacToe
//
//  Created by Богдан Полыгалов on 25.10.2023.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        window.rootViewController = ViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
}
