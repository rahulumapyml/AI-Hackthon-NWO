//
//  OpenAPIManager.swift
//  NewWorldOrder
//
//  Created by Rahul Umap on 01/06/23.
//

import Foundation
import OpenAISwift

final class OpenAPIManager {
    static let shared = OpenAPIManager()
    
    private var client: OpenAISwift?
    
    private init() {}
    
    @frozen private enum Constants {
        static let key = Bundle.main.gptKey
    }
    
    func setup() {
        client = OpenAISwift(authToken: Constants.key)
    }
    
    func getResponse(input: String,
                    completion: @escaping (Result<String, Error>) -> Void) {
        
        guard !input.isEmpty else { return }
        
        client?.sendCompletion(with: input, completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices?.first?.text ?? ""
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        
    }
}
