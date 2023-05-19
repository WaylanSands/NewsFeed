//
//  DateExtension.swift
//  NewsFeed
//
//  Created by Waylan Sands on 18/5/2023.
//

import Foundation

extension Date {
    /// Returns a localised string representing the relative time difference.
    var timeSinceNow: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        
        let currentDate = Date()
        
        return formatter.localizedString(for: self, relativeTo: currentDate)
    }
}
