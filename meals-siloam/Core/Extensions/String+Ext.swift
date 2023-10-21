//
//  String+Ext.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import Foundation

extension String {
    mutating func replaceLastWord() {
        if let range = self.range(of: String(self.suffix(1))) {
            self = self.replacingOccurrences(of: String(self.suffix(1)), with: ".", options: .literal, range: range)
        }
    }
    
    func ingredientAndMeasure(ingredient: String?, measure: String?) -> String {
        guard let ingredient = ingredient, let measure = measure else { return "" }
        if ingredient.trimmingCharacters(in: .whitespaces).isEmpty && measure.trimmingCharacters(in: .whitespaces).isEmpty {
            return ""
        } else {
            return "\(ingredient) - \(measure), "
        }
    }
    
}
