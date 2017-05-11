//
//  RecipePreviewViewController.swift
//  Recipes
//
//  Created by Markus Sørensen on 04/05/17.
//  Copyright © 2017 Markus Sørensen. All rights reserved.
//

import UIKit

class RecipePreviewViewController: UIViewController
{
    
    var recipe : Recipe?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextview: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        nameLabel.text = recipe?.recipeName
        categoryLabel.text = recipe?.recipeType.recipeTypeName
        descriptionTextview.text = recipe?.recipeDescription
        // Do any additional setup after loading the view.
    }
    
    @IBAction func purchasePressed(_ sender: UIButton)
    {
        API.Recipes.buyRecipe(recipe: recipe!, completion: {
            (error) in
            if error == nil
            {
                self.performSegue(withIdentifier: "UnwindToRecipes", sender: nil)
            }
            else
            {
                self.presentErrorAlert(error: error)
            }
            
        })
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
