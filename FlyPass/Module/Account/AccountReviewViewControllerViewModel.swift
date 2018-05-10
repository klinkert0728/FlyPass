//
//  AccountReviewViewControllerViewModel.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/10/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation
import SVProgressHUD
import RealmSwift

protocol AccountReviewViewModel {
    var movements:[UserMovements] { get }
    var user:User? {get}
}

class AccountReviewViewControllerViewModel:AccountReviewViewModel {
    
    var reloadTableViewClosure: (()->())?
    var reloadUserInfoView:(()->())?
    
    var movements: [UserMovements] = [] {
        didSet {
            reloadTableViewClosure?()
        }
    }
    var user: User? {
        didSet {
            reloadUserInfoView?()
        }
    }
    
    
    func fetchUserMovements() {
        SVProgressHUD.show()
        UserMovements.getUserMovements(successCallback: { (userMovements:[UserMovements]) in
           self.movements = userMovements
            SVProgressHUD.dismiss()
        }, errorCallback: { (error) in
            SVProgressHUD.dismiss()
            SVProgressHUD.show(withStatus: error.localizedDescription)
        })
    }
    
    func fetchUserInformation() {
        if !User.isLoggedIn {
            return
        }
        SVProgressHUD.show()
        User.getUserInformation(successCallback: { (currentUser) in
            self.user = currentUser
            SVProgressHUD.dismiss()
        }, errorCallback: { error in
            SVProgressHUD.dismiss()
            SVProgressHUD.show(withStatus: error.localizedDescription)
        })
    }
}
