//
//  SessionClientResult.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import Combine

internal enum SessionClientResult<T> {
    case success(T)
    case failure(Error)
}

internal extension SessionClientResult {
    var asPublisher: AnyPublisher<T, Error> {
        Future { resolve in
            switch self {
            case .success(let data):
                resolve(.success(data))
            case .failure(let error):
                resolve(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
