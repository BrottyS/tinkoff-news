//
//  TinkoffNewsDetailRequest.swift
//  TinkoffNews
//
//  Created by BrottyS on 02.01.2018.
//  Copyright © 2018 BrottyS. All rights reserved.
//

import Foundation

class TinkoffNewsDetailRequest: IRequest {
    private let baseUrl = "https://api.tinkoff.ru/v1/news_content"
    private let newId: String
    private var getParameters: [String: String]  {
        return ["id": newId]
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
    
    init(newId: String) {
        self.newId = newId
    }
    
}
