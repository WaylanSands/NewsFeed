//
//  ViewController.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import UIKit

class CategoriesViewController: UIViewController {
    let viewModel: CategoriesViewModel
    
    weak var coordinatorDelegate: Coordinator?
    
    init(viewModel: CategoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
