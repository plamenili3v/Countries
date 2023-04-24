//
//  UIKitConstants.swift
//  Countries
//
//  Created by Plamen I. Iliev on 21.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//
import UIKit

typealias TextAppearance = (font: UIFont, textColor: UIColor, bgColor: UIColor)

struct UIKitConstants {
    struct CountryTableView {
        static let countryCellIdentifier = "cellReuseIdentifier_CountryTableViewCell"
        static let noResultsCellIdentifier = "cellReuseIdentifier_NoResultsTableViewCell"
    }
    
    struct ColorAssets {
        static let themeBlue = UIColor(red: 0/255, green: 50/255, blue: 100/255, alpha: 1)
        static let federalBlue = UIColor(red: 15/255, green: 8/255, blue: 75/255, alpha: 1)
        static let sunglow = UIColor(red: 255/255, green: 210/255, blue: 63/255, alpha: 1)
    }
}
