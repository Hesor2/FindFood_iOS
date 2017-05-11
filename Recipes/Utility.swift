//
//  Utility.swift
//  TicTacToe
//
//  Created by Markus Sørensen on 18/03/17.
//  Copyright © 2017 Markus Sørensen. All rights reserved.
//

import Foundation
import Firebase

public class Utility
{
    private static func setImage(view: UIView, image: UIImage)
    {
        if let button = view as? UIButton
        {
            button.setImage(image, for: .normal)
        }
        else if let imageView = view as? UIImageView
        {
            imageView.image = image
        }
    }
}
extension UIViewController
{
    func presentErrorAlert(error: Error?)
    {
        if let errorText = error?.localizedDescription
        {
            presentErrorAlert(errorText: errorText)
        }
        
    }
    
    func presentErrorAlert(errorText: String)
    {
        let alertController = UIAlertController(title: "Error", message: errorText, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { (_) in }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
