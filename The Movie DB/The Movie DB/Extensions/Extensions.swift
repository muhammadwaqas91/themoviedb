//
//  Extensions.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/28/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    class func topMostController() -> UIViewController? {
        if let rootViewController = UIApplication.shared.windows.last?.rootViewController {
            var vc: UIViewController? = rootViewController
            while (vc?.presentedViewController != nil) {
                vc = vc?.presentedViewController
            }
            return rootViewController
        }
        return nil
    }
    
    func showAlert(withTitle title: String? = nil, message : String? , success: (() -> Void)? = nil,  failure:(() -> Void)? = nil)  {
        
        DispatchQueue.main.async {
            if title == nil && message == nil {
                return
            }
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                if let success = success {
                    success()
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
                if let failure = failure {
                    failure()
                }
            }
            alertController.addAction(OKAction)
            alertController.addAction(cancel)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    /*
    
    class func showAlertView(withTitle title: String? = nil, message: String?, alertType: AlertType = .none, rightBtnTitle: String? = nil, leftBtnTitle: String? = nil, rightHandler: (() -> Void)? = nil, leftHandler: (() -> Void)? = nil, hideOnTouch: Bool = false, autoHide: Bool = false, duration: Double = 2.0) {
        
        let alertView = Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)![0] as! AlertView
        
        alertView.hideOnTouch = hideOnTouch
        
        switch alertType {
        case .none:
            alertView.topImageOuterView.isHidden = true
        case .success:
            alertView.topImageView.image = UIImage(named: "alert-success")
        case .failure:
            alertView.topImageView.image = UIImage(named: "alert-error")
        case .info:
            alertView.topImageView.image = UIImage(named: "alert-info")
        case .logout:
            alertView.topImageView.image = UIImage(named: "alert-logout")
        }
        
        alertView.titleLabel.text = title ?? ""
        alertView.messageLabel.text = message ?? ""
        
        
        if hideOnTouch {
            alertView.btnLeft.isHidden = true
            alertView.btnRight.isHidden = true
            alertView.buttonsOuterView.isHidden = true
        }
        else if autoHide {
            alertView.btnLeft.isHidden = true
            alertView.btnRight.isHidden = true
            alertView.buttonsOuterView.isHidden = true
            perform(#selector(Utility.removeFromSuperView(_:)), with: alertView, afterDelay: duration)
        }
        else {
            if rightBtnTitle != nil {
                alertView.btnRight.setTitle(rightBtnTitle, for: .normal)
                
            } else {
                alertView.btnRight.setTitle("OK", for: .normal)
            }
            
            alertView.rightHandler = {
                if let handler = rightHandler {
                    handler()
                }
                Utility.removeFromSuperView(alertView)
            }
            
            if leftBtnTitle != nil {
                alertView.btnLeft.setTitle(leftBtnTitle, for: .normal)
            } else {
                alertView.btnLeft.isHidden = true
            }
            
            alertView.leftHandler = {
                if let handler = leftHandler {
                    handler()
                }
                Utility.removeFromSuperView(alertView)
            }
        }
        alertView.alpha = 0
        alertView.frame = UIScreen.main.bounds
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve, animations: {
                UIApplication.shared.keyWindow?.addSubview(alertView)
                alertView.alpha = 1
            }) { (completed) in
                print(completed)
            }
        }
     
     @objc class func removeFromSuperView(_ view: UIView) {
         UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve, animations: {
             view.alpha = 0
         }) { (completed) in
             view.removeFromSuperview()
             print(completed)
         }
     }
     
    }
 */
    
    
}

extension UIImageView {
 
    func downloadImage(urlString: String, success: ((_ image: UIImage?) -> Void)? = nil, failure: ((_ error: Error?) -> Void)? = nil) {
        
        let imageCache = NSCache<NSString, UIImage>()

        DispatchQueue.main.async {
            self.image = nil
        }
        
        if let image = imageCache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async {
                self.image = image
            }
            if let success = success {
                success(image)
            }
        } else {
            guard let url = URL(string: urlString) else {
                print("failed to create url")
                return
            }
            
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                
                // response received, now switch back to main queue
                DispatchQueue.main.async {
                    if let error = error {
                        if let failure = failure {
                            failure(error)
                        }
                    }
                    else if let data = data, let image = UIImage(data: data) {
                        imageCache.setObject(image, forKey: url.absoluteString as NSString)
                        self.image = image
                        if let success = success {
                            success(image)
                        }
                    } else {
                        if let failure = failure {
                            failure(nil)
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
}

extension Dictionary {
    func urlEncodedString() -> String {
        let array = self.map({ dict -> String in
            
            let characterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-._~"))
            
            if let encodedKey = (dict.key as? String)?.addingPercentEncoding(withAllowedCharacters: characterSet), let encodedValue = (String(describing: dict.value) ).addingPercentEncoding(withAllowedCharacters: characterSet) {
                return "\(encodedKey)=\(encodedValue)"
            }
            
            return ""
        })
        
        return array.joined(separator: "&")
    }
    
    /// Returns a merged dictionary.
    ///
    /// For any values `a` and `b`,
    /// `a + b` implies that `b` will be merged in `a`
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    static func merge (lhs: inout [Key : Value], rhs: [Key : Value]) {
        lhs.merge(rhs) { (current, _) in current }
    }
}

extension Array where Element : Equatable {
    func findIndexes(_ child: Array<Element>) -> [Int] {
        var indexes: [Int] = []

        _ = child.filter({item in
            guard let index = firstIndex(of: item) else {
                return false
            }
            indexes.append(index)
            return true
        })

        return indexes
    }

}
