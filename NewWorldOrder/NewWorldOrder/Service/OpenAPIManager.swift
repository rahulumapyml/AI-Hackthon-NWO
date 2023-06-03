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
    
    func setup() {
        // Don't commit API key
        client = OpenAISwift(authToken: "")
    }
    
    func getResponse(input: String,
                    completion: @escaping (Result<String, Error>) -> Void) {
        
        guard !input.isEmpty else { return }
        
        client?.sendCompletion(with: input, maxTokens: 500, completionHandler: { result in
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
