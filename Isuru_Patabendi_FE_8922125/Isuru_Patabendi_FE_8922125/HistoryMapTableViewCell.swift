//
//  HistoryMapTableViewCell.swift
//  Isuru_Patabendi_FE_8922125
//
//  Created by user235715 on 12/11/23.
//

import UIKit

class HistoryMapTableViewCell: UITableViewCell {

    @IBOutlet var HMScreen: UILabel!
    @IBOutlet var HMCity: UILabel!
    @IBOutlet var HMFrom: UILabel!
    @IBOutlet var HMStart: UILabel!
    @IBOutlet var HMEnd: UILabel!
    @IBOutlet var HMMethod: UILabel!
    @IBOutlet var HMDistance: UILabel!
    
    static let identifier = "HistoryMapTableViewCell"
    
    //call inner view controller
    static func nib() -> UINib {
        return UINib(nibName: "HistoryMapTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
