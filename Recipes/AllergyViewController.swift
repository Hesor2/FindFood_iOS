//
//  AllergyViewController.swift
//  Recipes
//
//  Created by Markus Sørensen on 29/04/17.
//  Copyright © 2017 Markus Sørensen. All rights reserved.
//

import UIKit

class AllergyViewController: UIViewController
{
    public var allergy : Allergy?
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextview: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if allergy != nil
        {
            titleLabel.text = allergy?.allergyName
            descriptionTextview.text = allergy?.allergyDescription
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
