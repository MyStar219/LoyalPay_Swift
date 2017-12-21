//
//  registerViewController.swift
//  LoyalPay
//
//  Created by Mobile Developer on 11/14/17.
//  Copyright © 2017 Mobile Developer. All rights reserved.
//

import UIKit
import Alamofire

class registerViewController: UIViewController {

    @IBOutlet weak var fullName_TField: UITextField!
    @IBOutlet weak var userName_TField: UITextField!
    @IBOutlet weak var email_TField: UITextField!
    @IBOutlet weak var password_TField: UITextField!
    @IBOutlet weak var phone_TField: UITextField!
    @IBOutlet weak var card_TField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(registerViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(registerViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(registerViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpBtnClicked(_ sender: UIButton) {
        
        if (fullName_TField.text != "" && userName_TField.text != "" && email_TField.text != "" && password_TField.text != "" && phone_TField.text != "" && card_TField.text != "") {
            
            GlobalData.fullName = self.fullName_TField.text!
            GlobalData.userName = self.userName_TField.text!
            GlobalData.email = self.email_TField.text!
            GlobalData.password = self.password_TField.text!
            GlobalData.phoneNumber = self.phone_TField.text!
            GlobalData.cardNumber = self.card_TField.text!
            
            register()
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Please insert all items.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func register() {
        
        APIManager.sharedInstance.signUp(withURL: REGISTER_URL as String, fullName: fullName_TField.text!, userName: userName_TField.text!, email: email_TField.text!, password: password_TField.text!, phoneNumber: phone_TField.text!, cardNumber: card_TField.text!, completion: {(result)-> () in
            print(result)
            if result {
                let homeViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: show_CardCheckVC) as! cardCheckViewController
                self.navigationController?.pushViewController(homeViewController, animated: true)
            } else {
                let alert = UIAlertController(title: "User exist already", message: "Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }, failed: {(result)-> () in
            print(result)
            let alert = UIAlertController(title: "Error", message: "Please try again later.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
