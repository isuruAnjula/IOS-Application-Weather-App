//
//  NewsTableViewCell.swift
//  Isuru_Patabendi_FE_8922125
//
//  Created by user235715 on 12/9/23.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet var titleCellLable: UILabel!
    @IBOutlet var descriptionCellLable: UILabel!
    @IBOutlet var sourceCellLable: UILabel!
    @IBOutlet var authorCellLable: UILabel!
    
    static let identifier = "NewsTableViewCell"
    
    //call inner view controller
    static func nib() -> UINib {
        return UINib(nibName: "NewsTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //stop highlighting cell
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
