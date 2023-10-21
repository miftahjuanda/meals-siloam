//
//  DetailMealsViewController.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUiDetail()
    }
    
    private func setUiDetail() {
        view.backgroundColor = .white
        title = "Detail Info"
        
        let descriptionVStack = StackView {
            DescriptionComponent()
            DescriptionComponent()
            DescriptionComponent()
            DescriptionComponent()
            DescriptionComponent()
            DescriptionComponent()
            DescriptionComponent()
            DescriptionComponent()
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
    
    @objc private func onTapImage(_ gestureRecognizer: UITapGestureRecognizer) {
        let expandVC = ExpanableViewController()
        navigationController?.present(expandVC, animated: true)
    }
}
