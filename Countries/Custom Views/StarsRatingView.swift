//
//  StarsRatingView.swift
//  MobileTask
//
//  Created by Plamen I. Iliev on 26.08.20.
//  Copyright © 2020 Plamen I. Iliev. All rights reserved.
//

import UIKit

class TitledRatingView: LoadViewFromXibParentView {

    @IBOutlet var stars: [UIImageView]! {
        didSet {
            stars.forEach {
                $0.image = UIImage(named: "ic_star")!.withRenderingMode(.alwaysTemplate)
                $0.tintColor = .black
                $0.contentMode = .center
            }
        }
    }
    
    func colorStarsForRating(rating: Int) {
        for i in 0...rating {
            guard i < stars.count else {
                break
            }
            
            stars[i].tintColor = .orange
        }
    }
}
