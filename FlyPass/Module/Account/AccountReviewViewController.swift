//
//  ReviewStatusViewController.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/8/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit
import SVProgressHUD
import Crashlytics
import CoreLocation

enum tableViewConstants {
    static let movementCell = "movementCell"
}

class AccountReviewViewController: BaseViewController {
    
    @IBOutlet weak var movementTableview: UITableView!
    @IBOutlet weak var resumeAccountView: ResumeAccountView!
    
    let viewModel       = AccountReviewViewControllerViewModel()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
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
            }, errorClosure: { [weak self] error in
                SVProgressHUD.dismiss()
                SVProgressHUD.showInfo(withStatus: error.localizedDescription)
                if (error as NSError).code == 401  {
                    self?.presentLogin()
                }
        })
    }
    
    fileprivate func upateMovements() {
        SVProgressHUD.show()
        viewModel.fetchUserMovements(successClosure: { [weak self] in
            SVProgressHUD.dismiss()
            self?.movementTableview.reloadData()
            }, errorClosure: { [weak self] error in
                SVProgressHUD.dismiss()
                SVProgressHUD.showInfo(withStatus: error.localizedDescription)
                if (error as NSError).code == 401  {
                    self?.presentLogin()
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
}

extension AccountReviewViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell        = tableView.dequeueReusableCell(withIdentifier: tableViewConstants.movementCell, for: indexPath) as! ResumeAccountTableViewCell
        let movement    = viewModel.movements[indexPath.row]
        cell.configureMovementCell(movement: movement)
        if viewModel.shouldDownload && indexPath.row == viewModel.movements.count - 1 {
            viewModel.movementPage += 1
            upateMovements()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "History"
    }
}

//MARK: Location Manager
extension AccountReviewViewController:CLLocationManagerDelegate {
    
    fileprivate func configureLocationManager() {
        locationManager.delegate                        = self
        locationManager.desiredAccuracy                 = kCLLocationAccuracyKilometer
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.activityType                    = CLActivityType.automotiveNavigation
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        configureRegions()
    }
    
    fileprivate func configureRegions() {
        let region              = tollsLocation.lasPalmasAirport.circularRegion()
        region.notifyOnExit     = true
        region.notifyOnEntry    = true
        locationManager.startMonitoring(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            print("\(location.coordinate) Hola ")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Enter \(region.identifier)")
        locationManager.stopMonitoring(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit \(region.identifier)")
        locationManager.stopMonitoring(for:region)
    }
    
}

