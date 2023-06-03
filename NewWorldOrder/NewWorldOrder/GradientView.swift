//
//  GradientView.swift
//  NewWorldOrder
//
//  Created by Pavan Itagi on 02/06/23.
//

import Foundation
import UIKit

class GradientView: UIView {
    private var gradientLayer: CAGradientLayer!
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradientLayer()
    }
    
    private func setupGradientLayer() {
        gradientLayer = self.layer as? CAGradientLayer
        gradientLayer.colors = [UIColor(red: 87/255, green: 124/255, blue: 1, alpha: 0.7).cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 1.0]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
