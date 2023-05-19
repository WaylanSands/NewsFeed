//
//  Article.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import Foundation
import UIKit

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
        guard let timeStamp = timeStamp else {
            return nil
        }

        return Date(timeIntervalSince1970: TimeInterval(timeStamp / 1000))
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
    
    /// Used for Unit testing
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

struct Category: Codable, Hashable {
    let name: String?
    
    var colour: UIColor? {
        switch name?.lowercased() {
        case "business":
            return Constants.darkCeruleanColor
        case "investment banking":
            return Constants.midnightBlueColor
        case "workplace":
            return Constants.darkGoldenrodColor
        case "rear window":
            return Constants.darkOrchid2Color
        case "banking & finance":
            return Constants.darkOrchidColor
        case "national":
            return Constants.mediumBlueColor
        case "personal finance":
            return Constants.mossGreenColor
        case "aviation":
            return Constants.oliveDrabColor
        case "technology":
            return Constants.outerSpaceColor
        case "specialist investments":
            return Constants.pumpkinColor
        case "chanticleer":
            return Constants.steelBlueColor
        case "life and leisure":
            return Constants.slateGrayColor
        case "residential":
            return Constants.royalBlueColor
        case "street talk":
            return Constants.darkCyanColor
        case "commercial":
            return Constants.darkCeruleanColor
        case "economy":
            return Constants.mediumBlueColor
        case "business education":
            return Constants.oliveDrabColor
        case "north america":
            return Constants.darkOrchidColor
        default:
            return UIColor.black
        }
    }
}

// Conveniently sort by name for array comparison.
extension Category: Comparable {
    static func < (lhs: Category, rhs: Category) -> Bool {
        let leftName = lhs.name ?? ""
        let rightName = rhs.name ?? ""
        return leftName < rightName
    }
}

struct Author: Codable {
    let title: String?
    let name: String?
}

struct Image: Codable {
    let photographer: String?
    let type: String?
    let height: Int?
    let width: Int?
    let url: String?
}

