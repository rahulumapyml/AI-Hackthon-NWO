//
//  ViewController.swift
//  NewWorldOrder
//
//  Created by Rahul Umap on 01/06/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createGradient()
    }
    
    func createGradient() {
        // Create gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        let color1 = UIColor(red: 70/255, green: 120/255, blue: 230/255, alpha: 1).cgColor
        let color2 = UIColor(red: 58/255, green: 101/255, blue: 229/255, alpha: 1).cgColor
        let color3 = UIColor(red: 20/255, green: 71/255, blue: 211/255, alpha: 1).cgColor
        
        gradientLayer.colors = [color1, color2, color3]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        // Add gradient layer to the view's layer
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

}

