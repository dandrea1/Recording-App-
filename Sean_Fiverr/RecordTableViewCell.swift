//
//  RecordTableViewCell.swift
//  Sean_Fiverr
//
//  Created by Dana Andrea on 9/10/19.
//  Copyright © 2019 Dana Andrea. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var recordingLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
