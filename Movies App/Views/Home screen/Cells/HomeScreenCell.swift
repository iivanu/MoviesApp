//
//  HomeScreenCell.swift
//  Movies App
//
//  Created by Ivan Ivanušić on 17.10.2022..
//

import UIKit

class HomeScreenCell: UITableViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
