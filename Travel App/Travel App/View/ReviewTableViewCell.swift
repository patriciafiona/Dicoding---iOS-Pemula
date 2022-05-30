//
//  ReviewTableViewCell.swift
//  Travel App
//
//  Created by Patricia Fiona on 30/05/22.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewProfile: UIImageView!
    @IBOutlet weak var reviewTitle: UILabel!
    @IBOutlet weak var reviewUsername: UILabel!
    @IBOutlet weak var reviewDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
