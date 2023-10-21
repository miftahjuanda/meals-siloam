//
//  ScrollView.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import UIKit

internal protocol ScrollModifier {
    func addArrangedView(@StackBuilder views: () -> [UIView])
}

internal final class ScrollView: UIScrollView {
    private var contentStack: UIStackView
    
    internal init(contentStack: StackView = StackView(.vertical) { }) {
        self.contentStack = contentStack
        super.init(frame: .zero)
        layoutItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutItem() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentStack)
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: widthAnchor)
        ])
        
        self.layoutIfNeeded()
    }
}

extension ScrollView: ScrollModifier {
    func addArrangedView(@StackBuilder views: () -> [UIView]) {
        views().forEach{ contentStack.addArrangedSubview($0) }
    }
}
