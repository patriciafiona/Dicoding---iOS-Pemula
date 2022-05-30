//
//  AboutViewController.swift
//  Travel ID
//
//  Created by Patricia Fiona on 02/08/21.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setProfileRounded()
    }
    
    private func setProfileRounded(){
        profilePicture.layer.cornerRadius = profilePicture.frame.height / 2
        profilePicture.clipsToBounds = true
    }

}
