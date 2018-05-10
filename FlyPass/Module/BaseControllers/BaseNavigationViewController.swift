//
//  BaseNavigationViewController.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/8/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

    @IBInspectable var colorNavBar:String  = "" {
        didSet {
            Appearance.colorNavigationBar(color: UIColor.colorFromString(titleColor: colorNavBar), navigationBar: navigationBar)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureAppearance() {
        if colorNavBar.count > 0 {
            Appearance.colorNavigationBar(color: UIColor.colorFromString(titleColor: colorNavBar), navigationBar: navigationBar)
        }
        
        self.navigationItem.leftBarButtonItem   = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
