//
//  HistoryNewsTableViewCell.swift
//  Isuru_Patabendi_FE_8922125
//
//  Created by user235715 on 12/11/23.
//

import UIKit

class HistoryNewsTableViewCell: UITableViewCell {

    @IBOutlet var HNScreen: UILabel!
    @IBOutlet var HNCity: UILabel!
    @IBOutlet var HNFrom: UILabel!
    @IBOutlet var HNTitle: UILabel!
    @IBOutlet var HNDescription: UILabel!
    @IBOutlet var HNSource: UILabel!
    @IBOutlet var HNAuthor: UILabel!
    
    static let identifier = "HistoryNewsTableViewCell"
    
    //call inner view controller
    static func nib() -> UINib {
        return UINib(nibName: "HistoryNewsTableViewCell", bundle: nil)
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
