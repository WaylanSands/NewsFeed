//
//  ArticleViewController.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import UIKit

final class ArticlesViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    /// Handles web view presentation
    var coordinatorDelegate: ArticleCoordinator?
    
    private let viewModel: ArticlesViewModel
    
    init(viewModel: ArticlesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle:  nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the data source and delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        configureSubviews()
    }
    
    private func configureSubviews() {
        view.addSubview(tableView)
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }

}

extension ArticlesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.reuseIdentifier) as? ArticleTableViewCell else {
            ErrorPresenter.presentErrorAlert(NewsFeedError.categoryCellError, from: self)
            return UITableViewCell()
        }
        
        let index = indexPath.row
        
        // Safely setup cell with article
        if index < viewModel.articles.count {
            let article = viewModel.articles[index]
            cell.setup(with: article)
        }
        
        cell.delegate = self
    
        return cell
    }
}

extension ArticlesViewController: ArticleCellDelegate {
    func visitArticle(_ urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            ErrorPresenter.presentErrorAlert(NewsFeedError.invalidURL, from: self)
            return
        }
        
        coordinatorDelegate?.presentWebView(with: url)
    }
}
