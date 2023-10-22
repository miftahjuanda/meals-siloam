//
//  FindMealsViewModelType.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 22/10/23.
//

import Combine

internal struct FindMealsViewModelInput {
    let appear: AnyPublisher<Void, Never>
    let searchMeals: AnyPublisher<String, Never>
    let selection: AnyPublisher<String, Never>
}

internal enum FindMealsState {
    case idle
    case loading
    case success([Meal])
    case noResults
    case failure(Error)
}

extension FindMealsState: Equatable {
    static func == (lhs: FindMealsState, rhs: FindMealsState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.success(let lhs), .success(let rhs)): return lhs == rhs
        case (.noResults, .noResults): return true
        case (.failure, .failure): return true
        default: return false
        }
    }
}

typealias FindMealsViewModelOutput = AnyPublisher<FindMealsState, Never>

protocol FindMealsViewModelType {
    func transform(input: FindMealsViewModelInput) -> FindMealsViewModelOutput
}
