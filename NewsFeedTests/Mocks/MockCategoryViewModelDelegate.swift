//
//  MockCategoryViewModelDelegate.swift
//  NewsFeedTests
//
//  Created by Waylan Sands on 18/5/2023.
//

import Foundation

class MockCategoryViewModelDelegate: CategoryViewModelDelegate {
    var didLoadCategoriesCalled = false
    var presentErrorCalled = false
    var error: Error?
    
    func loadCategories() {
        didLoadCategoriesCalled = true
    }
    
    func present(_ error: Error) {
        presentErrorCalled = true
        self.error = error
    }
}
