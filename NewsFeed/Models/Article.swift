//
//  Article.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import Foundation

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
}

struct Category: Codable, Hashable {
    let name: String?
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

