//
//  AlertDisplayer.swift
//  Countries
//
//  Created by Plamen I. Iliev on 21.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import UIKit

public protocol AlertDisplayer {}
public extension AlertDisplayer where Self: UIViewController {
    
    func showAlert(title: String? = nil, message: String, preferredStyle: UIAlertController.Style = .alert, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: title ?? Message.errorOccured, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Title.OK, style: .default, handler: nil))
            self?.present(alert, animated: true, completion: completion)
        }
    }
}
