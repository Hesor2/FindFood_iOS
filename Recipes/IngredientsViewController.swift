//
//  IngredientsViewController.swift
//  Recipes
//
//  Created by Markus Sørensen on 03/05/17.
//  Copyright © 2017 Markus Sørensen. All rights reserved.
//

import UIKit

class IngredientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var ingredientsTable: UITableView!
    
    var ingredients = [Ingredient]()
    var searchIngredients = [Ingredient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getIngredients()

        // Do any additional setup after loading the view.
    }
    
    func getIngredients()
    {
        API.Ingredients.getIngredients(completion: {
            (ingredients, error) in
            if error == nil
            {
                self.ingredients = ingredients!
                self.updateTable()
            }
            else
            {
                self.presentErrorAlert(error: error)
            }
        })
    }
    
    func updateTable()
    {
        if searchField.text != nil && searchField.text != ""
        {
            searchIngredients(search: searchField.text!)
        }
        else
        {
            searchIngredients = ingredients
        }
        ingredientsTable.reloadData()
    }
    
    //tableView
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
            
        cell.textLabel?.text = searchIngredients[indexPath.row].ingredientName
            
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let ingredient = searchIngredients[indexPath.row]
        performSegue(withIdentifier: "ShowIngredient", sender: ingredient)
    }
    
    //textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        updateTable()
    }
    
    func searchIngredients(search: String)
    {
        searchIngredients = [Ingredient]()
        for ingredient in ingredients
        {
            if ingredient.ingredientName.localizedCaseInsensitiveContains(search)
            {
                searchIngredients.append(ingredient)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowIngredient"
        {
            if let destination = segue.destination as? IngredientViewController
            {
                if let ingredient = sender as? Ingredient
                {
                    destination.ingredient = ingredient
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
