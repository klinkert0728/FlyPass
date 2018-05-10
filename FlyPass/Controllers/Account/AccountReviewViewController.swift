//
//  ReviewStatusViewController.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/8/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit
import  SVProgressHUD

class AccountReviewViewController: BaseViewController {

    @IBOutlet weak var movementTableview: UITableView!
    @IBOutlet weak var resumeAccountView: ResumeAccountView!
    fileprivate var movements = [UserMovements]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInformation()
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        title                                           = "Fly pass"
        movementTableview.delegate                      = self
        movementTableview.dataSource                    = self
        movementTableview.estimatedRowHeight            = 100
        movementTableview.rowHeight                     = UITableViewAutomaticDimension
        movementTableview.tableFooterView               = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !User.isLoggedIn {
            let loginNavigation = NavigationHelper.signInNavigationViewController()
            let loginViewController = loginNavigation.topViewController as?  LoginViewController
            navigationController?.present(loginNavigation, animated: true, completion: nil)
            loginViewController?.successLogin = { [weak self] in
                self?.navigationController?.dismiss(animated: true, completion: nil)
                self?.getUserInformation()
            }
        }
    }
    
    fileprivate func getUserInformation() {
        if !User.isLoggedIn {
            return
        }
        SVProgressHUD.show()
        User.getUserInformation(successCallback: { (currentUser) in
            UserMovements.getUserMovements(successCallback: { (userMovements:[UserMovements]) in
                self.movements.removeAll()
                self.movements = userMovements
                self.movementTableview.reloadData()
            }, errorCallback: { (error) in
                SVProgressHUD.dismiss()
                SVProgressHUD.show(withStatus: error.localizedDescription)
            })
            self.configureResumeView()
            SVProgressHUD.dismiss()
        }, errorCallback: { error in
            SVProgressHUD.dismiss()
            SVProgressHUD.show(withStatus: error.localizedDescription)
        })
    }
    
    fileprivate func configureResumeView() {
        guard let user = User.currentUser else {
            return
        }
        resumeAccountView.configureView(user: user)
    }
}

extension AccountReviewViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movementCell", for: indexPath) as! ResumeAccountTableViewCell
        
        cell.configureMovementCell(movement: movements[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "History"
    }
}
