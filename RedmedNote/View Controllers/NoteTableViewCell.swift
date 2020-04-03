//
//  RedmedNoteTableViewCell.swift
//  RedmedNote
//
//  Created by rezo on 4/4/20.
//  Copyright © 2020 Rezo Joglidze. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageViewCell: UIImageView!
    
    @IBOutlet weak var subTitleLabelCell: UILabel!
    @IBOutlet weak var titleLabelCell: UILabel!
    
    
//    @IBOutlet weak var imageViewCell: UIImageView!
//    @IBOutlet weak var titleLabelCell: UILabel!
//    @IBOutlet weak var subTitleLabelCell: UILabel!
//
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
