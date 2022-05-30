//
//  ViewController.swift
//  Travel App
//
//  Created by Patricia Fiona on 30/05/22.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var viewHomeBanner: UIView!
    @IBOutlet weak var viewSubHomeBanner: UIView!
    @IBOutlet weak var imageUser: UIImageView!
    
    private func setImageCircle(image: UIImageView) {
        image.layer.cornerRadius = image.frame.size.width/2;
        image.clipsToBounds = true;
    }
    
    private func setViewRounded(view: UIView, _ roundPercentage: Double){
        view.layer.cornerRadius = view.frame.size.width * roundPercentage;
        view.clipsToBounds = true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImageCircle(image: self.imageUser);
        setViewRounded(view: self.viewHomeBanner, 0.05);
        setViewRounded(view: self.viewSubHomeBanner, 0.05);
    }


}

