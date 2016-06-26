//
//  ChannelTableViewCell.swift
//  iTube
//
//  Created by Frezy Stone Mboumba on 6/25/16.
//  Copyright © 2016 Frezy Stone Mboumba. All rights reserved.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {

    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var channeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        channeImageView.layer.cornerRadius = channeImageView.layer.frame.height/2
        channeImageView.clipsToBounds = true
    }

   
}
