//
//  Article.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import Foundation
import UIKit

/// Main response type from FairFax API.
struct ArticleListResponse: Codable {
    let assets: [Article]?
}

struct Article: Codable {
    let tabletHeadline: String?
    let categories: [Category]?
    let relatedImages: [Image]?
    let authors: [Author]?
    let headline: String?
    let theAbstract: String?
    let assetType: String?
    let sponsored: Bool?
    let byLine: String?
    let timeStamp: Int?
    let url: String?
    let id: Int?
    
    var createdDate: Date? {
        guard let timeStamp = timeStamp else { return nil }
        let interval = TimeInterval(timeStamp / 1000)

        return Date(timeIntervalSince1970: interval)
    }
    
    /// Returns the url of first image of type "thumbnail" from imageAssets,
    /// otherwise the url of the smallest image (in width).
    /// Will return nil if relatedImages is nil or empty.
    var thumbnailUrl: String? {
        guard let imageAssets = relatedImages, !imageAssets.isEmpty else {
            return nil
        }
        
        let thumbnail = imageAssets.first { $0.type?.lowercased() == "thumbnail" }
        let validImages = imageAssets.filter { $0.url != nil && $0.width != nil }
        let smallestImage = validImages.sorted { $0.width! < $1.width! }.first
        
        return thumbnail?.url ?? smallestImage?.url
    }
}

// Conveniently sort by timeStamp or compare via ID.
extension Article: Comparable, Hashable {
    /// Compares articles via  id
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    /// Sorts articles by  timeStamp. Articles with a nil timestamp
    /// will be set towards the back.
    static func < (lhs: Article, rhs: Article) -> Bool {
        return lhs.timeStamp ?? Int.max < rhs.timeStamp ?? Int.max
    }
}


extension Article {
    /// Used for convenience when Unit testing
    init(category: Category, timeStamp: Int? = nil) {
        self.categories = [category]
        self.timeStamp = timeStamp
        self.tabletHeadline = nil
        self.relatedImages = nil
        self.authors = nil
        self.headline = nil
        self.theAbstract = nil
        self.assetType = nil
        self.sponsored = nil
        self.byLine = nil
        self.url = nil
        self.id = nil
    }
}
