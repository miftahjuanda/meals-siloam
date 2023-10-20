//
//  StackView.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 20/10/23.
//

import UIKit

internal protocol StackModifier {
    associatedtype Stack: UIStackView
    
    func setAlignment(_ alignment: UIStackView.Alignment) -> Stack
    func setDistribution(_ distribution: UIStackView.Distribution) -> Stack
    func setSpacing(_ spacing: CGFloat) -> Stack
    func setPadding(_ padding: UIEdgeInsets) -> Stack
}

@resultBuilder
internal struct StackBuilder {
    public static func buildBlock(_ views: UIView...) -> [UIView] {
        views
    }
}

internal final class StackView: UIStackView {
    internal init(_ axisType: NSLayoutConstraint.Axis = .vertical,
                @StackBuilder views: () -> [UIView]) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = axisType
        views().forEach{ addArrangedSubview($0) }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StackView: StackModifier {
    func setAlignment(_ alignment: UIStackView.Alignment) -> StackView {
        self.alignment = alignment
        return self
    }
    
    func setDistribution(_ distribution: UIStackView.Distribution) -> StackView {
        self.distribution = distribution
        return self
    }
    
    func setSpacing(_ spacing: CGFloat) -> StackView {
        self.spacing = spacing
        return self
    }
    
    func setPadding(_ padding: UIEdgeInsets) -> StackView {
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = padding
        
        return self
    }
}
