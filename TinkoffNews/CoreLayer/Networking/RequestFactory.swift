//
//  RequestFactory.swift
//  TinkoffNews
//
//  Created by BrottyS on 29.12.2017.
//  Copyright © 2017 BrottyS. All rights reserved.
//

struct RequestFactory {
    
    struct TinkoffNewsRequests {
        
        static func newsListConfig() -> RequestConfig<TinkoffNewsListParser> {
            let request = TinkoffNewsListRequest(first: 10, last: 15)
            return RequestConfig<TinkoffNewsListParser>(request: request, parser: TinkoffNewsListParser())
        }
        
    }
    
}
