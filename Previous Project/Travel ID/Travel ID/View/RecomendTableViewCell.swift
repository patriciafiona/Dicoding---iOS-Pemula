//
//  RecomendTableViewCell.swift
//  Travel ID
//
//  Created by Patricia Fiona on 02/08/21.
//

import UIKit

class RecomendTableViewCell: UITableViewCell {

    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeLike: UILabel!
    @IBOutlet weak var placeDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
