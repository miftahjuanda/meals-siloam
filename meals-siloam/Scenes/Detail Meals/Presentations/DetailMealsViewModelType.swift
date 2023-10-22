//
//  DetailMealsViewModelType.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 22/10/23.
//

import Combine

internal struct DetailMealsViewModelInput {
    let detailMeal: AnyPublisher<String, Never>
}

internal enum DetailMealsState {
    case idle
    case loading
    case success(DetailMeal)
    case noResults
    case failure(Error)
}

extension DetailMealsState: Equatable {
    static func == (lhs: DetailMealsState, rhs: DetailMealsState) -> Bool {
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

typealias DetailMealsViewModelOutput = AnyPublisher<DetailMealsState, Never>

protocol DetailMealsViewModelType {
    func transform(input: DetailMealsViewModelInput) -> DetailMealsViewModelOutput
}
