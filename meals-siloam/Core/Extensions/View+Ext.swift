//
//  View+Ext.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import UIKit

extension UIView {
    public func addTapGesture(action : @escaping ()->Void ){
        let tap = TapGesture(target: self , action: #selector(self.handleTap(_:)))
        tap.action = action
        tap.numberOfTapsRequired = 1
        
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: TapGesture) {
        sender.action!()
    }
}

internal final class TapGesture: UITapGestureRecognizer {
    var action : (()->Void)? = nil
}
