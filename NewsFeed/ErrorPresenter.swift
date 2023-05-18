//
//  ErrorPresenter.swift
//  NewsFeed
//
//  Created by Waylan Sands on 18/5/2023.
//

import UIKit

/// A simple class for presenting error messages via UIAlertController.
class ErrorPresenter {
    static func presentErrorAlert(_ error: Error, from viewController: UIViewController) {
        var message: String
        
        if let newsFeedError = error as? NewsFeedError {
            message = newsFeedError.description
        } else {
            message = error.localizedDescription
        }
        
        let alertController = UIAlertController(title: "Error occurred", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
