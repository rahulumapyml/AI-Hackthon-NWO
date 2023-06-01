//
//  UIImageView+Extension.swift
//  NewWorldOrder
//
//  Created by Madan AR on 01/06/23.
//

import UIKit

extension UIImageView {
    static func fromGif(frame: CGRect, resourceName: String) -> [UIImage] {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else {
            return []
        }
        
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
              let source =  CGImageSourceCreateWithData(gifData as CFData, nil)
        else {
            return []
        }
        
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        
        return images
    }
}
