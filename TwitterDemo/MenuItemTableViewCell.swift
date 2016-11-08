//
//  MenuItemTableViewCell.swift
//  TwitterDemo
//
//  Created by Edwin Wong on 11/5/16.
//  Copyright © 2016 edwin. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    var menuItem: MenuItem!{
        didSet{
            name.text = (menuItem?.name) ?? ""
            if let imageName = menuItem?.imageName{
                iconImageView.image = UIImage(named: imageName)
            }
        }
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
