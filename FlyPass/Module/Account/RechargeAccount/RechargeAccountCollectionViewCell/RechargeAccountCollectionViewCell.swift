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
    @IBOutlet weak var selectedImage: UIImageView!
    
    
    func setupInfoForAccount(account:RechargeAccount,selected:Bool) {
        accountOwner.text       = account.secureUser?.person?.fullname
        accountNumber.text      = accountNumber.text! + " \(account.accountNumber)"
        selectedImage.isHidden  = !selected
        selectedImage.image     = UIImage(named: "login")
    }
    
}
