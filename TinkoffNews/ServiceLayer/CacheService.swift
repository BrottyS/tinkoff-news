//
//  CacheService.swift
//  TinkoffNews
//
//  Created by BrottyS on 30.12.2017.
//  Copyright © 2017 BrottyS. All rights reserved.
//

import CoreData

protocol ICacheService: class {
    func getNews(completion: @escaping ([TinkoffNewsListCacheModel]?, String?) -> ())
    func saveNews(news: [TinkoffNewsListApiModel])
}

class CacheService: ICacheService {
    
    private let cacheManager: ICacheManager
    
    init(cacheManager: ICacheManager) {
        self.cacheManager = cacheManager
    }
    
    // MARK: - ICacheService
    
    func getNews(completion: @escaping ([TinkoffNewsListCacheModel]?, String?) -> ()) {
        cacheManager.getNews { (news, error) in
            completion(news, error)
        }
    }
    
    func saveNews(news: [TinkoffNewsListApiModel]) {
        cacheManager.saveNews(news: news)
    }
    
}
