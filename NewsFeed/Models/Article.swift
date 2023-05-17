//
//  Article.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import Foundation
import UIKit

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
        default:
            return UIColor.black
        }
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

