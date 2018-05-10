//
//  LoginViewModel.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/10/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation
import SVProgressHUD

class LoginViewModel {
    
    func signIn(userId:String,userPassword:String,successClosure:(()->())?) {
        SVProgressHUD.show()
        User.authenticateUser(documentId: userId, password: userPassword, successCallback: {
            SVProgressHUD.dismiss()
            successClosure?()
        }, errorCallback: { error in
            SVProgressHUD.dismiss()
            SVProgressHUD.showInfo(withStatus: error.localizedDescription)
        })
    }
}
