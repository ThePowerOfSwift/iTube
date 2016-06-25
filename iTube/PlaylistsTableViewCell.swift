//
//  PlaylistsTableViewCell.swift
//  iTube
//
//  Created by Frezy Stone Mboumba on 6/25/16.
//  Copyright © 2016 Frezy Stone Mboumba. All rights reserved.
//

import UIKit

class PlaylistsTableViewCell: UITableViewCell {

    @IBOutlet weak var playlistImageView: UIImageView!
    
    @IBOutlet weak var numberOfVideos: UILabel!
    
    @IBOutlet weak var playlistTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        playlistImageView.layer.cornerRadius = 10
        playlistImageView.clipsToBounds = true
    }


}
