//
//  Constants.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import UIKit

struct Constants {
    /// Fairfax Media code test URL.
    static let newsURL = URL(string: "https://bruce-v2-mob.fairfaxmedia.com.au/1/coding_test/13ZZQX/full")
    
    // MARK: - NewsFeed Colours
    static let darkGoldenrodColor = UIColor(hex: "#B8860B")
    static let darkCeruleanColor = UIColor(hex: "#167184")
    static let midnightBlueColor = UIColor(hex: "#1B2E43")
    static let darkOrchid2Color = UIColor(hex: "#9932CC")
    static let darkOrchidColor = UIColor(hex: "#8F588F")
    static let outerSpaceColor = UIColor(hex: "#3C4E4E")
    static let mediumBlueColor = UIColor(hex: "#3D66BE")
    static let steelBlueColor = UIColor(hex: "#137096")
    static let mossGreenColor = UIColor(hex: "#5C8A43")
    static let oliveDrabColor = UIColor(hex: "#757513")
    static let slateGrayColor = UIColor(hex: "#708090")
    static let royalBlueColor = UIColor(hex: "#4169E1")
    static let darkCyanColor = UIColor(hex: "#008B8B")
    static let pumpkinColor = UIColor(hex: "#EB8427")
    static let lightBlue = UIColor(hex: "#B7BBFF")
    static let faintBlue = UIColor(hex: "#E9ECFF")
    
    /// Returns a colourOptions colour based on the length of a string.
    static func colour(from text: String?) -> UIColor {
        guard let text = text else {
            return UIColor.black
        }
        
        let length = text.count
        let maxLength = colourOptions.count - 1
        let index = length <= maxLength ? length : length % maxLength
        return colourOptions[index] ?? UIColor.black
    }
    
    static let colourOptions = [
        darkGoldenrodColor,
        darkCeruleanColor,
        midnightBlueColor,
        darkOrchid2Color,
        darkOrchidColor,
        outerSpaceColor,
        mediumBlueColor,
        steelBlueColor,
        mossGreenColor,
        oliveDrabColor,
        slateGrayColor,
        royalBlueColor,
        darkCyanColor,
        pumpkinColor,
    ]
    
    // MARK: - NewsFeed Fonts
    static let smallFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
    static let mediumFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let largeFont = UIFont.systemFont(ofSize: 18, weight: .bold)
    static let extraLargeFont = UIFont.systemFont(ofSize: 23, weight: .bold)
}
