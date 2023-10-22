//
//  DetailMealsViewModel.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import UIKit
import Combine

internal final class DetailMealsViewModel: DetailMealsViewModelType {
    private let useCase: DetailMealsUseCaseProtocol
    
    init(useCase: DetailMealsUseCaseProtocol = DetailMealsUseCase()) {
        self.useCase = useCase
    }
    
    func transform(input: DetailMealsViewModelInput) -> DetailMealsViewModelOutput {
        let detailMeal = input.detailMeal
            .filter({ !$0.isEmpty })
            .flatMap{ idMeal in
                self.useCase.detailMeals(idMeal: idMeal)
                    .map{ Result.success($0) }
                    .catch{ Just(Result.failure($0)) }
                    .eraseToAnyPublisher()
            }
            .map({ result -> DetailMealsState in
                switch result {
                case .success(let meals):
                    if let meal = meals.meals.first {
                        return .success(meal)
                    } else {
                        return .noResults
                    }
                case .failure(let error):
                    return .failure(error)
                }
            })
            .eraseToAnyPublisher()
        
        let initialState: DetailMealsViewModelOutput = .just(.loading)
        return Publishers.Merge(initialState, detailMeal).removeDuplicates().eraseToAnyPublisher()
    }
}
