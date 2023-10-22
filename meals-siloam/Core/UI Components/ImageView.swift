//
//  ImageView.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 22/10/23.
//

import UIKit
import Kingfisher

internal final class ImageView: UIImageView {
    private var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .medium
        indicator.tintColor = .cocoaBrownColor
        indicator.stopAnimating()
        return indicator
    }()
    
    init() {
        super.init(frame: .zero)
        
        setImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setImageView() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.masksToBounds = true
        contentMode = .scaleAspectFill
        
        addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func imageWithUrl(with imageURL: String) {
        loadingIndicator.startAnimating()
        guard let url = URL(string: imageURL) else { return }
        kf.setImage(with: url, placeholder: nil, options: nil) { result in
            self.loadingIndicator.stopAnimating()
            switch result {
            case .success(_):
                break
            case .failure(_):
                self.image = .dataEmptyIcon
                break
            }
        }
    }
}
