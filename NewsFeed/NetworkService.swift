//
//  NetworkService.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import Foundation

enum NewsFeedError: Error {
    case assetError
    case invalidURL
}

class NetworkService {
    
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
