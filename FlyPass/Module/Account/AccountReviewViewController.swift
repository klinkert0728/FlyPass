//
//  ReviewStatusViewController.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/8/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit
import  SVProgressHUD

enum tableViewConstants {
    static let movementCell = "movementCell"
}

class AccountReviewViewController: BaseViewController {

    @IBOutlet weak var movementTableview: UITableView!
    @IBOutlet weak var resumeAccountView: ResumeAccountView!
    
    var viewModel:AccountReviewViewControllerViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
    }
    
    fileprivate func initViewModel() {
        
        viewModel = AccountReviewViewControllerViewModel()
        viewModel?.fetchUserInformation()
        viewModel?.fetchUserMovements()
        viewModel?.reloadTableViewClosure = { [weak self] in
            self?.movementTableview.reloadData()
        }
        
        viewModel?.reloadUserInfoView = { [weak self] in
            self?.configureResumeView()
        }
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
                self?.viewModel?.fetchUserInformation()
                self?.viewModel?.fetchUserMovements()
            }
        }
    }
    
    fileprivate func configureResumeView() {
        guard let user = viewModel?.user else {
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
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.movements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewConstants.movementCell, for: indexPath) as! ResumeAccountTableViewCell
        let movement = viewModel.movements[indexPath.row]
        cell.configureMovementCell(movement: movement)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "History"
    }
}
