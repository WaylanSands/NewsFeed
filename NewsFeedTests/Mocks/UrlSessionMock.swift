//
//  UrlSessionMock.swift
//  NewsFeedTests
//
//  Created by Waylan Sands on 18/5/2023.
//

import Foundation

/// TODO: These classes need more consideration and investigation.
class URLSessionDataTaskMock: URLSessionDataTask {
    private let mockResponse: URLResponse?
    private let mockError: Error?
    private let data: Data?
    
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.mockResponse = response
        self.mockError = error
        self.data = data
        super.init()
    }
    
    override func resume() {
        completionHandler?(data, mockResponse, mockError)
    }
}


class URLSessionMock: URLSession {
    private let mockDataTask: URLSessionDataTaskMock
    
    init(data: Data?, response: URLResponse?, error: Error? = nil) {
        mockDataTask = URLSessionDataTaskMock(data: data, response: response, error: error)
    }
    
    override class var shared: URLSession {
        URLSessionMock(data: nil, response: nil)
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        mockDataTask.completionHandler = completionHandler
        return mockDataTask
    }
}
