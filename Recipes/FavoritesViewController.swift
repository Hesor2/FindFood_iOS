//
//  FavoritesViewController.swift
//  Recipes
//
//  Created by Markus Sørensen on 03/05/17.
//  Copyright © 2017 Markus Sørensen. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var ingredientsSearchField: UITextField!
    @IBOutlet weak var ingredientsTable: UITableView!
    
    @IBOutlet weak var favoritesSearchField: UITextField!
    @IBOutlet weak var favoritesTable: UITableView!
    
    var ingredients = [Ingredient]()
    var favorites = [Ingredient]()
    
    var tempIngredients = [Ingredient]()
    var tempFavorites = [Ingredient]()
    
    var searchIngredients = [Ingredient]()
    var searchFavorites = [Ingredient]()
    
    var editingMode = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getIngredients()
    }
    
    func getIngredients()
    {
        API.Ingredients.getIngredients(completion: {
            (ingredients, error) in
            if error == nil
            {
                self.ingredients = ingredients!
                API.Ingredients.getFavorites(completion: {
                    (favorites, error) in
                    if error == nil
                    {
                        self.favorites = favorites!
                        self.updateData()
                    }
                    else
                    {
                        self.presentErrorAlert(error: error)
                    }
                })
            }
            else
            {
                self.presentErrorAlert(error: error)
            }
        })
    }
    
    func updateData()
    {
        if editingMode
        {
            favorites = tempFavorites
        }
        tempIngredients = [Ingredient]()
        tempFavorites = favorites
        for ingredient in ingredients
        {
            var isFavorite = false
            for favorite in favorites
            {
                if ingredient == favorite
                {
                    isFavorite = true
                }
            }
            if !isFavorite
            {
                tempIngredients.append(ingredient)
            }
        }
        updateIngredientsTable()
        updateFavoritesTable()
    }
    
    
    @IBAction func editOrAcceptPressed(_ sender: UIButton)
    {
        if !editingMode
        {
            sender.setTitle("Accept", for: .normal)
            editingMode = true
        }
        else
        {
            API.Ingredients.putFavorites(favorites: tempFavorites, completion: {
                (error) in
                if error == nil
                {
                    self.updateData()
                    sender.setTitle("Edit Favorites", for: .normal)
                    self.editingMode = false
                }
                else
                {
                    self.presentErrorAlert(error: error)
                }
            })
            
        }
    }
    
    
    
    //tableview
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView.tag == 0
        {
            return searchIngredients.count
        }
        else
        {
            return searchFavorites.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView.tag == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
            
            cell.textLabel?.text = searchIngredients[indexPath.row].ingredientName
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
            
            cell.textLabel?.text = searchFavorites[indexPath.row].ingredientName
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let index = indexPath.row
        if editingMode
        {
            if tableView.tag == 0
            {
                let ingredient = searchIngredients[index]
                var i = 0
                for item in tempIngredients
                {
                    if ingredient == item                    {
                        tempIngredients.remove(at: i)
                        break
                    }
                    i += 1
                }
                tempFavorites.append(ingredient)
            }
            else
            {
                let ingredient = searchFavorites[index]
                var i = 0
                for item in tempFavorites
                {
                    if ingredient == item
                    {
                        tempFavorites.remove(at: i)
                        break
                    }
                    i += 1
                }
                tempIngredients.append(ingredient)
            }
            updateIngredientsTable()
            updateFavoritesTable()
        }
        else
        {
            var ingredient : Ingredient
            if tableView.tag == 0
            {
                ingredient = searchIngredients[index]
                
            }
            else
            {
                ingredient = searchFavorites[index]
                
            }
            performSegue(withIdentifier: "ShowIngredient", sender: ingredient)
        }
    }
    
    func updateIngredientsTable()
    {
        if ingredientsSearchField.text != nil && ingredientsSearchField.text != ""
        {
            searchIngredients(search: ingredientsSearchField.text!)
        }
        else
        {
            searchIngredients = tempIngredients
        }
        ingredientsTable.reloadData()
    }
    
    func updateFavoritesTable()
    {
        if favoritesSearchField.text != nil && favoritesSearchField.text != ""
        {
            searchFavorites(search: favoritesSearchField.text!)
        }
        else
        {
            searchFavorites = tempFavorites
        }
        favoritesTable.reloadData()
    }
    
    //textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField.tag == 0
        {
            updateIngredientsTable()
        }
        else
        {
            updateFavoritesTable()
        }
    }
    
    func searchIngredients(search: String)
    {
        searchIngredients = [Ingredient]()
        for ingredient in tempIngredients
        {
            if ingredient.ingredientName.localizedCaseInsensitiveContains(search)
            {
                searchIngredients.append(ingredient)
            }
        }
    }
    
    func searchFavorites(search: String)
    {
        searchFavorites = [Ingredient]()
        for ingredient in tempFavorites
        {
            if ingredient.ingredientName.localizedCaseInsensitiveContains(search)
            {
                searchFavorites.append(ingredient)
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
