//
//  NewsDetailViewController.swift
//  TinkoffNews
//
//  Created by BrottyS on 02.01.2018.
//  Copyright © 2018 BrottyS. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController, INewsDetailModelDelegate {

    private let model: INewsDetailModel
    
    init(model: INewsDetailModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - INewsDetailModelDelegate
    
    

}
