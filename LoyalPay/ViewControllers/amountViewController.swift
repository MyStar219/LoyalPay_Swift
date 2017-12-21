//
//  amountViewController.swift
//  LoyalPay
//
//  Created by Mobile Developer on 11/14/17.
//  Copyright © 2017 Mobile Developer. All rights reserved.
//

import UIKit

class amountViewController: UIViewController {

    @IBOutlet weak var cardName_Lbl: UILabel!
    @IBOutlet weak var cardNumber_Lbl: UILabel!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var amount_TField: UITextField!
    @IBOutlet weak var checkView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkView.layer.cornerRadius = checkView.frame.size.width/2
        checkView.clipsToBounds = true
        dialogView.isHidden = true

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(amountViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func newSubmitBtnClicked(_ sender: UIButton) {
        view.isHidden = false
        dialogView.isHidden = true
    }
    
    @IBAction func exitBtnClicked(_ sender: UIButton) {
        let homeViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: show_CardCheckVC) as! cardCheckViewController
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        view.isHidden = true
        dialogView.isHidden = false
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
