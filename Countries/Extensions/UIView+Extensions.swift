//
//  UIView+Extensions.swift
//  Countries
//
//  Created by Plamen I. Iliev on 24.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//
import UIKit

extension UIView {
    
    func embedView(_ view: UIView, withPadding padding: CGFloat = 0.0) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            view.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
            view.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding),
        ])
    }
}
