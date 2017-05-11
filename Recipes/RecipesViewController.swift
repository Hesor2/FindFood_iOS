//
//  RecipesViewController.swift
//  Recipes
//
//  Created by Markus Sørensen on 03/05/17.
//  Copyright © 2017 Markus Sørensen. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    var browsing : Bool = false
    var menu : Menu?
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var recipesTable: UITableView!
    
    @IBOutlet weak var purchaseButton: UIButton!
    
    var recipes = [Recipe]()
    var searchRecipes = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getRecipes()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        getRecipes()
        if menu == nil
        {
            purchaseButton.isHidden = true
        }
        else
        {
            if browsing
            {
                purchaseButton.setTitle("Purchase", for: .normal)
            }
            else
            {
                purchaseButton.setTitle("Remove", for: .normal)
            }
        }
    }
    
    
    func getRecipes()
    {
        recipes = [Recipe]()
        searchRecipes = [Recipe]()
        if menu == nil
        {
            API.Recipes.getUserrecipes(completion: {
                (recipes, error) in
                if error == nil
                {
                    if !self.browsing
                    {
                        self.recipes = recipes!
                        self.searchRecipes(search: self.searchField.text!)
                    }
                    else
                    {
                        let userrecipes = recipes
                        API.Recipes.getRecipes(completion: {
                            (recipes, error) in
                            if error == nil
                            {
                                for recipe in recipes!
                                {
                                    var owned = false
                                    for userrecipe in userrecipes!
                                    {
                                        if recipe == userrecipe
                                        {
                                            owned = true
                                            break
                                        }
                                    }
                                    if !owned
                                    {
                                        self.recipes.append(recipe)
                                    }
                                }
                                
                                self.searchRecipes(search: self.searchField.text!)
                            }
                            else
                            {
                                self.presentErrorAlert(error: error)
                            }
                        })
                    }
                }
                else
                {
                    self.presentErrorAlert(error: error)
                }
            })
        }
        else
        {
            recipes = (menu?.recipes)!
            self.searchRecipes(search: self.searchField.text!)
        }
    }
    
    @IBAction func purchasePressed(_ sender: UIButton)
    {
        if menu != nil
        {
            if browsing
            {
                API.Menus.buyMenu(menu: menu!, completion: {
                    (error) in
                    if error == nil
                    {
                        self.performSegue(withIdentifier: "UnwindToMenus", sender: true)
                    }
                    else
                    {
                        self.presentErrorAlert(error: error)
                    }
                })
            }
            else
            {
                API.Menus.removeMenu(menu: menu!, completion: {
                    (error) in
                    if error == nil
                    {
                        self.performSegue(withIdentifier: "UnwindToMenus", sender: false)
                    }
                    else
                    {
                        self.presentErrorAlert(error: error)
                    }
                })
            }
            
        }
    }
    
    
    //tableview
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        
        cell.textLabel?.text = searchRecipes[indexPath.row].recipeName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let recipe =  searchRecipes[indexPath.row]
        if browsing
        {
            performSegue(withIdentifier: "ShowPreview", sender: recipe)
        }
        else
        {
            //performSegue(withIdentifier: "ShowRecipe", sender: recipe)
        }
        
        
    }
    
    //textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        searchRecipes(search: textField.text!)
    }
    
    func searchRecipes(search: String)
    {
        searchRecipes = [Recipe]()
        if search != ""
        {
            for recipe in recipes
            {
                if recipe.recipeName.localizedCaseInsensitiveContains(search)
                {
                    searchRecipes.append(recipe)
                }
            }
        }
        else
        {
            searchRecipes = recipes
        }
        
        recipesTable.reloadData()
    }
    
    @IBAction func unwindToRecipesViewController(segue: UIStoryboardSegue)
    {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowPreview"
        {
            if let destination = segue.destination as? RecipePreviewViewController
            {
                if let recipe = sender as? Recipe
                {
                    destination.recipe = recipe
                }
            }
        }
        else if segue.identifier == "ShowRecipe"
        {
            
        }
        else if segue.identifier == "UnwindToMenus"
        {
            if let destination = segue.destination as? MenusViewController
            {
                if let owned = sender as? Bool
                {
                    destination.browsing = !owned
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
