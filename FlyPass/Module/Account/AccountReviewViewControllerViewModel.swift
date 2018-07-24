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
import ReachabilitySwift

protocol AccountReviewViewModel {
    var movements:[UserMovements] { get }
    var user:User? {get}
}

class AccountReviewViewControllerViewModel:AccountReviewViewModel {
    
    var reloadUserInfoView:(()->())?
    
    var movements: [UserMovements] = [] 
    var user: User? {
        didSet {
            reloadUserInfoView?()
        }
    }
    
    var shouldDownload      = true
    var movementPage        = 1
    
    func fetchUserMovements(successClosure:@escaping ()->(),errorClosure:@escaping (_ error:Error)->()) {
        if !User.isLoggedIn {
            successClosure()
            return
        }
        shouldDownload = false
        UserMovements.getUserMovements(page:movementPage, successCallback: { (userMovements:[UserMovements]) in
            self.movements.append(contentsOf: userMovements)
            self.shouldDownload      = userMovements.count != 0
            successClosure()
        }, errorCallback: errorClosure)
    }
    
    func fetchUserInformation(completitionHandler:@escaping (_ error:Error?)->()) {
        if !User.isLoggedIn {
            return
        }
        
        User.getUserInformation { (user, error) in
            guard let error = error else {
                self.user = user
                completitionHandler(nil)
                return
            }
            self.user = user
            completitionHandler(error)
        }
    }
}
