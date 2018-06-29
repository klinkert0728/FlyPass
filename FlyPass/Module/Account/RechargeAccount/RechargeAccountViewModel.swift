//
//  RechargeAccountViewModel.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/22/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit

class RechargeAccountViewModel  {
    var accountDetails:[RechargeAccount] = []
    
    func getAccountRechargeDetails(successClosure:@escaping ()->(),errorClosure:@escaping (_ error:Error) ->()) {
        RechargeAccount.getRechargeOptions(endPoint: flypassEndpoint.accountOptions(), successClosure: { (options:[RechargeAccount]) in
            self.accountDetails = options
            successClosure()
        }, errorClosure: {error in
            self.accountDetails.removeAll()
            errorClosure(error)
        })
    }
    
    func rechargeAccount(amountToRecharege amount:Int,selectedAccount account:RechargeAccount,successClosure:@escaping ()->(),errorClosure:@escaping (_ error:Error) ->()) {
        RechargeAccount.rechargeAccount(endPoint: .rechargeAccount(rechargeAmount: amount, rechargeAccount: account), successClosure: { (rechargedAccount:[RechargeAccount]) in
            print(rechargedAccount)
        }, errorClosure: errorClosure)
        
    }
}
