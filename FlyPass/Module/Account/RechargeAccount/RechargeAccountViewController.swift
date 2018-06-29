//
//  RechargeAccountViewController.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/22/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit
import SVProgressHUD

enum collectionViewCellConstant {
    static let rechargeCell = "cell"
}

class RechargeAccountViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var amountToRecharge: UITextField!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    private var indexOfCellBeforeDragging = 0
    let viewModel = RechargeAccountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate         = self
        collectionView.dataSource       = self
        collectionView.isPagingEnabled  = true
        amountToRecharge.delegate       = self
        setupAccessoryView()
        requestAccountInfo()
    }
    
    override func configureAppearance() {
        super.configureAppearance()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func calculateSectionInset() -> CGFloat {
        let deviceIsIpad                    = UIDevice.current.userInterfaceIdiom == .pad
        let deviceOrientationIsLandscape    = UIDevice.current.orientation.isLandscape
        let cellBodyViewIsExpended          = deviceIsIpad || deviceOrientationIsLandscape
        let cellBodyWidth: CGFloat          = 236 + (cellBodyViewIsExpended ? 174 : 0)
        let buttonWidth: CGFloat            = 50
        
        let inset = (collectionViewLayout.collectionView!.frame.width - cellBodyWidth + buttonWidth) / 4
        return inset
    }
    
    fileprivate func configureCollectionViewLayoutItemSize() {
        let inset: CGFloat                  = calculateSectionInset() // This inset calculation is some magic so the next and the previous cells will peek from the sides. Don't worry about it
        collectionViewLayout.sectionInset   = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        collectionViewLayout.itemSize       = CGSize(width: collectionViewLayout.collectionView!.frame.size.width - inset * 2, height: collectionViewLayout.collectionView!.frame.size.height)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    fileprivate func indexOfMajorCell() -> Int {
        let itemWidth           = collectionViewLayout.itemSize.width
        let proportionalOffset  = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        return Int(round(proportionalOffset))
    }
    
    fileprivate func requestAccountInfo() {
        SVProgressHUD.show()
        viewModel.getAccountRechargeDetails(successClosure: {
            SVProgressHUD.dismiss()
            self.collectionView.reloadData()
        }, errorClosure: { error in
            SVProgressHUD.showInfo(withStatus: error.localizedDescription)
        })
    }
    
    @IBAction func RechargeAction(_ sender: Any) {
        viewModel.rechargeAccount(amountToRecharege: 10000, selectedAccount: viewModel.accountDetails.first!, successClosure: {
            print("")
        }, errorClosure: {error in
            
            
        })
        print("hi")
    }
    
}

//MARK: CollectionView
extension RechargeAccountViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell            = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellConstant.rechargeCell, for: indexPath) as! RechargeAccountCollectionViewCell
        let currentAccount  = viewModel.accountDetails[indexPath.row]
        cell.setupInfoForAccount(account: currentAccount)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.accountDetails.count
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        // calculate where scrollView should snap to:
        let indexOfMajorCell        = self.indexOfMajorCell()
        // calculate conditions:
        let swipeVelocityThreshold: CGFloat                 = 0.5 // after some trail and error
        let hasEnoughVelocityToSlideToTheNextCell           = indexOfCellBeforeDragging + 1 < 10 && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell       = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging                = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell                           = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = collectionViewLayout.itemSize.width * CGFloat(snapToIndex)
            
            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
            
        } else {
            // This is a much better to way to scroll to a cell:
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            if indexPath.row == 10 {
                return
            }
            collectionViewLayout.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
        }
    }
}

//MARK: Textfield Delegate

extension RechargeAccountViewController:UITextFieldDelegate {
    
    @objc func hideKeyboard() {
        amountToRecharge.resignFirstResponder()
    }
    
    fileprivate func setupAccessoryView() {
        
        let tbKeyboard                      = UIToolbar(frame: CGRect.init(x: 0, y: 0,width: view.frame.size.width, height: 44))
        let bbiSubmit                       = UIBarButtonItem(title: "Done", style: .plain,target: self, action:#selector(hideKeyboard))
        tbKeyboard.items                    = [bbiSubmit]
        amountToRecharge.inputAccessoryView = tbKeyboard
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        guard let amount = textField.text, !amount.isEmpty,let amountNumber = Double(amount) else {
            return
        }
        
        let currencyFormatter                   = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle           = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale                = Locale.current
        
        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        let priceString                         = currencyFormatter.string(from:NSNumber(value:amountNumber))
        amountToRecharge.text                   = priceString
        
    }
    
}
