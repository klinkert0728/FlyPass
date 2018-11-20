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
import UserNotifications

enum tableViewConstants {
    static let movementCell = "movementCell"
}

class AccountReviewViewController: BaseViewController {
    
    @IBOutlet weak var movementTableview: UITableView!
    @IBOutlet weak var resumeAccountView: ResumeAccountView!
    
    let viewModel       = AccountReviewViewControllerViewModel()
    let locationManager = CLLocationManager()
    let refreshControl  = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        movementTableview.addSubview(refreshControl)
        configureLocationManager()
        requestData()
    }
    
    //MARK: ViewModel
    fileprivate func requestData() {
        updateReviewView()
        upateMovements()
    }
    
    @objc func refresh(sender:Any) {
        requestData()
        refreshControl.endRefreshing()
    }
    
    fileprivate func updateReviewView() {
        SVProgressHUD.show()
        viewModel.fetchUserInformation { [weak self] (error)  in
            SVProgressHUD.dismiss()
            self?.configureResumeView()
            if let error = error {
                if (error as NSError).code == 401 {
                    self?.presentAlertToRefreshToken()
                }
                SVProgressHUD.show(withStatus: error.localizedDescription)
            }
        }
    }
    
    fileprivate func upateMovements() {
        SVProgressHUD.show()
        viewModel.fetchUserMovements(successClosure: { [weak self] in
            SVProgressHUD.dismiss()
            self?.movementTableview.reloadData()
            }, errorClosure: {  error in
                SVProgressHUD.dismiss()
                if (error as NSError).code != 401 {
                    SVProgressHUD.showInfo(withStatus: error.localizedDescription)
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
            //            locationManager.stopMonitoringSignificantLocationChanges()
            //            for region in locationManager.monitoredRegions {
            //                locationManager.stopMonitoring(for: region)
            //            }
            //            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            //            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            let loginNavigation     = NavigationHelper.signInNavigationViewController()
            let loginViewController = loginNavigation.topViewController as?  LoginViewController
            navigationController?.present(loginNavigation, animated: true, completion: nil)
            loginViewController?.successLogin = { [weak self] in
                self?.navigationController?.dismiss(animated: true, completion: nil)
                self?.updateReviewView()
                self?.upateMovements()
                self?.configureLocationManager()
            }
        }
    }
    
    fileprivate func configureResumeView() {
        guard let user = viewModel.user else {
            return
        }
        resumeAccountView.configureView(user: user)
    }
    
    fileprivate func presentAlertToRefreshToken() {
        let alert = UIAlertController(title: "Session Expired", message: "Your session expired, please login again in order to have your latest information available", preferredStyle: .actionSheet)
        let loginAction = UIAlertAction(title: "Login", style: .default) { (action) in
            User.logOut()
            self.presentLogin()
        }
        
        let dismissAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(loginAction)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "History"
    }
}

//MARK: Local Notification
extension AccountReviewViewController {
    
    fileprivate func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            completionHandler(success)
        }
    }
    
    fileprivate func checkNotificationPermissions() {
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    self.scheduleTriggerForRegions()
                })
            case .authorized:
                self.scheduleTriggerForRegions()
            // Schedule Local Notification
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        }
    }
    
    
    fileprivate func scheduleTriggerForRegions() {
        for toll in tollsLocation.allValues {
            let region                      = toll.circularRegion()
            let notificationContent         = UNMutableNotificationContent()
            notificationContent.title       = "FlyPass"
            notificationContent.body        = "Just passed \(toll.tollName()), please check your account status"
            region.notifyOnEntry            = true
            region.notifyOnExit             = true
            let notificationTrigger         = UNLocationNotificationTrigger(region:region, repeats: true)
            // Create Notification Request
            let notificationRequest         = UNNotificationRequest(identifier:UUID().uuidString, content: notificationContent, trigger: notificationTrigger)
            locationManager.startMonitoring(for: region)
            // Add Request to User Notification Center
            UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                if let error = error {
                    print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
                }
            }
        }
        
    }
}

//MARK: Location Manager
extension AccountReviewViewController:CLLocationManagerDelegate {
    
    fileprivate func configureLocationManager() {
        locationManager.delegate                        = self
        locationManager.desiredAccuracy                 = kCLLocationAccuracyKilometer
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.activityType                    = CLActivityType.automotiveNavigation
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            break
            
        case .authorizedWhenInUse:
            checkNotificationPermissions()
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
            break
            
        case .notDetermined, .authorizedAlways:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        for location in locations {
            
            print("\(location.coordinate) Hola ")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("a")
    }
}
