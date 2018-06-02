//
//  ReviewStatusViewController.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/8/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit
import SVProgressHUD

enum tableViewConstants {
    static let movementCell = "movementCell"
}

class AccountReviewViewController: BaseViewController {
    
    @IBOutlet weak var movementTableview: UITableView!
    @IBOutlet weak var resumeAccountView: ResumeAccountView!
    
    var viewModel = AccountReviewViewControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
    }
    
    
    //MARK: ViewModel
    fileprivate func initViewModel() {
        updateReviewView()
        upateMovements()
    }
    
    fileprivate func updateReviewView() {
        SVProgressHUD.show()
        viewModel.fetchUserInformation(successClosure: { [weak self] in
            SVProgressHUD.dismiss()
            self?.configureResumeView()
            }, errorClosure: { error in
                SVProgressHUD.dismiss()
                SVProgressHUD.showInfo(withStatus: error.localizedDescription)
                if (error as NSError).code == 401  {
                    self.presentLogin()
                }
        })
    }
    
    fileprivate func upateMovements() {
        SVProgressHUD.show()
        viewModel.fetchUserMovements(successClosure: { [weak self] in
            SVProgressHUD.dismiss()
            self?.movementTableview.reloadData()
            }, errorClosure: { (error) in
                SVProgressHUD.dismiss()
                SVProgressHUD.showInfo(withStatus: error.localizedDescription)
                if (error as NSError).code == 401  {
                    self.presentLogin()
                }
        })
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        title                                           = "Fly pass"
        movementTableview.delegate                      = self
        movementTableview.dataSource                    = self
        movementTableview.estimatedRowHeight            = 100
        movementTableview.rowHeight                     = UITableViewAutomaticDimension
        movementTableview.tableFooterView               = UIView()
        navigationItem.rightBarButtonItem = Appearance.barButtonWithTitle(title: "Recharge Account", target: self, action: #selector(rechargeAccountAction(_:)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentLogin()
    }
    
    fileprivate func presentLogin() {
        if !User.isLoggedIn {
            let loginNavigation = NavigationHelper.signInNavigationViewController()
            let loginViewController = loginNavigation.topViewController as?  LoginViewController
            navigationController?.present(loginNavigation, animated: true, completion: nil)
            loginViewController?.successLogin = { [weak self] in
                self?.navigationController?.dismiss(animated: true, completion: nil)
                self?.updateReviewView()
                self?.upateMovements()
            }
        }
    }
    
    fileprivate func configureResumeView() {
        guard let user = viewModel.user else {
            return
        }
        resumeAccountView.configureView(user: user)
    }
    
    @objc func rechargeAccountAction(_ sender: Any) {
        
    }
    
}

extension AccountReviewViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewConstants.movementCell, for: indexPath) as! ResumeAccountTableViewCell
        let movement = viewModel.movements[indexPath.row]
        cell.configureMovementCell(movement: movement)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "History"
    }
}
