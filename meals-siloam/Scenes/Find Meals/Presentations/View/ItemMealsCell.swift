//
//  ItemMealsCell.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 20/10/23.
//

import UIKit

internal final class ItemMealsCell: UICollectionViewCell {
    static let id = "ItemMealsCell"
    
    private let image: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        img.layer.cornerRadius = 8
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let titlelabel = MainLabel(textColor: .abbeyColor,
                                       lines: 1,
                                       font: .systemFont(ofSize: 13,
                                                         weight: .bold))
    private let subTitlelabel = MainLabel(textColor: .abbeyColor,
                                          lines: 1,
                                          font: .systemFont(ofSize: 12,
                                                            weight: .regular))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setuiCell()
        
        setData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData() {
        image.image = .dataEmptyIcon
        titlelabel.text = "titlelabel.text"
        subTitlelabel.text = "subTitlelabel.text"
    }
    
    private func setuiCell() {
        clipsToBounds = true
        contentView.backgroundColor = .merinoColor
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        contentView.layer.cornerRadius = 22
        
        titlelabel.lineBreakMode = .byWordWrapping
        subTitlelabel.lineBreakMode = .byWordWrapping
        
        let mainStack = StackView {
            image
            titlelabel
            subTitlelabel
        }.setPadding(.init(top: 8, left: 8,
                           bottom: 8, right: 8))
        
        contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            titlelabel.heightAnchor.constraint(equalToConstant: 16),
            subTitlelabel.heightAnchor.constraint(equalToConstant: 15),
            
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        mainStack.setCustomSpacing(8, after: mainStack.subviews[0])
        mainStack.setCustomSpacing(1, after: mainStack.subviews[1])
        
        layoutIfNeeded()
    }
}
