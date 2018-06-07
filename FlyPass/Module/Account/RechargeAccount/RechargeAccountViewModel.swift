//
//  RechargeAccountViewModel.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/22/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit

class RechargeAccountViewModel  {
    fileprivate var accountDetails:[RechargeAccount] = []
    
    func getAccountRechargeDetails(successClosure:@escaping ()->(),errorClosure:@escaping (_ error:Error) ->()) {
        RechargeAccount.getRechargeOptions(endPoint: flypassEndpoint.accountOptions(), successClosure: { (options:[RechargeAccount]) in
            self.accountDetails = options
            successClosure()
        }, errorClosure: {error in
            self.accountDetails.removeAll()
            errorClosure(error)
        })
    }
}
