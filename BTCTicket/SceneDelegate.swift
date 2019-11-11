//
//  SceneDelegate.swift
//  BTCTicket
//
//  Created by Javid Sheikh on 11/11/2019.
//  Copyright © 2019 Quaxo Digital. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let networkingService = NetworkService(configuration: .default,
                                               urlString: NetworkService.blockchainTickerURLString)
        let viewModel = GBPToBitcoinViewModel(networkingService: networkingService)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard var viewController = storyboard.instantiateInitialViewController() as? GBPToBitcoinViewController else {
            return
        }
        viewController.bindViewModel(to: viewModel)

        window.rootViewController = viewController

        self.window = window
        window.makeKeyAndVisible()
    }
}
