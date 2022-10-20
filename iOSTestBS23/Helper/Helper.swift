//
//  Helper.swift
//  iOSTestBS23
//
//  Created by Md. Shahed Mamun on 20/10/22.
//

import UIKit


extension UIViewController{
    
    func showAlert(title: String?, message: String?, callback: ((_ action: UIAlertAction)->Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            callback?(action)
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
