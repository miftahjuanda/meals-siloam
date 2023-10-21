//
//  FindMealViewItems.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import Foundation

internal enum FindMealViewItems: Hashable {
    case loading
    case emptyData(String)
    case success([Meal])
}
