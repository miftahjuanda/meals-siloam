//
//  FindMealsViewModel.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import Foundation
import Combine

internal final class FindMealsViewModel {
    private let useCase: FindMealsUseCaseProtocol
    
    
    init(useCase: FindMealsUseCaseProtocol = FindMealsUseCase()) {
        self.useCase = useCase
    }
    
    internal struct Input {
        let searchMeals: AnyPublisher<String, Never>
    }
    
    internal class Output: ObservableObject {
        @Published var resultMeals: [Meal] = []
        @Published var resultError: Error?
    }
    
    func transform(_ input: Input, _ cancellables: CancelBag) -> Output {
        let output = Output()
        
        input.searchMeals
            .receive(on: DispatchQueue.global())
            .flatMap{ keyword in
                self.useCase.searchMeals(keyword: keyword)
                    .map{ Result.success($0) }
                    .catch{ Just(Result.failure($0)) }
                    .eraseToAnyPublisher()
            }.sink(receiveValue: { result in
                switch result {
                case .success(let meals):
                    output.resultMeals = meals.meals
                    break
                case .failure(let err):
                    output.resultError = err
                    break
                }
            }).store(in: cancellables)
        
        return output
    }
}
