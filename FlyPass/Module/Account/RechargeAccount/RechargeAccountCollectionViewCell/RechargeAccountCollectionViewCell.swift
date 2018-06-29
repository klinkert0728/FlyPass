//
//  RechargeAccountCollectionViewCell.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 6/29/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit

class RechargeAccountCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var accountNumber: UILabel!
    @IBOutlet weak var accountOwner: UILabel!
    
    
    func setupInfoForAccount(account:RechargeAccount) {
        accountOwner.text   = account.secureUser?.person?.fullname
        accountNumber.text  = accountNumber.text! + " \(account.accountNumber)"
    }
    
}
