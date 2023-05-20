//
//  ViewController.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import UIKit

final class CategoriesViewController: UIViewController {
    private let viewModel: CategoriesViewModel
    
    private lazy var collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 23, left: 16, bottom: 23, right: 16)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        // Calculate item width based on the number of columns
        let columns: CGFloat = 2
        let columnPadding: CGFloat = 10
        let horizontalPadding: CGFloat = layout.sectionInset.left +  layout.sectionInset.right
        let availableWidth = view.bounds.width - horizontalPadding - columnPadding
        let itemWidth = availableWidth / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.itemSize = itemSize
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionLayout)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    var coordinatorDelegate: CategoriesCoordinator?
    
    init(viewModel: CategoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        self.title = viewModel.title
        self.fetchArticles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Set the data source and delegate
        collectionView.dataSource = self
        collectionView.delegate = self
        
        configureSubviews()
    }
    
    func fetchArticles() {
        Task {
            await self.viewModel.fetchArticles()
        }
    }
    
    private func configureSubviews() {
        view.addSubview(collectionView)
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
}

extension CategoriesViewController: CategoryViewModelDelegate {
    func present(_ error: Error) {
        // Present error on the main thread.
        DispatchQueue.main.async {
            ErrorPresenter.presentErrorAlert(error, from: self)
        }
    }
    
    func loadCategories() {
        // Handle update of data on the main thread.
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension CategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionViewCell.identifier,
            for: indexPath) as? CategoryCollectionViewCell else {
            ErrorPresenter.presentErrorAlert(NewsFeedError.categoryCellError, from: self)
            return UICollectionViewCell()
        }
    
        if indexPath.item <= viewModel.categories.count {
            let category = viewModel.categories[indexPath.item]
            cell.setup(with: category)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        
        // Safety check the index is within range.
        guard index < viewModel.categories.count else {
            return
        }
        
        let selectedCategory = viewModel.categories[index]
        
        // Get all articles within the selected category.
        let articles = viewModel.articlesWithin(selectedCategory)
                
        coordinatorDelegate?.showArticles(articles)
    }
}
