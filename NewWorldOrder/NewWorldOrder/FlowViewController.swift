//
//  FlowViewController.swift
//  NewWorldOrder
//
//  Created by Rahul Umap on 02/06/23.
//

import UIKit

class FlowViewController: UIViewController {
    
    @IBOutlet weak var assistentButton: UIButton!
    override func viewDidLoad() {
        assistentButton.layer.cornerRadius = assistentButton.frame.height / 2
    }
    
    @IBAction func assistentButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
        self.present(viewController, animated: true)
    }
    
}
