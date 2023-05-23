//
//  NetworkService.swift
//  NewsFeed
//
//  Created by Waylan Sands on 17/5/2023.
//

import Foundation
import SwiftUI

enum NewsFeedError: Error, CaseIterable {
    case categoryCellError
    case articleCellError
    case decodingError
    case missingAssets
    case networkError
    case invalidURL
    
    var description: String {
        switch self {
        case .missingAssets:
            return "We were unable to retrieve article assets from endpoint"
        case .invalidURL:
            return "Seems the url is invalid for the request"
        case .categoryCellError:
            return "We ran into an issue creating category cells"
        case .articleCellError:
            return "We ran into an issue creating article cells"
        case .decodingError:
            return "We ran into an issue decoding the response"
        case .networkError:
            return "We had a problem fetching data"
        }
    }
    
    var errorCode: String {
        let index = NewsFeedError.allCases.firstIndex(of: self)!
        return "error \(index)"
    }
}

protocol ArticleService {
    func getArticleList() async -> Result<[Article], Error>
}

class NetworkService: ArticleService {
    
    private let urlSession: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.urlSession = session
    }
    
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
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                return .failure(NewsFeedError.networkError)
            }
            
            let decoder = JSONDecoder()
            let listResponse = try? decoder.decode(ArticleListResponse.self, from: data)
                        
            guard let assets = listResponse?.assets else {
                return .failure(NewsFeedError.decodingError)
            }
            
            guard !assets.isEmpty else {
                return .failure(NewsFeedError.missingAssets)
            }
            
            return .success(assets)
        } catch {
            return .failure(error)
        }
    }
}
