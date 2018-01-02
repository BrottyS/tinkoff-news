//
//  NewsListAssembly.swift
//  TinkoffNews
//
//  Created by BrottyS on 29.12.2017.
//  Copyright © 2017 BrottyS. All rights reserved.
//

protocol INewsListAssembly: class {
    func newsListViewController() -> NewsListViewController
    func presentNewsDetailViewController(from vc: NewsListViewController, for newId: String)
}

class NewsListAssembly: INewsListAssembly {
    
    private let tinkoffNewsService: ITinkoffNewsService
    private let cacheService: ICacheService
    
    init(tinkoffNewsService: ITinkoffNewsService, cacheService: ICacheService) {
        self.tinkoffNewsService = tinkoffNewsService
        self.cacheService = cacheService
    }
    
    func newsListViewController() -> NewsListViewController {
        let model = newsListModel()
        let viewController = NewsListViewController(assembly: self, model: model)
        model.delegate = viewController
        return viewController
    }
    
    func presentNewsDetailViewController(from vc: NewsListViewController, for newId: String) {
        let newsDetailAssembly: INewsDetailAssembly = NewsDetailAssembly(tinkoffNewsService: tinkoffNewsService, cacheService: cacheService, newId: newId)
        let newDetailVC = newsDetailAssembly.newsDetailViewController()
        vc.navigationController?.pushViewController(newDetailVC, animated: true)
    }
    
    // MARK: - Private section
    
    private func newsListModel() -> INewsListModel {
        return NewsListModel(tinkoffNewsService: tinkoffNewsService, cacheService: cacheService)
    }
    
}
