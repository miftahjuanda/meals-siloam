//
//  FindMealsViewController.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 20/10/23.
//

import UIKit
import Combine

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
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var dataSource = UICollectionViewDiffableDataSource<String, Meal>(collectionView: mealsCollectionView) { [weak self] (collectionView, indexPath, value) -> UICollectionViewCell? in
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: ItemMealsCell.id,
                                                       for: indexPath) as? ItemMealsCell)!
        cell.addTapGesture { [weak self] in
            guard let self = self else { return }
            let detailVC = DetailMealsViewController()
            detailVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        cell.setData(value)
        return cell
    }
    
    private var cancellables = CancelBag()
    private var searchMeals = PassthroughSubject<String, Never>()
    private var isSearch = false
    private var viewModel: FindMealsViewModel
    
    init(viewModel: FindMealsViewModel = FindMealsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIFindMeals()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
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
    
    private func bindViewModel() {
        let input = FindMealsViewModel.Input(searchMeals: searchMeals.eraseToAnyPublisher())
        let output = viewModel.transform(input, cancellables)
        
        output.$resultMeals.receive(on: DispatchQueue.main)
            .sink{ [weak self] result in
                guard let self = self else { return }
                
                if !result.isEmpty {
                    self.applySnapshot(items: result)
                }
            }.store(in: cancellables)
    }
    
    private func applySnapshot(items: [Meal], animatingDifferences: Bool = true) {
        var snapshot: NSDiffableDataSourceSnapshot<String, Meal> = .init()
        snapshot.appendSections([""])
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension FindMealsViewController: UISearchBarDelegate{
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            searchMeals.send(searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
