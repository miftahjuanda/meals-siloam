//
//  FindMealsViewController.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 20/10/23.
//

import UIKit

internal final class FindMealsViewController: UIViewController {
    private let qouteLabel = MainLabel("Good food, great life.",
                                       textColor: .cocoaBrownColor,
                                       font: .systemFont(ofSize: 16,
                                                         weight: .medium))
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.layer.masksToBounds = true
        search.isTranslucent = false
        search.barTintColor = .merinoColor
        search.tintColor = .abbeyColor
        search.layer.cornerRadius = 12
        search.searchBarStyle = .minimal
        search.placeholder = "Search"
        search.backgroundColor = .merinoColor
        search.setImage(UIImage(systemName: "magnifyingglass"),
                        for: .search, state: .normal)
        search.delegate = self
        search.sizeToFit()
        return search
    }()
    
    private lazy var mealsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.width/2) - 12,
                                 height: view.frame.width/1.6)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 7
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(ItemMealsCell.self,
                                forCellWithReuseIdentifier: ItemMealsCell.id)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var isSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIFindMeals()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setUIFindMeals() {
        view.backgroundColor = .white
        title = " "
        
        let mainVStack = StackView {
            qouteLabel
            searchBar
        }.setSpacing(4)
        
        view.addSubview(mainVStack)
        
        view.addSubview(mealsCollectionView)
        
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: 5),
            mainVStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                constant: 15),
            mainVStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -15),
            
            mealsCollectionView.topAnchor.constraint(equalTo: mainVStack.bottomAnchor,
                                                     constant: 7),
            mealsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                         constant: 7),
            mealsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                          constant: -7),
            mealsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension FindMealsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemMealsCell.id,
                                                         for: indexPath) as? ItemMealsCell {
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension FindMealsViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
