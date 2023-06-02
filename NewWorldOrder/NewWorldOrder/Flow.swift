//
//  Flow.swift
//  NewWorldOrder
//
//  Created by Rahul Umap on 02/06/23.
//

import Foundation

enum Flow {
    case normal
    case predictiveAnalysis
    case decisionMaking
    
    func getInitialDialog(_ userName: String) -> String {
        switch self {
        case .normal, .decisionMaking:
            return "Hello \(userName), how can I help you?"
        case .predictiveAnalysis:
            return "Hello \(userName), you were asked to observe the chest pain in last visit - how are you feeling?"
        }
    }
    
}
