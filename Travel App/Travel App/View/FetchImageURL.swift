//
//  FetchImageURL.swift
//  Travel ID
//
//  Created by Patricia Fiona on 28/07/21.
//
import UIKit

class FetchImageURL{
    
    init(){}
    
    func setImageToImageView(imageContainer: UIImageView, imageUrl: String) {
        FetchData().fetchImage(from: imageUrl, completionHandler: { (imageData) in
            if let data = imageData {
                // referenced imageView from main thread
                // as iOS SDK warns not to use images from
                // a background thread
                DispatchQueue.main.async {
                    imageContainer.image = UIImage(data: data)
                    Utils().setViewRounded(view: imageContainer, 0.05)
                }
            } else {
                // show as an alert if you want to
                print("Error loading image");
            }
        })
    }
    
}
