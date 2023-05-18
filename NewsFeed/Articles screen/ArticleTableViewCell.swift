//
//  ArticleTableViewCell.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import UIKit
import Kingfisher

protocol ArticleCellDelegate: AnyObject {
    func visitArticle(_ urlString: String?)
}

final class ArticleTableViewCell: UITableViewCell {
    static let reuseIdentifier = "articleTableViewCell"
    
    weak var delegate: ArticleCellDelegate?
    var articleURLString: String?
        
    private lazy var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.largeFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkText
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var abstractLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.mediumFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var authorAndTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.alignment = .firstBaseline
        return stackView
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.smallFont
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var createdAtLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.smallFont
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.faintBlue
        return view
    }()
    
    private lazy var ctaButton: UIButton = {
       let button = UIButton()
        button.addTarget(self, action: #selector(ctaPress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Visit Article", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = Constants.mediumFont
        button.backgroundColor = Constants.lightBlue
        button.layer.cornerRadius = 6
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureSubviews()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with article: Article) {
        self.authorLabel.text = authorNames(from: article.authors)
        self.createdAtLabel.text = article.timeSinceNow
        self.abstractLabel.text = article.theAbstract
        self.titleLabel.text = article.headline
        
        // Hold the url string for presentation.
        self.articleURLString = article.url
                
        articleImageView.backgroundColor = article.categories?.first?.colour

        if let thumbnailUrl = article.thumbnailUrl, let url = URL(string: thumbnailUrl) {
            articleImageView.kf.setImage(with: url)
        } else {
            articleImageView.image = nil
        }
    }
    
    private func authorNames(from authors: [Author]?) -> String {
        guard let authors = authors, !authors.isEmpty else {
            return "Unknown author"
        }
        
        let authorNames = authors.compactMap { $0.name }
        return authorNames.joined(separator: ", ")
    }
    
    private func configureSubviews() {
        contentView.addSubview(articleImageView)
        articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        articleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        articleImageView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        
        contentView.addSubview(authorAndTimeStackView)
        authorAndTimeStackView.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 12).isActive = true
        authorAndTimeStackView.trailingAnchor.constraint(equalTo: articleImageView.trailingAnchor).isActive = true
        authorAndTimeStackView.leadingAnchor.constraint(equalTo: articleImageView.leadingAnchor).isActive = true
        
        authorAndTimeStackView.addArrangedSubview(authorLabel)
        authorAndTimeStackView.addArrangedSubview(createdAtLabel)
        
        contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: authorAndTimeStackView.bottomAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: articleImageView.trailingAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: articleImageView.leadingAnchor).isActive = true
        
        contentView.addSubview(abstractLabel)
        abstractLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        abstractLabel.trailingAnchor.constraint(equalTo: articleImageView.trailingAnchor).isActive = true
        abstractLabel.leadingAnchor.constraint(equalTo: articleImageView.leadingAnchor).isActive = true
        
        contentView.addSubview(ctaButton)
        ctaButton.topAnchor.constraint(equalTo: abstractLabel.bottomAnchor, constant: 16).isActive = true
        ctaButton.trailingAnchor.constraint(equalTo: articleImageView.trailingAnchor).isActive = true
        ctaButton.leadingAnchor.constraint(equalTo: articleImageView.leadingAnchor).isActive = true
        ctaButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 36).isActive = true
        
        contentView.addSubview(dividerView)
        dividerView.topAnchor.constraint(equalTo: ctaButton.bottomAnchor, constant: 32).isActive = true
        dividerView.trailingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: -34).isActive = true
        dividerView.leadingAnchor.constraint(equalTo: articleImageView.leadingAnchor, constant: 34).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Anchor the bottom view's constraint to the bottom of the contentView.
        dividerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
    }
    
    @objc func ctaPress() {
        // Update delegate to attempt visiting the article.
        delegate?.visitArticle(articleURLString)
    }
}
