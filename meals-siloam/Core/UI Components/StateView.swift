//
//  StateView.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 22/10/23.
//

import UIKit

public final class StateView: UIView {
    private lazy var backgroundView = StackView{
        activityIndicatorView
        imageView
        titleLabel
        descriptionLabel
    }.customSpacing(4, after: 1)
    private let imageView = ImageView()
    private let titleLabel = MainLabel(textColor: .cocoaBrownColor,
                                       alignment: .center,
                                       font: .systemFont(ofSize: 13,
                                                         weight: .medium))
    private let descriptionLabel = MainLabel(textColor: .cocoaBrownColor,
                                             alignment: .center,
                                             font: .systemFont(ofSize: 10,
                                                               weight: .regular))
    
    private var activityIndicatorView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.style = .medium
        activity.tintColor = .black
        activity.color = .black
        activity.stopAnimating()
        return activity
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        layoutIfNeeded()
    }
    
    public func showState(_ resultState: ResultStateView = .loading, completion: @escaping () -> Void ) {
        isHidden = false
        switch resultState {
        case .loading:
            activityIndicatorView.startAnimating()
            imageView.image = nil
            titleLabel.text = nil
            descriptionLabel.text = nil
            break
            
        case .result(let title, let subtitle):
            activityIndicatorView.stopAnimating()
            
            imageView.image = .dataEmptyIcon
            titleLabel.text = title
            descriptionLabel.text = subtitle
            
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                completion()
            }
            break
        }
    }
    
    deinit {
        print("~ \(description) has been removed from memory")
    }
    
    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if self.window == nil {
            self.alpha = 0
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.alpha = 1
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public enum ResultStateView: Equatable {
    case loading
    case result(title: String,
                subtitle: String)
}
