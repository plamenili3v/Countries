//
//  CountriesListMasterViewController.swift
//  Countries
//
//  Created by Plamen I. Iliev on 21.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import UIKit

class CountriesListMasterViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate, AlertDisplayer {
    private lazy var tableViewRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshItems), for: .valueChanged)
        return refreshControl
    }()
    
    private(set) var searchController: UISearchController!
    
    var viewModel: CountriesListViewModelProtocol = CountriesListViewModel()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupVM()
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIds.showCountryDetails, let indexPath = tableView.indexPathForSelectedRow {
            let controller = (segue.destination as! UINavigationController).topViewController as! CountryDetailsViewController
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
            
            guard indexPath.row < tableView.numberOfRows(inSection: 0) else {
                return
            }
            
            controller.country = viewModel.countryAtIndex(indexPath.row)
        }
    }
    
    private func navigateToCountryDetails() {
        performSegue(withIdentifier: SegueIds.showCountryDetails, sender: nil)
    }
    
    // MARK: - Setup
    private func setupVM() {
        viewModel.items.observe(on: self) { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        
        viewModel.error.observe(on: self) { self.showError($0) }
    }
    
    private func setupNavigationBar() {
        setupSearchController()
        showActivityIndicatorInNavigationBarTitle()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Title.searchCountryPlaceholder
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
    }
    
    func updateUI() {
        if !viewModel.items.value.isEmpty {
            hideActivityIndicatorInNavigationBarTitle()
        }
        
        tableView.reloadData()
        tableViewRefreshControl.endRefreshing()
        
        if UIDevice.current.userInterfaceIdiom == .pad, tableView.indexPathForSelectedRow == .none {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            tableView.delegate?.tableView!(tableView, didSelectRowAt: indexPath)
        }
    }
    
    func showError(_ error: String) {
        guard !error.isEmpty else { return }
        tableViewRefreshControl.endRefreshing()
        hideActivityIndicatorInNavigationBarTitle()
        showAlert(message: error)
    }
    
    func handleSearchBarInputText(_ searchText: String) {
        viewModel.searchCountry(searchTerm: searchText)
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        handleSearchBarInputText(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar(searchBar, textDidChange: "")
    }
 
    // MARK: - Actions
    @objc func refreshItems() {
        viewModel.didRequestRefreshItems()
    }
}

//MARK: - TableView Methods
extension CountriesListMasterViewController {
    private func setupTableView() {
        tableView.backgroundColor = UIKitConstants.ColorAssets.themeBlue
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.refreshControl = tableViewRefreshControl
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UIKitConstants.CountryTableView.countryCellIdentifier)
        tableView.register(NoResultsTableViewCell.self, forCellReuseIdentifier: UIKitConstants.CountryTableView.noResultsCellIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !viewModel.items.value.isEmpty else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            return isLoading ? 0 : 1
        }
        
        return viewModel.items.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !viewModel.items.value.isEmpty else {
            return tableView.dequeueReusableCell(withIdentifier: UIKitConstants.CountryTableView.noResultsCellIdentifier, for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UIKitConstants.CountryTableView.countryCellIdentifier, for: indexPath)
        let countryViewModel = viewModel.items.value[indexPath.row]
        cell.textLabel?.text = countryViewModel.titleText
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIKitConstants.ColorAssets.federalBlue
        cell.selectedBackgroundView = bgColorView
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToCountryDetails()
    }
}
