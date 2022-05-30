//
//  Utils.swift
//  Travel App
//
//  Created by Patricia Fiona on 30/05/22.
//
import UIKit

class Utils{
    func setImageCircle(image: UIImageView) {
        image.layer.cornerRadius = image.frame.size.width/2
        image.clipsToBounds = true
    }
    
    func setViewRounded(view: UIView, _ roundPercentage: Double){
        view.layer.cornerRadius = view.frame.size.width * roundPercentage
        view.clipsToBounds = true
    }
    
    func setViewRoundedShadow(_ view: UIView, _ roundPercentage: Double){
        // corner radius
        view.layer.cornerRadius = view.frame.size.width * roundPercentage

        // shadow
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 4.0
        
        view.clipsToBounds = false
        view.layer.masksToBounds = false
    }
}
