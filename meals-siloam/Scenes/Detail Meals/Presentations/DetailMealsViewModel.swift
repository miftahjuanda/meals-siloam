//
//  DetailMealsViewModel.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import Foundation
import Combine

internal final class DetailMealsViewModel {
    private let useCase: DetailMealsUseCaseProtocol
    
    init(useCase: DetailMealsUseCaseProtocol = DetailMealsUseCase()) {
        self.useCase = useCase
    }
    
    internal struct Input {
        let idMeal: AnyPublisher<String, Never>
    }
    
    internal class Output: ObservableObject {
        @Published var detailMeals: DetailMeal? // = DetailMeal()
        @Published var resultError: Error?
    }
    
    func transform(_ input: Input, _ cancellables: CancelBag) -> Output {
        let output = Output()
        
        input.idMeal
            .receive(on: DispatchQueue.global())
            .flatMap{ id in
                self.useCase.detailMeals(idMeal: id)
                    .map{ Result.success($0) }
                    .catch{ Just(Result.failure($0)) }
                    .eraseToAnyPublisher()
            }.sink(receiveValue: { result in
                switch result {
                case .success(let meals):
//                    if let data = meals.meals.first {
                    output.detailMeals = meals.meals.first
//                    }
                    break
                case .failure(let err):
                    output.resultError = err
                    break
                }
            }).store(in: cancellables)
        
        return output
    }
    
}