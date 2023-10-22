//
//  View+Ext.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import UIKit
import Combine

extension UIView {
    func tapPublisher() -> AnyPublisher<Void, Never> {
        let tapGestureRecognizer = UITapGestureRecognizer()
        addGestureRecognizer(tapGestureRecognizer)
        isUserInteractionEnabled = true
        
        return tapGestureRecognizer.publisher(for: \.state)
            .compactMap { state in
                state == .recognized ? () : nil
            }
            .eraseToAnyPublisher()
    }
}
