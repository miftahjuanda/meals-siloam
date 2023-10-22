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
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var dataSource = UICollectionViewDiffableDataSource<String, Meal>(collectionView: mealsCollectionView) { [weak self] (collectionView, indexPath, value) -> UICollectionViewCell? in
        guard let self = self else { return UICollectionViewCell() }
        
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: ItemMealsCell.id,
                                                       for: indexPath) as? ItemMealsCell)!
        cell.image.tapPublisher()
            .sink { [weak self] _ in
                let expandVC = ExpanableViewController(imageUrl: value.mealThumb)
                self?.navigationController?.present(expandVC, animated: true)
            }
            .store(in: self.cancellables)
        cell.setData(value)
        return cell
    }
    private var stateView = StateView()
    
    private var cancellables = CancelBag()
    private var searchMeals = PassthroughSubject<String, Never>()
    private let selection = PassthroughSubject<String, Never>()
    private let appear = PassthroughSubject<Void, Never>()
    private var isSearch = false
    private var viewModel: FindMealsViewModelType
    
    init(viewModel: FindMealsViewModelType = FindMealsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIFindMeals()
        bind(to: viewModel)
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
        view.addSubview(stateView)
        
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
            mealsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stateView.topAnchor.constraint(equalTo: mealsCollectionView.topAnchor),
            stateView.leadingAnchor.constraint(equalTo: mealsCollectionView.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: mealsCollectionView.trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: mealsCollectionView.bottomAnchor)
        ])
    }
    
    private func bind(to viewModel: FindMealsViewModelType) {
        let input = FindMealsViewModelInput(appear: appear.eraseToAnyPublisher(),
                                            searchMeals: searchMeals.eraseToAnyPublisher(),
                                            selection: selection.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        
        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: cancellables)
    }
    
    private func render(_ state: FindMealsState) {
        stateView.isHidden = false
        view.endEditing(true)
        switch state {
        case .idle:
            stateView.showState(.result(title: "No data available.",
                                        subtitle: "")) { }
            applySnapshot(items: [])
            break
        case .loading:
            stateView.showState(.loading) { }
            applySnapshot(items: [])
            break
        case .noResults:
            stateView.showState(.result(title: "No data available.",
                                        subtitle: "")) { }
            applySnapshot(items: [])
            break
        case .failure(let error):
            stateView.showState(.result(title: "No data available.",
                                        subtitle: error.localizedDescription)) { }
            applySnapshot(items: [])
            break
        case .success(let meals):
            stateView.isHidden = true
            applySnapshot(items: meals)
            break
        }
    }
    
    private func applySnapshot(items: [Meal], animatingDifferences: Bool = true) {
        var snapshot: NSDiffableDataSourceSnapshot<String, Meal> = .init()
        snapshot.appendSections([""])
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension FindMealsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot().itemIdentifiers[indexPath.row]
        
        let detailVC = DetailMealsViewController(idMeal: snapshot.idMeal)
        detailVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension FindMealsViewController: UISearchBarDelegate{
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            stateView.showState(.loading) { }
            applySnapshot(items: [])
            
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
