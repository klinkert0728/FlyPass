//
//  ResumeAccountView.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/8/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit

class ResumeAccountView: UIView {

    
    @IBOutlet weak var fullname:UILabel!
    @IBOutlet weak var docuemntId:UILabel!
    @IBOutlet weak var averageConsum:UILabel!
    @IBOutlet weak var amountAvailable:UILabel!
    @IBOutlet weak var amountIndicator:UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func configureView(user:User) {
        guard let person = user.person else {
            return
        }
        fullname.text           = person.fullname
        docuemntId.text         = person.documentId
        averageConsum.text      = "Average: " + "\(user.monthlyAverageConsumption.formatCurrency())"
        amountAvailable.text    = "Available: " + "\(user.availableAmount.formatCurrency())"
        configureIndicatorBasedOnLowAmount(lowIndicator: user.limitAmountLow,amoutAvailable: user.availableAmount)
    }
    
    fileprivate func configureIndicatorBasedOnLowAmount(lowIndicator:Double,amoutAvailable:Double) {
        if amoutAvailable < lowIndicator {
            if amoutAvailable < 11000 {
                amountIndicator.backgroundColor = UIColor.red
            }else {
                amountIndicator.backgroundColor = UIColor.yellow
            }
        }else {
            amountIndicator.backgroundColor = UIColor.green
        }
    }

}
