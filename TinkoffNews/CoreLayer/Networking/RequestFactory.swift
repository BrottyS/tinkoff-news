//
//  RequestFactory.swift
//  TinkoffNews
//
//  Created by BrottyS on 29.12.2017.
//  Copyright © 2017 BrottyS. All rights reserved.
//

struct RequestFactory {
    
    struct TinkoffNewsRequests {
        
        static func newsListConfig(first: Int, last: Int) -> RequestConfig<TinkoffNewsListParser> {
            let request = TinkoffNewsListRequest(first: first, last: last)
            return RequestConfig<TinkoffNewsListParser>(request: request, parser: TinkoffNewsListParser())
        }
        
        static func newsDetailConfig(newId: String) -> RequestConfig<TinkoffNewsDetailParser> {
            let request = TinkoffNewsDetailRequest(newId: newId)
            return RequestConfig<TinkoffNewsDetailParser>(request: request, parser: TinkoffNewsDetailParser())
        }
        
    }
    
}
