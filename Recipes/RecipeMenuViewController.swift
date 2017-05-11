//
//  RecipeMenuViewController.swift
//  Recipes
//
//  Created by Markus Sørensen on 03/05/17.
//  Copyright © 2017 Markus Sørensen. All rights reserved.
//

import UIKit

class RecipeMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func browsePressed(_ sender: UIButton)
    {
        performSegue(withIdentifier: "ShowRecipes", sender: true)
    }
    
    @IBAction func yourRecipesPressed(_ sender: UIButton)
    {
        performSegue(withIdentifier: "ShowRecipes", sender: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowRecipes"
        {
            if let destination = segue.destination as? RecipesViewController
            {
                if let browsing = sender as? Bool
                {
                    destination.browsing = browsing
                }
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
