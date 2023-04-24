//
//  TitledTextLabel.swift
//  Countries
//
//  Created by Plamen I. Iliev on 23.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import UIKit

class TitledTextLabel: LoadViewFromXibParentView {
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 1
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.textAlignment = .center
        }
    }
    @IBOutlet weak var textLabel: UILabel! {
        didSet {
            textLabel.numberOfLines = 0
            textLabel.adjustsFontSizeToFitWidth = false
            textLabel.textAlignment = .center
        }
    }
    
    func setTitleAppearance(_ textAppearance: TextAppearance) {
        titleLabel.font = textAppearance.font
        titleLabel.textColor = textAppearance.textColor
        titleLabel.backgroundColor = textAppearance.bgColor
    }
    
    func setTextAppearance(_ textAppearance: TextAppearance) {
        textLabel.font = textAppearance.font
        textLabel.textColor = textAppearance.textColor
        textLabel.backgroundColor = textAppearance.bgColor
    }
    
    func setTitle(_ text: String?) {
        titleLabel.text = text
    }
    
    func setText(_ text: String?) {
        textLabel.text = text
    }
}
