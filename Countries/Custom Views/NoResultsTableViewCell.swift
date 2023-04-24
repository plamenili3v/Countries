//
//  NoResultsTableViewCell.swift
//  Countries
//
//  Created by Plamen I. Iliev on 24.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//
import UIKit

class NoResultsTableViewCell: UITableViewCell {

    static let reuseIdentifier = UIKitConstants.CountryTableView.noResultsCellIdentifier
    
    private let contentInsets: CGFloat = 8.0
    
    lazy var noResultsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.text = Title.noResults
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    private func setupCell() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        contentView.embedView(noResultsLabel, withPadding: contentInsets)
    }
}
