//
//  RecipesViewController.swift
//  Recipes
//
//  Created by Markus Sørensen on 03/05/17.
//  Copyright © 2017 Markus Sørensen. All rights reserved.
//

import UIKit

class MenusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    var browsing : Bool = false
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var menusTable: UITableView!
    
    var menus = [Menu]()
    var searchMenus = [Menu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getRecipes()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMenus()
    }
    
    
    func getMenus()
    {
        menus = [Menu]()
        searchMenus = [Menu]()
        API.Menus.getUsermenus(completion: {
            (menus, error) in
            if error == nil
            {
                if !self.browsing
                {
                    self.menus = menus!
                    self.searchMenus(search: self.searchField.text!)
                }
                else
                {
                    let usermenus = menus
                    API.Menus.getMenus(completion: {
                        (menus, error) in
                        if error == nil
                        {
                            for menu in menus!
                            {
                                var owned = false
                                for usermenu in usermenus!
                                {
                                    if menu == usermenu
                                    {
                                        owned = true
                                        break
                                    }
                                }
                                if !owned
                                {
                                    self.menus.append(menu)
                                }
                            }
                            
                            self.searchMenus(search: self.searchField.text!)
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
    
    //tableview
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchMenus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        
        cell.textLabel?.text = searchMenus[indexPath.row].menuName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let menu =  searchMenus[indexPath.row]
        if browsing
        {
            performSegue(withIdentifier: "ShowRecipes", sender: menu)
        }
        else
        {
            performSegue(withIdentifier: "ShowRecipes", sender: menu)
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
        searchMenus(search: textField.text!)
    }
    
    func searchMenus(search: String)
    {
        searchMenus = [Menu]()
        if search != ""
        {
            for menu in menus
            {
                if menu.menuName.localizedCaseInsensitiveContains(search)
                {
                    searchMenus.append(menu)
                }
            }
        }
        else
        {
            searchMenus = menus
        }
        
        menusTable.reloadData()
    }
    
    @IBAction func unwindToMenusViewController(segue: UIStoryboardSegue)
    {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowRecipes"
        {
            if let destination = segue.destination as? RecipesViewController
            {
                if let menu = sender as? Menu
                {
                    destination.browsing = browsing
                    destination.menu = menu
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
