//
//  IngredientViewController.swift
//  Recipes
//
//  Created by Markus Sørensen on 03/05/17.
//  Copyright © 2017 Markus Sørensen. All rights reserved.
//

import UIKit


class IngredientViewController: UIViewController
{
    var ingredient : Ingredient?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextview: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ingredient != nil
        {
            titleLabel.text = ingredient?.ingredientName
            descriptionTextview.text = ingredient?.ingredientDescription
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
