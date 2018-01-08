//
//  NewsDetailViewController.swift
//  TinkoffNews
//
//  Created by BrottyS on 02.01.2018.
//  Copyright © 2018 BrottyS. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController, INewsDetailModelDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    private let model: INewsDetailModel
    
    private var data: NewsDetailDisplayModel?
    
    init(model: INewsDetailModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.fetchNewDetailFromCache()
        model.fetchNewDetailFromApi()
    }

    // MARK: - INewsDetailModelDelegate
    
    func setup(data: NewsDetailDisplayModel) {
        self.data = data
        
        if let data = self.data {
            DispatchQueue.main.async {
                self.webView.loadHTMLString(data.content, baseURL: nil)
            }
        }
        
    }
    
    func show(error message: String) {
        
    }

}
