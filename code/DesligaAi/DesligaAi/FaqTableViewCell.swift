//
//  FaqTableViewCell.swift
//  DesligaAi
//
//  Created by Miriane Silva on 01/05/2019.
//  Copyright © 2019 desligaAi. All rights reserved.
//

import UIKit

class FaqTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var firsFaqLabel: UILabel!
    @IBOutlet weak var secondFaqLabel: UILabel!
    @IBOutlet weak var thirdFaqLabel: UILabel!
    @IBOutlet weak var fourthFaqLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
