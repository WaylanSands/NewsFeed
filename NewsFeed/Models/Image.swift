//
//  Image.swift
//  NewsFeed
//
//  Created by Waylan Sands on 20/5/2023.
//

import Foundation

struct Image: Codable {
    let photographer: String?
    let type: String?
    let height: Int?
    let width: Int?
    let url: String?
}
