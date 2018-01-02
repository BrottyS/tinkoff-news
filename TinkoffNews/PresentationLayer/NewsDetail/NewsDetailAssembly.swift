//
//  NewsDetailAssembly.swift
//  TinkoffNews
//
//  Created by BrottyS on 02.01.2018.
//  Copyright © 2018 BrottyS. All rights reserved.
//

protocol INewsDetailAssembly: class {
    func newsDetailViewController() -> NewsDetailViewController
}

class NewsDetailAssembly: INewsDetailAssembly {
    
    private let tinkoffNewsService: ITinkoffNewsService
    private let cacheService: ICacheService
    private let newId: String
    
    init(tinkoffNewsService: ITinkoffNewsService, cacheService: ICacheService, newId: String) {
        self.tinkoffNewsService = tinkoffNewsService
        self.cacheService = cacheService
        self.newId = newId
    }
    
    func newsDetailViewController() -> NewsDetailViewController {
        let model = newsDetailModel()
        let viewController = NewsDetailViewController(model: model)
        model.delegate = viewController
        return viewController
    }
    
    // MARK: - Private methods
    
    private func newsDetailModel() -> INewsDetailModel {
        return NewsDetailModel(tinkoffNewsService: tinkoffNewsService, cacheService: cacheService, newId: newId)
    }
    
}
