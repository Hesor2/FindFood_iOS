import Foundation

public class Menu : DBObject
{
    public let menuId: Int
    public let menuName: String
    public let menuDescription: String
    public let menuImageFilePath: String
    public let publisherName : String
    public let recipes : [Recipe]
    
    required public init(dictionary:[String:Any])
    {
        menuId = dictionary["menuId"] as! Int
        menuName = dictionary["menuName"] as! String
        menuDescription = dictionary["menuDescription"] as! String
        menuImageFilePath = dictionary["menuImageFilePath"] as! String
        publisherName = dictionary["publisherName"] as! String
        let temp = dictionary["recipes"] as! [[String:Any]]
        var array = [Recipe]()
        for item in temp
        {
            let recipe = Recipe(dictionary: item)
            array.append(recipe)
        }
        recipes = array
        super.init(dictionary: dictionary)
    }
    
    override public func toDictionay() -> [String:Any]
    {
        var dictionary : [String:Any] = ["menuId":menuId, "menuName":menuName, "menuDescription":menuDescription, "menuImageFilePath":menuImageFilePath, "publisherName":publisherName]
        var temp = [[String:Any]]()
        for item in recipes
        {
            temp.append(item.toDictionay())
        }
        dictionary["recipes"] = temp
        return dictionary
    }
    
    static func == (menu1: Menu, menu2: Menu) -> Bool
    {
        if menu1.menuId == menu2.menuId
        {
            return true
        }
        else
        {
            return false
        }
    }
}
