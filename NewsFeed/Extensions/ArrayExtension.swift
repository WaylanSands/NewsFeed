//
//  ArrayExtension.swift
//  NewsFeed
//
//  Created by Waylan Sands on 26/5/2023.
//

import Foundation

extension Array {
    /// Returns an element at the specified index or nil if the index is out of bounds.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
