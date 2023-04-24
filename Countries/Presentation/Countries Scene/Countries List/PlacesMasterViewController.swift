//
//  PlacesMasterViewController.swift
//  MobileTask
//
//  Created by Plamen I. Iliev on 23.08.20.
//  Copyright © 2020 Plamen I. Iliev. All rights reserved.
//

import UIKit

class PlacesListMasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil

    var viewModel: PlacesListViewModel!

    lazy var tableViewRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(fetchNearbyPlaces), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        setupTableView()
        setupVM()
        fetchNearbyPlaces()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIds.kShowPlaceDetails {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = viewModel.places[indexPath.row].placeId
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
    }
    
    private func setupVM() {
        viewModel = PlacesListViewModel()
        
        viewModel.updateUI = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableViewRefreshControl.endRefreshing()
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
    
    private func navigateToPlaceDetails(placeId: String) {
        performSegue(withIdentifier: SegueIds.kShowPlaceDetails, sender: nil)
    }
    
    // MARK: - Actions
    @objc private func fetchNearbyPlaces() {
        viewModel?.fetchNearbyPlaces()
    }
}

//MARK: - TableView Methods
extension PlacesListMasterViewController {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.refreshControl = tableViewRefreshControl
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UIKitConstants.PlaceTableView.kCellIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UIKitConstants.PlaceTableView.kCellIdentifier, for: indexPath)
        let placeText = viewModel.placeTextAt(indexPath.row)
        cell.textLabel?.text = placeText
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToPlaceDetails(placeId: viewModel.places[indexPath.row].placeId)
    }
}

