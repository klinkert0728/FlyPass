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
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}

extension LoginViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
