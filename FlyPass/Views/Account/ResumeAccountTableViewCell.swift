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
    @IBOutlet weak var lisencePlate: UILabel?
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
        if movement.lisencePlate.isEmpty {
            lisencePlate?.removeFromSuperview()
        }else {
            if lisencePlate == nil {
                let newLisence = UILabel()
                lisencePlate            = newLisence
                lisencePlate?.translatesAutoresizingMaskIntoConstraints = false
                lisencePlate?.textColor = UIColor.white
                addSubview(newLisence)
                let views               = ["lisence":newLisence,"view":self,"movementDescription":movementDescription]
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[movementDescription]-8-[lisence(==30)]-10-|", options:[], metrics: nil, views: views))
                NSLayoutConstraint(item: newLisence, attribute: .leading, relatedBy: .equal, toItem: movementDescription, attribute: .leading, multiplier: 1, constant: 0).isActive     = true
                NSLayoutConstraint(item: newLisence, attribute: .trailing, relatedBy: .equal, toItem: movementDescription, attribute: .trailing, multiplier: 1, constant: 0).isActive   = true
                
            }
            lisencePlate?.text      = "License Place: " + movement.lisencePlate
        }
        movementDescription.text    = movement.movementDescription + ": \(movement.amount.formatCurrency())"
        movementDate.text           = "Date: " + movement.date.string(custom: "dd MMMM yyyy HH:mm")
    }
    
}
