//
//  loginViewController.swift
//  LoyalPay
//
//  Created by Mobile Developer on 11/14/17.
//  Copyright © 2017 Mobile Developer. All rights reserved.
//

import UIKit
import Alamofire

class loginViewController: UIViewController {

    @IBOutlet weak var userName_TField: UITextField!
    @IBOutlet weak var password_TField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(loginViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInBtnClicked(_ sender: UIButton) {
        if (userName_TField.text != "" && password_TField.text != "" ) {

            GlobalData.userName = self.userName_TField.text!
            GlobalData.password = self.password_TField.text!

            signIn()

        } else {
            let alert = UIAlertController(title: "Error", message: "Please insert all items.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func signUpBtnClicked(_ sender: UIButton) {
        let registerViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: show_RegisterVC) as! registerViewController
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    func signIn() {
        
        APIManager.sharedInstance.signIn(withURL: SIGNIN_URL, userName: userName_TField.text!, password: password_TField.text!, completion: {(result)-> () in
            print(result)
            if result {
                let homeViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: show_CardCheckVC) as! cardCheckViewController
                self.navigationController?.pushViewController(homeViewController, animated: true)
            } else {
                let alert = UIAlertController(title: "UserName and Password Wrong", message: "Please enter the user name and password again", preferredStyle: UIAlertControllerStyle.alert)
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
