//
//  DetailMealsViewController.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import UIKit
import Combine

internal final class DetailMealsViewController: UIViewController {
    private let titleLabel = MainLabel("Teriyaki Chicken",
                                       textColor: .cocoaBrownColor,
                                       font: .systemFont(ofSize: 18,
                                                         weight: .bold))
    private let subTitleLabel = MainLabel("Japanese",
                                          textColor: .abbeyColor,
                                          font: .systemFont(ofSize: 12,
                                                            weight: .medium))
    private lazy var mealImage: UIImageView = {
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(onTapImage))
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        image.image = .dataEmptyIcon
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapRecognizer)
        return image
    }()
    private let category = DescriptionComponent()
    private let ingredients = DescriptionComponent()
    private let instructions = DescriptionComponent()
    
    private var viewModel: DetailMealsViewModel
    private var idMeal: String
    private var cancellables = CancelBag()
    private var eventIdMeal = PassthroughSubject<String, Never>()
    private var eventImage = PassthroughSubject<String, Never>()
    
    init(idMeal: String, viewModel: DetailMealsViewModel = DetailMealsViewModel()) {
        self.viewModel = viewModel
        self.idMeal = idMeal
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUiDetail()
        bindViewModel()
        
        eventIdMeal.send(idMeal)
    }
    
    private func setUiDetail() {
        view.backgroundColor = .white
        title = "Detail Info"
        
        let descriptionVStack = StackView {
            category
            ingredients
            instructions
        }.setSpacing(10)
        
        let mainScroll = ScrollView(contentStack: StackView(){
            titleLabel
            subTitleLabel
            mealImage
            descriptionVStack
        }.setPadding(.init(top: 15, left: 15,
                           bottom: 0, right: 15))
            .customSpacing(2, after: 0)
            .customSpacing(15, after: 1)
            .customSpacing(15, after: 2)
        )
        
        view.addSubview(mainScroll)
        
        NSLayoutConstraint.activate([
            mealImage.heightAnchor.constraint(equalToConstant: view.frame.width/1.7),
            
            mainScroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScroll.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainScroll.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        let input = DetailMealsViewModel.Input(idMeal: eventIdMeal.eraseToAnyPublisher(),
                                               image: eventImage.eraseToAnyPublisher())
        let output = viewModel.transform(input, cancellables)
        
        output.$detailMeals.receive(on: DispatchQueue.main)
            .sink{ [weak self] result in
                guard let self = self else { return }
                
                if let data = result {
                    bindData(data: data)
                }
            }.store(in: cancellables)
        
        output.$image.receive(on: DispatchQueue.main)
            .sink{ [weak self] result in
                guard let self = self else { return }
                
                if let data = result {
                    mealImage.image = data
                }
            }.store(in: cancellables)
    }
    
    private func bindData(data: DetailMeal) {
        eventImage.send(data.mealThumb)
        titleLabel.text = data.nameMeal
        subTitleLabel.text = data.area
        category.setData(title: "Meal category :",
                         description: data.categoryMeal)
        ingredients.setData(title: "Ingredients :",
                            description: data.Ingredient)
        instructions.setData(title: "Instructions :",
                             description: data.instructions)
    }
    
    @objc private func onTapImage(_ gestureRecognizer: UITapGestureRecognizer) {
        let expandVC = ExpanableViewController(image: mealImage.image ?? .dataEmptyIcon)
        navigationController?.present(expandVC, animated: true)
    }
}
