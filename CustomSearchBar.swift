//
//  CustomSearchBarView.swift
//  rn-pdf-genie
//
//  Created by Michel Gutner on 11/06/24.
//

import UIKit

class CustomSearchBarView: UIView {
    let searchController: UISearchController
    let leftButton: UIButton
    let rightButton: UIButton
    
    override init(frame: CGRect) {
        searchController = UISearchController(searchResultsController: nil)
        leftButton = UIButton(type: .system)
        rightButton = UIButton(type: .system)
        
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // Configure searchController
        searchController.searchBar.placeholder = "Search"
        
        // Configure leftButton
        leftButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        
        // Configure rightButton
        rightButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        
        // Add search bar to the view
        addSubview(searchController.searchBar)
    }
    
    private func setupConstraints() {
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        // Define constraints
        NSLayoutConstraint.activate([
            // SearchBar constraints
            searchController.searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            searchController.searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            searchController.searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchController.searchBar.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func leftButtonTapped() {
        // Handle left button tap action
    }
    
    @objc private func rightButtonTapped() {
        // Handle right button tap action
    }
}
