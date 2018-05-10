//
//  LoginViewController.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/8/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: BaseViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var successLogin:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInAction(_ sender: Any) {
        guard let documentIdText = emailField.text, let currentPassword = passwordField.text, !documentIdText.isEmpty && !currentPassword.isEmpty else {
            SVProgressHUD.showInfo(withStatus: "")
            return
        }
        signIn(userId: documentIdText, userPassword: currentPassword)
    }
    
    fileprivate func signIn(userId:String,userPassword:String) {
        SVProgressHUD.show()
        User.authenticateUser(documentId: userId, password: userPassword, successCallback: {
            SVProgressHUD.dismiss()
            self.successLogin?()
        }, errorCallback: { error in
            SVProgressHUD.dismiss()
            SVProgressHUD.showInfo(withStatus: error.localizedDescription)
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
