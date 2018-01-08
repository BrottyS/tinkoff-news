//
//  NewsListViewController.swift
//  TinkoffNews
//
//  Created by BrottyS on 29.12.2017.
//  Copyright © 2017 BrottyS. All rights reserved.
//

import UIKit

class NewsListViewController: UIViewController, INewsListModelDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    private let assembly: INewsListAssembly
    private let model: INewsListModel
    
    private var dataSource: [NewsListCellDisplayModel] = []
    
    private let dateFormatter: DateFormatter
    
    init(assembly: INewsListAssembly, model: INewsListModel) {
        self.assembly = assembly
        self.model = model
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureTableView()
        
        model.fetchNewsFromCache()
        model.fetchNewsFromApi()
    }

    // MARK: - Private methods
    
    private func configureView() {
        navigationItem.title = "Тинькофф Новости"
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "\(NewsListCell.self)", bundle: nil), forCellReuseIdentifier: "\(NewsListCell.self)")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
    }
    
    // MARK: - INewsListModelDelegate
    
    func setup(dataSource: [NewsListCellDisplayModel]) {
        self.dataSource = dataSource
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func show(error message: String) {
        
    }
    
    func updateSeenCount(for newId: String, with newValue: Int) {
        if let index = dataSource.index(where: { $0.id == newId }) {
            dataSource[index].seenCount = newValue
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}

extension NewsListViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(NewsListCell.self)", for: indexPath) as! NewsListCell
        let new = dataSource[indexPath.row]
        cell.dateLabel.text = dateFormatter.string(from: new.date)
        cell.newTextLabel.text = new.text
        cell.seenCountLabel.text = String(new.seenCount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let new = dataSource[indexPath.row]
        
        model.incrementSeenCount(for: new.id)
        
        assembly.presentNewsDetailViewController(from: self, for: new.id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

