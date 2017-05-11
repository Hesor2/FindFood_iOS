//
//  ViewController.swift
//  TicTacToe
//
//  Created by Markus Sørensen on 17/03/17.
//  Copyright © 2017 Markus Sørensen. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    let emailKey = "lastEmail"
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var regionPicker: UIPickerView!
    
    private var regions = [Region]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readEmail()
        setRegionPicker()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signInPressed(_ sender: UIButton)
    {
        login()
    }
    
    func login()
    {
        //if regionPicker.
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if error == nil
            {
                self.saveEmail()
                let region = self.regions[self.regionPicker.selectedRow(inComponent: 0)]
                
                API.setBaseUrl(region: region)
                self.performSegue(withIdentifier: "ShowMenu", sender: nil)
            }
            else
            {
                self.presentErrorAlert(error: error)
            }
        }
    }
    
    func saveEmail()
    {
        let defaults = UserDefaults.standard
        defaults.set(emailField.text, forKey: emailKey)
    }
    
    func readEmail()
    {
        let defaults = UserDefaults.standard
        if let email = defaults.string(forKey: emailKey)
        {
            emailField.text = email
        }
    }
    
    func setRegionPicker()
    {
        regions = [Region]()
        let regionsRef = FIRDatabase.database().reference(withPath: "API").child("user")
        
        regionsRef.observeSingleEvent(of: .value, with:
        { (snapshot) in
            let snapValues = snapshot.children
            for item in snapValues
            {
                let region = Region(snapshot: item as! FIRDataSnapshot)
                if region.enabled
                {
                    self.regions.append(region)
                }
            }
                
            self.regionPicker.reloadAllComponents()
        })
    }
    
    //UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return regions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return regions[row].name
    }
    
    
    @IBAction func unwindToLoginViewController(segue: UIStoryboardSegue)
    {
        passwordField.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
    }
    
}

