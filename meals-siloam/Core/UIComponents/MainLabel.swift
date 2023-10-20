//
//  MainLabel.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 20/10/23.
//

import UIKit

internal class MainLabel: UILabel {
    
    init(_ text: String = "",
         textColor: UIColor = .abbeyColor,
         alignment: NSTextAlignment = .natural,
         lines: Int = 0,
         font: UIFont = .systemFont(ofSize: 12, weight: .regular)) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.numberOfLines = lines
        self.textColor = textColor
        self.textAlignment = alignment
        self.font = font
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
