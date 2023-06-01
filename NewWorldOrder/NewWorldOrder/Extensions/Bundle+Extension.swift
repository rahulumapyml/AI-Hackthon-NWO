//
//  Bundle+Extension.swift
//  NewWorldOrder
//
//  Created by Rahul Umap on 01/06/23.
//

import Foundation

extension Bundle {
    var gptKey: String {
        infoDictionary?["GPT Key"] as? String ?? ""
    }
}
