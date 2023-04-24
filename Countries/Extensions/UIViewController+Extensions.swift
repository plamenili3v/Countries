//
//  UIViewController+Extensions.swift
//  Countries
//
//  Created by Plamen I. Iliev on 24.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//
import UIKit

extension UIViewController {
    var isLoading: Bool {
        navigationItem.titleView?.isKind(of: UIActivityIndicatorView.self) ?? false
    }
    
    func showActivityIndicatorInNavigationBarTitle() {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        navigationItem.titleView = indicator
    }

    func hideActivityIndicatorInNavigationBarTitle() {
        let titleLabel = UILabel()
        titleLabel.text = title
        navigationItem.titleView = titleLabel
    }
}
