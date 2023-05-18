//
//  NetworkService.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import Foundation

enum NewsFeedError: Error {
    case categoryCellError
    case articleCellError
    case assetError
    case invalidURL
    
    var description: String {
        switch self {
        case .assetError:
            return "We were unable to retrieve article assets from endpoint"
        case .invalidURL:
            return "Seems the url is invalid for the request"
        case .categoryCellError:
            return "We ran into an issue creating category cells"
        case .articleCellError:
            return "We ran into an issue creating article cells"
        }
    }
}

protocol ArticleService {
    func getArticleList() async -> Result<[Article], Error>
}

class NetworkService: ArticleService {
    /// Will attempt to fetch an Array of Article from the FairFax URL.
    /// Returns a Result of type [Article] or Error.
    func getArticleList() async -> Result<[Article], Error> {
        guard let URL = Constants.newsURL else {
            return .failure(NewsFeedError.invalidURL)
        }

        var request = URLRequest(url: URL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            let listResponse = try decoder.decode(ArticleListResponse.self, from: data)
            
            guard let assets = listResponse.assets, !assets.isEmpty else {
                return .failure(NewsFeedError.assetError)
            }
            
            return .success(assets)
        } catch {
            return .failure(error)
        }
    }
}
