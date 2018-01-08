//
//  UIViewControllerExtensions.swift
//  TinkoffNews
//
//  Created by BrottyS on 08.01.2018.
//  Copyright © 2018 BrottyS. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }

}
