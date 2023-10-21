//
//  DescriptionComponent.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import UIKit

internal class DescriptionComponent: UIView {
    private let titleLabel = MainLabel("Ingredients :",
                                       textColor: .cocoaBrownColor,
                                       font: .systemFont(ofSize: 14,
                                                         weight: .medium))
    private let descriptionLabel = MainLabel("Soy sauce 3/4 cup, water 1/2 cup, soy sauce 3/4 cup, water 1/2 cup, Soy sauce 3/4 cup, water 1, soy sauce 3/4 cup, water 1/2 cup, soy sauce 3/4 cup, water 1/2 cup, Soy sauce 3/4 cup, water 1.",
                                             textColor: .cocoaBrownColor,
                                             font: .systemFont(ofSize: 12,
                                                               weight: .regular))
    
    init() {
        super.init(frame: .zero)
        
        setUIDescription()
    }
    
    private func setUIDescription() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .merinoColor
        layer.cornerRadius = 6
        
        let mainVStack = StackView {
            titleLabel
            descriptionLabel
        }.setPadding(.init(top: 5, left: 8, bottom: 12, right: 8))
        
        addSubview(mainVStack)
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: topAnchor),
            mainVStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainVStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainVStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
