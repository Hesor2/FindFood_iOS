//
//  CreateUserViewController.swift
//  TicTacToe
//
//  Created by Markus Sørensen on 17/03/17.
//  Copyright © 2017 Markus Sørensen. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController
{
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let users = FIRDatabase.database().reference(withPath: "users")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func acceptPressed(_ sender: UIButton)
    {
        
        createUser(sender: sender)
        
    }
    
    func createUser(sender: Any)
    {
        if let email = emailField.text, let password = passwordField.text
        {
            FIRAuth.auth()?.createUser(withEmail: email, password: password)
            { (user, error) in
                if error == nil
                {
                    let userObj = User()
                    let childRef = self.users.child((user?.uid)!)
                    childRef.setValue(userObj.toDictionary())
                    
                    self.performSegue(withIdentifier: "unwindToLogin", sender: sender)
                }
                else
                {
                    self.presentErrorAlert(error: error)
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destinationVC = segue.destination as? LoginViewController
        {
            if let button = sender as? UIButton
            {
                if(button.tag == 1)
                {
                    destinationVC.emailField.text = emailField.text
                    //destinationVC.passwordField.text = passwordField.text
                }
            }
        }
        
    }
    
    
}
