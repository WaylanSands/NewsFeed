//
//  Category.swift
//  NewsFeed
//
//  Created by Waylan Sands on 20/5/2023.
//

import UIKit

struct Category: Codable, Hashable {
    let name: String?
    
    /// Returns a colour based on the length of the name.
    var colour: UIColor {
        Constants.colour(from: name)
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
