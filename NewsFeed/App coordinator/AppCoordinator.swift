//
//  AppCoordinator.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
}

/// AppCoordinator serves as the main coordinator responsible for managing the navigation flow within the app.
class AppCoordinator: Coordinator {
    private var navigationController: UINavigationController
    private var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let service = NetworkService()
        let viewModel = CategoriesViewModel(networkService: service)
        let categoriesViewController = CategoriesViewController(viewModel: viewModel)
        categoriesViewController.coordinatorDelegate = self
        
        navigationController.pushViewController(categoriesViewController, animated: false)
    }
}

extension AppCoordinator: CategoriesCoordinator {
    func showArticles(_ articles: [Article]) {
        let viewModel = ArticlesViewModel(articles: articles)
        let viewController = ArticlesViewController(viewModel: viewModel)
        viewController.coordinatorDelegate = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension AppCoordinator: ArticleCoordinator {
    func presentWebView(with url: URL) {
        let webViewViewController = WebViewController(url: url)
        navigationController.pushViewController(webViewViewController, animated: true)
    }
}
