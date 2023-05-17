//
//  ViewController.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    weak var coordinatorDelegate: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.        
    }


}

extension CategoriesViewController: CategoriesCoordinatable {
    func showDetailScreen() {
        //
    }
}
