//
//  NewsListCell.swift
//  TinkoffNews
//
//  Created by BrottyS on 30.12.2017.
//  Copyright © 2017 BrottyS. All rights reserved.
//

import UIKit

class NewsListCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newTextLabel: UILabel!
    @IBOutlet weak var seenCountView: UIView!
    @IBOutlet weak var seenCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        seenCountView.layer.cornerRadius = seenCountView.frame.width / 2
    }
    
}
