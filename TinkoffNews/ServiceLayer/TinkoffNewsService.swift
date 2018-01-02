//
//  TinkoffNewsService.swift
//  TinkoffNews
//
//  Created by BrottyS on 29.12.2017.
//  Copyright © 2017 BrottyS. All rights reserved.
//

protocol ITinkoffNewsService: class {
    func loadNews(completionHandler: @escaping ([TinkoffNewsListApiModel]?, String?) -> Void)
}

class TinkoffNewsService: ITinkoffNewsService {
    
    private let requestSender: IRequestSender
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    // MARK: - ITinkoffNewsService
    
    func loadNews(completionHandler: @escaping ([TinkoffNewsListApiModel]?, String?) -> Void) {
        let requestConfig = RequestFactory.TinkoffNewsRequests.newsListConfig()
        
        requestSender.send(config: requestConfig) { (result: Result<[TinkoffNewsListApiModel]>) in
            switch result {
            case .success(let news):
                completionHandler(news, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }
    
}
