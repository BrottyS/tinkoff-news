//
//  TinkoffNewsService.swift
//  TinkoffNews
//
//  Created by BrottyS on 29.12.2017.
//  Copyright © 2017 BrottyS. All rights reserved.
//

protocol ITinkoffNewsService: class {
    func loadNews(first: Int, last: Int, completion: @escaping ([TinkoffNewsListApiModel]?, String?) -> Void)
    func loadNewDetail(newId: String, completion: @escaping (TinkoffNewsDetailApiModel?, String?) -> Void)
}

class TinkoffNewsService: ITinkoffNewsService {
    
    private let requestSender: IRequestSender
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    // MARK: - ITinkoffNewsService
    
    func loadNews(first: Int, last: Int, completion: @escaping ([TinkoffNewsListApiModel]?, String?) -> Void) {
        let requestConfig = RequestFactory.TinkoffNewsRequests.newsListConfig(first: first, last: last)
        
        requestSender.send(config: requestConfig) { (result: Result<[TinkoffNewsListApiModel]>) in
            switch result {
            case .success(let news):
                completion(news, nil)
            case .error(let error):
                completion(nil, error)
            }
        }
    }
    
    func loadNewDetail(newId: String, completion: @escaping (TinkoffNewsDetailApiModel?, String?) -> Void) {
        let requestConfig = RequestFactory.TinkoffNewsRequests.newsDetailConfig(newId: newId)
        
        requestSender.send(config: requestConfig) { (result: Result<TinkoffNewsDetailApiModel>) in
            switch result {
            case .success(let newDetail):
                completion(newDetail, nil)
            case .error(let error):
                completion(nil, error)
            }
        }
    }
    
}
