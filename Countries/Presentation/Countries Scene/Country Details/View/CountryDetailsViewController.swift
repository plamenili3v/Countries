//
//  CountryDetailsViewController.swift
//  Countries
//
//  Created by Plamen I. Iliev on 23.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import UIKit
import MapKit
import SVGKit
import WebKit

class CountryDetailsViewController: UIViewController, MKMapViewDelegate, AlertDisplayer {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var populationAndCapitalContainer: UIView!
    @IBOutlet weak var flagPhotoImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var populationView: TitledTextLabel!
    @IBOutlet weak var capitalView: TitledTextLabel!
    
    var viewModel: CountryDetailsViewModelProtocol!
    
    var country: Country?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        setupUI()
        setupVM()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Setup
    private func setupUI() {
        showActivityIndicatorInNavigationBarTitle()
        setupBackgroundAppearances()
        setupTextAppearances()
    }
    
    private func setupBackgroundAppearances() {
        populationAndCapitalContainer.backgroundColor = .clear
        populationView.view.backgroundColor = UIKitConstants.ColorAssets.federalBlue
        capitalView.view.backgroundColor = UIKitConstants.ColorAssets.federalBlue
    }
    
    private func setupTextAppearances() {
        populationView.setTitle(Title.population)
        populationView.setTitleAppearance(TextAppearance(.boldSystemFont(ofSize: 18),.white, .clear))
        populationView.setTextAppearance(TextAppearance(.systemFont(ofSize: 24), UIKitConstants.ColorAssets.sunglow, .clear))
        capitalView.setTitle(Title.capital)
        capitalView.setTitleAppearance(TextAppearance(.boldSystemFont(ofSize: 18), .white, .clear))
        capitalView.setTextAppearance(TextAppearance(.systemFont(ofSize: 24), UIKitConstants.ColorAssets.sunglow, .clear))
    }
    
    private func setupVM() {
        if viewModel == nil {
            viewModel = CountryDetailsViewModel(country: country)
        }

        viewModel.updateUI.observe(on: self) { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }
    
    func updateUI() {
        hideActivityIndicatorInNavigationBarTitle()
        
        title = viewModel.title
        
        if let latitude = viewModel.location?.latitude, let longitude = viewModel.location?.longitude {
            mapView.isHidden = false
            mapView.addCenteredAnnotation(latitude: latitude, longitude: longitude)
        } else {
            mapView.isHidden = true
        }
        
        if let flagPhotoUrl = viewModel.flagPhotoUrl, let image = SVGKImage(contentsOf: flagPhotoUrl)?.uiImage.resized(toWidth: view.bounds.width) {
            flagPhotoImageView.isHidden = false
            flagPhotoImageView.image = image
        } else {
            flagPhotoImageView.isHidden = true
        }
        
        populationView.isHidden = viewModel.population == nil
        populationView.setText(viewModel.population)
        capitalView.isHidden = viewModel.capital == nil
        capitalView.setText(viewModel.capital)
        
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(message: error)
    }
    
    // MARK: - MKMapViewDelegate Delegate
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let countryLocation = viewModel.location {
            mapView.openInMaps(coordinate: countryLocation)
        }
    }
}
