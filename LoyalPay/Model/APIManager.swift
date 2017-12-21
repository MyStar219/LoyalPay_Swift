//
//  APIManager.swift
//  LoyalPay
//
//  Created by Mobile Developer on 11/15/17.
//  Copyright © 2017 Mobile Developer. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    
    public static var sharedInstance = APIManager()
    
    public func queryJSON(withURL url: URL, success: ((Dictionary<String, Any>?) -> ())?, failed: (() -> ())?) {
        
        Alamofire.request(url).responseJSON { (response) in
            if let responseData = response.data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: responseData, options:JSONSerialization.ReadingOptions(rawValue: 0))
                    
                    guard let dictionary = jsonObject as? Dictionary<String, Any> else {
                        failed?()
                        return
                    }
                    success?(dictionary)
                } catch {
                    failed?()
                }
            } else {
                failed?()
            }
        }
    }
    
    public func signIn(withURL url: String, userName: String, password: String, completion: @escaping (_ result: Bool)->(), failed: @escaping (_ result:String)->()) {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let postString = "userName=" + userName + "&password=" + password
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error == nil {
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                    failed("response = \(String(describing: response))")
                }
                else {
                    let responseString = String(data: data!, encoding: .utf8)
                    if responseString == "yes" {
                        completion(true)
                    }
                    else {
                        completion(false)
                    }
                }
            }
            else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                failed("error=\(String(describing: error))")
            }
        }
        task.resume()
    }
    
    public func signUp(withURL url: String, fullName: String, userName: String, email: String, password: String, phoneNumber: String, cardNumber: String, completion: @escaping (_ result: Bool)->(), failed: @escaping (_ result:String)->()) {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let postString = "fullName=" + fullName + "&userName=" + userName + "&email=" + email + "&password=" + password + "&phoneNumber=" + phoneNumber + "&cardNumber=" + cardNumber
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error == nil {
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                    failed("response = \(String(describing: response))")
                }
                else {
                    let responseString = String(data: data!, encoding: .utf8)
                    if responseString == "yes" {
                        completion(true)
                    }
                    else {
                        completion(false)
                    }
                }
            }
            else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                failed("error=\(String(describing: error))")
            }
        }
        task.resume()
    }
}
