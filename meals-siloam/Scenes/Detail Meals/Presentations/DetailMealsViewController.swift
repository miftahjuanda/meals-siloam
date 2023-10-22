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
    private lazy var mealImage: ImageView = {
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(onTapImage))
        let image = ImageView()
        image.layer.cornerRadius = 8
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapRecognizer)
        return image
    }()
    private let category = DescriptionComponent()
    private let ingredients = DescriptionComponent()
    private let instructions = DescriptionComponent()
    private var stateView = StateView()
    
    private var viewModel: DetailMealsViewModelType
    private var idMeal: String
    private var urlThumb: String = ""
    private var cancellables = CancelBag()
    private var eventIdMeal = PassthroughSubject<String, Never>()
    
    init(idMeal: String, viewModel: DetailMealsViewModelType = DetailMealsViewModel()) {
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
        bind(to: viewModel)
        
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
        
        stateView.backgroundColor = .white
        view.addSubview(stateView)
        
        NSLayoutConstraint.activate([
            mealImage.heightAnchor.constraint(equalToConstant: view.frame.width/1.7),
            
            mainScroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScroll.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainScroll.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stateView.topAnchor.constraint(equalTo: mainScroll.topAnchor),
            stateView.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: mainScroll.trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: mainScroll.bottomAnchor)
        ])
    }
    
    private func bind(to viewModel: DetailMealsViewModelType) {
        stateView.showState(.loading) { }
        
        let input = DetailMealsViewModelInput(detailMeal: eventIdMeal.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        
        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: cancellables)
    }
    
    private func render(_ state: DetailMealsState) {
        stateView.isHidden = false
        switch state {
        case .idle:
            stateView.showState(.result(title: "No data available.",
                                        subtitle: "")) { }
            bindData(data: DetailMeal())
            break
        case .loading:
            stateView.showState(.loading) { }
            bindData(data: DetailMeal())
            break
        case .noResults:
            stateView.showState(.result(title: "No data available.",
                                        subtitle: "")) { }
            bindData(data: DetailMeal())
            break
        case .failure(let error):
            stateView.showState(.result(title: "No data available.",
                                        subtitle: error.localizedDescription)) { }
            bindData(data: DetailMeal())
            break
        case .success(let meal):
            stateView.isHidden = true
            bindData(data: meal)
            break
        }
    }
    
    private func bindData(data: DetailMeal) {
        urlThumb = data.mealThumb
        mealImage.imageWithUrl(with: data.mealThumb)
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
        let expandVC = ExpanableViewController(imageUrl: urlThumb)
        navigationController?.present(expandVC, animated: true)
    }
}
