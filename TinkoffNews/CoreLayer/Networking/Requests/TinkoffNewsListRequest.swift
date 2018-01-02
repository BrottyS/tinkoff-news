//
//  TinkoffNewsListRequest.swift
//  TinkoffNews
//
//  Created by BrottyS on 29.12.2017.
//  Copyright © 2017 BrottyS. All rights reserved.
//

import Foundation

class TinkoffNewsListRequest: IRequest {
    private let baseUrl = "https://api.tinkoff.ru/v1/news"
    private let first: Int
    private let last: Int
    private var getParameters: [String: String]  {
        return ["first": String(first),
                "last": String(last)]
    }
    private var urlString: String {
        let getParams = getParameters.flatMap({ "\($0.key)=\($0.value)"}).joined(separator: "&")
        return baseUrl + "?" + getParams
    }
    
    // MARK: - IRequest
    
    var urlRequest: URLRequest? {
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        return nil
    }
    
    // MARK: - Initialization
    
    init(first: Int, last: Int) {
        self.first = first
        self.last = last
    }
    
}
