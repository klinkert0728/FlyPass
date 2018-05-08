//
//  ResumeAccountTableViewCell.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/8/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit
import SwiftDate

class ResumeAccountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movementDate: UILabel!
    @IBOutlet weak var lisencePlate: UILabel!
    @IBOutlet weak var movementDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureMovementCell(movement:UserMovements) {
        lisencePlate.text           = "License Place: " + movement.lisencePlate
        movementDescription.text    = movement.movementDescription + ": \(movement.amount.formatCurrency())"
        movementDate.text           = movement.date.string(custom: "dd/MM/yyyy HH:mm")
    }

}
