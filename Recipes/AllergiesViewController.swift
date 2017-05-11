import UIKit

class AllergiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    @IBOutlet weak var allergiesSearchField: UITextField!
    @IBOutlet weak var allergiesTable: UITableView!
    
    @IBOutlet weak var userallergiesSearchField: UITextField!
    @IBOutlet weak var userallergiesTable: UITableView!
    
    var allergies = [Allergy]()
    var userallergies = [Allergy]()
    
    var tempAllergies = [Allergy]()
    var tempUserallergies = [Allergy]()
    
    var searchAllergies = [Allergy]()
    var searchUserallergies = [Allergy]()
    
    var editingMode = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getAllergies()
    }
    
    func getAllergies()
    {
        API.Allergies.getAllergies(completion: {
            (allergies, error) in
            if error == nil
            {
                self.allergies = allergies!
                API.Allergies.getUserAllergies(completion: {
                    (allergies, error) in
                    if error == nil
                    {
                        self.userallergies = allergies!
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
            userallergies = tempUserallergies
        }
        tempAllergies = [Allergy]()
        tempUserallergies = userallergies
        for allergy in allergies
        {
            var isUserallergy = false
            for userallergy in userallergies
            {
                if allergy == userallergy
                {
                    isUserallergy = true
                    break
                }
            }
            if !isUserallergy
            {
                tempAllergies.append(allergy)
            }
        }
        updateAllergiesTable()
        updateUserallergiesTable()
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
            API.Allergies.putUserallergies(allergies: tempUserallergies, completion: {
                (error) in
                if error == nil
                {
                    self.updateData()
                    sender.setTitle("Edit Allergies", for: .normal)
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
            return searchAllergies.count
        }
        else
        {
            return searchUserallergies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView.tag == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "allergyCell", for: indexPath)
            
            cell.textLabel?.text = searchAllergies[indexPath.row].allergyName
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userallergyCell", for: indexPath)
            
            cell.textLabel?.text = searchUserallergies[indexPath.row].allergyName
            
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
                let allergy = searchAllergies[index]
                var i = 0
                for item in tempAllergies
                {
                    if allergy == item                    {
                        tempAllergies.remove(at: i)
                        break
                    }
                    i += 1
                }
                tempUserallergies.append(allergy)
            }
            else
            {
                let allergy = searchUserallergies[index]
                var i = 0
                for item in tempUserallergies
                {
                    if allergy == item
                    {
                        tempUserallergies.remove(at: i)
                        break
                    }
                    i += 1
                }
                tempAllergies.append(allergy)
            }
            updateAllergiesTable()
            updateUserallergiesTable()
        }
        else
        {
            var allergy : Allergy
            if tableView.tag == 0
            {
                allergy = searchAllergies[index]
                
            }
            else
            {
                allergy = searchUserallergies[index]
                
            }
            performSegue(withIdentifier: "ShowAllergy", sender: allergy)
        }
    }
    
    func updateAllergiesTable()
    {
        if allergiesSearchField.text != nil && allergiesSearchField.text != ""
        {
            searchAllergies(search: allergiesSearchField.text!)
        }
        else
        {
            searchAllergies = tempAllergies
        }
        allergiesTable.reloadData()
    }
    
    func updateUserallergiesTable()
    {
        if userallergiesSearchField.text != nil && userallergiesSearchField.text != ""
        {
            searchUserallergies(search: userallergiesSearchField.text!)
        }
        else
        {
            searchUserallergies = tempUserallergies
        }
        userallergiesTable.reloadData()
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
            updateAllergiesTable()
        }
        else
        {
            updateUserallergiesTable()
        }
    }
    
    func searchAllergies(search: String)
    {
        searchAllergies = [Allergy]()
        for allergy in tempAllergies
        {
            if allergy.allergyName.localizedCaseInsensitiveContains(search)
            {
                searchAllergies.append(allergy)
            }
        }
    }
    
    func searchUserallergies(search: String)
    {
        searchUserallergies = [Allergy]()
        for allergy in tempUserallergies
        {
            if allergy.allergyName.localizedCaseInsensitiveContains(search)
            {
                searchUserallergies.append(allergy)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowAllergy"
        {
            if let destination = segue.destination as? AllergyViewController
            {
                if let allergy = sender as? Allergy
                {
                    destination.allergy = allergy
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
