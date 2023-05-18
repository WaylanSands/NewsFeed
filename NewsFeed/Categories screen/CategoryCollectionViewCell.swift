//
//  CategoryCollectionViewCell.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "categoryCollectionViewCell"
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.extraLargeFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        contentView.addSubview(cardView)
        cardView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cardView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        cardView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cardView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        // Add the titleLabel as a subview to the cardView
        cardView.addSubview(titleLabel)
        titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true
    }
    
    func setup(with category: Category) {
        self.cardView.backgroundColor =  category.colour
        self.titleLabel.text = category.name ?? ""
    }
    
}
