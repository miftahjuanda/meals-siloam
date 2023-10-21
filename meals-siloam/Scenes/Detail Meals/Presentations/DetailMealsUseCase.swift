//
//  DetailMealsUseCase.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import Combine
import UIKit

protocol DetailMealsUseCaseProtocol {
    func detailMeals(idMeal: String) -> AnyPublisher<DetailMealsEntity, Error>
    func loadImage(url: String) -> AnyPublisher<UIImage?, Error>
}

internal class DetailMealsUseCase {
    private let httpCLient: HTTPClient
    private let cancellables = CancelBag()
    
    init(networkAPI: HTTPClient = AlamofireHttpClient()) {
        self.httpCLient = networkAPI
    }
}

extension DetailMealsUseCase: DetailMealsUseCaseProtocol {
    func detailMeals(idMeal: String) -> AnyPublisher<DetailMealsEntity, Error> {
        let request = httpCLient.request(url: DetailMealsRequest(idMeal: idMeal))
        
        return request
    }
    
    func loadImage(url: String) -> AnyPublisher<UIImage?, Error> {
        let request = httpCLient.loadImage(from: url)
        return request
    }
}


final class Scheduler {

    static var backgroundWorkScheduler: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 5
        operationQueue.qualityOfService = QualityOfService.userInitiated
        return operationQueue
    }()

    static let mainScheduler = RunLoop.main

}
