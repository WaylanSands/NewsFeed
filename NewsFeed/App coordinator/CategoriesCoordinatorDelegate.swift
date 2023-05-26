//
//  CategoriesCoordinator.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import Foundation

protocol CategoriesCoordinatorDelegate: AnyObject {
    func showArticles(_ articles: [Article])
}
