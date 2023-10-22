//
//  FindMealsViewModel.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import Foundation
import Combine

internal final class FindMealsViewModel: FindMealsViewModelType {
    private let useCase: FindMealsUseCaseProtocol
    private var cancellables = CancelBag()
    
    init(useCase: FindMealsUseCaseProtocol = FindMealsUseCase()) {
        self.useCase = useCase
    }
    
    func transform(input: FindMealsViewModelInput) -> FindMealsViewModelOutput {
        let search = input.searchMeals
            .filter({ !$0.isEmpty })
            .flatMap{ keyword in
                self.useCase.searchMeals(keyword: keyword)
                    .map{ Result.success($0) }
                    .catch{ Just(Result.failure($0)) }
                    .eraseToAnyPublisher()
            }
            .map({ result -> FindMealsState in
                switch result {
                case .success(let meals):
                    if meals.meals.isEmpty {
                        return .noResults
                    } else {
                        return .success(meals.meals)
                    }
                case .failure(let error):
                    return .failure(error)
                }
            })
            .eraseToAnyPublisher()
        
        let initialState: FindMealsViewModelOutput = .just(.idle)
        return Publishers.Merge(initialState, search).removeDuplicates().eraseToAnyPublisher()
    }
}
