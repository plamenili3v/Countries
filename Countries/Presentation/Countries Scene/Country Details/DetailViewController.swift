//
//  DetailViewController.swift
//  MobileTask
//
//  Created by Plamen I. Iliev on 23.08.20.
//  Copyright © 2020 Plamen I. Iliev. All rights reserved.
//

import UIKit
import MapKit

class PlaceDetailsViewController: UIViewController {

    @IBOutlet weak var emptyView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var priceRatingContainer: UIView!
    @IBOutlet weak var priceLevelView: TitledTextLabel!
    @IBOutlet weak var ratingView: TitledRatingView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var phoneAddressContainer: UIView!
    @IBOutlet weak var addressView: TitledTextLabel!
    @IBOutlet weak var phoneView: TitledTextLabel!
    
    @IBOutlet weak var openingHoursTableView: UITableView!
    @IBOutlet weak var openingHoursTableViewHeightConstraint: NSLayoutConstraint!
    
    var viewModel: PlaceDetailsViewModel!
    
    var detailItem: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let placeId = detailItem else {
            //empty view
            return
        }
        
        viewModel = PlaceDetailsViewModel(placeId: placeId)

        setupTableView()
        setupUI()
        setupVM()
    }
    
    private func setupUI() {
        setupBackgroundAppearances()
        setupTextAppearances()
    }
    
    private func setupBackgroundAppearances() {
        photoImageView.contentMode = .scaleAspectFill
        
        phoneAddressContainer.backgroundColor = #colorLiteral(red: 0.5484076142, green: 0.5710660815, blue: 0.6754823327, alpha: 1)
        addressView.view.backgroundColor = .clear
        phoneView.view.backgroundColor = .clear
        
        priceRatingContainer.backgroundColor = #colorLiteral(red: 0.5484076142, green: 0.5710660815, blue: 0.6754823327, alpha: 1)
        ratingView.view.backgroundColor = .clear
        priceLevelView.view.backgroundColor = .clear
    }
    
    private func setupTextAppearances() {
        ratingView.setTitle("Rating")
        ratingView.setTitleAppearance(TextAppearance(.boldSystemFont(ofSize: 15), .yellow, .clear))
        ratingView.setupRatingView(maxRating: 5, ratingImage: UIImage(named: "ic_star")!,
                                   ratingImageEmptyColor: .black, ratingImageFillColor: .orange)
        priceLevelView.setTitle("Price Level")
        priceLevelView.setTitleAppearance(TextAppearance(.boldSystemFont(ofSize: 15), .yellow, .clear))
        priceLevelView.setTextAppearance(TextAppearance(.systemFont(ofSize: 18), .white, .clear))
        addressView.setTitle("Address")
        addressView.setTitleAppearance(TextAppearance(.boldSystemFont(ofSize: 15), .yellow, .clear))
        addressView.setTextAppearance(TextAppearance(.systemFont(ofSize: 18), .white, .clear))
        phoneView.setTitle("Phone")
        phoneView.setTitleAppearance(TextAppearance(.boldSystemFont(ofSize: 15), .yellow, .clear))
        phoneView.setTextAppearance(TextAppearance(.systemFont(ofSize: 18), .white, .clear))
    }
    
    private func setupVM() {
        viewModel.updateTitleUI = { [weak self] title in
            DispatchQueue.main.async {
                self?.title = title
            }
        }
        
        viewModel.updateRatingUI = { [weak self] rating in
            DispatchQueue.main.async {
                if let rating = rating {
                    self?.ratingView.isHidden = false
                    self?.ratingView.setRating(rating)
                } else {
                    self?.ratingView.isHidden = true
                }
            }
        }
        
        viewModel.updatePriceLevelUI = { [weak self] priceLevel in
            DispatchQueue.main.async {
                self?.priceLevelView.isHidden = priceLevel == nil
                self?.priceLevelView.setText(priceLevel)
            }
        }
        
        viewModel.updateLocationUI = { [weak self] location in
            DispatchQueue.main.async {
                if let latitude = location?.latittude, let longitude = location?.longitude {
                    self?.mapView.isHidden = false
                    self?.mapView.addCenteredAnnotation(latitude: latitude, longitude: longitude)
                } else {
                    self?.mapView.isHidden = true
                }
            }
        }
        
        viewModel.updateAddressUI = { [weak self] address in
            DispatchQueue.main.async {
                self?.addressView.isHidden = address == nil
                self?.addressView.setText(address)
            }
        }
        
        viewModel.updatePhoneNumberUI = { [weak self] phone in
            DispatchQueue.main.async {
                self?.phoneView.isHidden = phone == nil
                self?.phoneView.setText(phone)
            }
        }
        
        viewModel.updateOpenHoursUI = { [weak self] in
            DispatchQueue.main.async {
                guard let safeSelf = self else { return }
                safeSelf.openingHoursTableView.reloadData()
                safeSelf.openingHoursTableViewHeightConstraint.constant =
                    CGFloat(Double(safeSelf.viewModel.openingHoursCount()) * UIKitConstants.OpeningHoursTableView.kEstimatedRowHeight)
            }
        }
        
        viewModel.updatePhoto = { [weak self] photoData in
            guard let safeSelf = self else { return }
            
            
            
            if let imageData = photoData, let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    safeSelf.photoImageView.isHidden = false
                    safeSelf.photoImageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    safeSelf.photoImageView.isHidden = true
                }
            }
        }
        
        viewModel.updateIsEmptyViewHiddenUI = { [weak self] shouldHide in
            DispatchQueue.main.async {
                self?.emptyView.isHidden = shouldHide
            }
        }
        
        viewModel.displayErrorMessage = { [weak self] errorMessage in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: Message.kErrorOccured, message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: Message.kOK, style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
}

//MARK: - TableView Methods
extension PlaceDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView() {
        openingHoursTableView.delegate = self
        openingHoursTableView.dataSource = self
        openingHoursTableView.separatorStyle = .none
        openingHoursTableView.alwaysBounceVertical = false
        openingHoursTableView.register(UITableViewCell.self, forCellReuseIdentifier: UIKitConstants.OpeningHoursTableView.kCellIdentifier)
        openingHoursTableView.estimatedRowHeight = CGFloat(UIKitConstants.OpeningHoursTableView.kEstimatedRowHeight)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.openingHoursCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let openingHour = viewModel.openingHourAt(indexPath.row) else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UIKitConstants.OpeningHoursTableView.kCellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = openingHour

        return cell
    }
}

