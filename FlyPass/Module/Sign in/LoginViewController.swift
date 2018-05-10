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
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.moveKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.moveKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object:nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide,object:nil)
    }
    
    override func configureAppearance() {
        emailField.delegate     = self
        passwordField.delegate  = self
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
    
    
    @objc func moveKeyboard(notification:NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        if notification.name == NSNotification.Name.UIKeyboardWillHide {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                
                self.view.frame.origin.y = 64
            })
            
        }else {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                guard let navigation = self.navigationController else {
                    return
                }
                let min = navigation.navigationBar.frame.maxY
                let value = keyboardFrame.height - (self.view.frame.height - self.emailField!.frame.maxY - 5)
                self.view.frame.origin.y = -(self.clamp(value: value, minValue: -min, maxValue:keyboardFrame.height))
                
                // self.view.frame.origin.y = -(keyboardFrame.size.height * 0.4)
            })
        }
    }
    
    func clamp<T : Comparable>(value: T, minValue: T, maxValue: T) -> T {
        return min(maxValue, max(minValue, value))
    }
}

extension LoginViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
