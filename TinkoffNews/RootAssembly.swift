//
//  RootAssembly.swift
//  TinkoffNews
//
//  Created by BrottyS on 29.12.2017.
//  Copyright © 2017 BrottyS. All rights reserved.
//

protocol IRootAssembly: class {
    var newsListAssembly: INewsListAssembly { get set }
}

class RootAssembly: IRootAssembly {
    
    var newsListAssembly: INewsListAssembly
    
    private let tinkoffNewsService: ITinkoffNewsService = {
        let requestSender: IRequestSender = RequestSender()
        return TinkoffNewsService(requestSender: requestSender)
    }()
    
    private let cacheService: ICacheService = {
        let coreDataStack: ICoreDataStack = CoreDataStack()
        let cacheManager: ICacheManager = CacheManager(coreDataStack: coreDataStack)
        return CacheService(cacheManager: cacheManager)
    }()
    
    init() {
        newsListAssembly = NewsListAssembly(tinkoffNewsService: tinkoffNewsService, cacheService: cacheService)
    }
    
}
