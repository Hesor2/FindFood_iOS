import Foundation

public class Ingredient : DBObject
{
    public let ingredientId : Int
    public let ingredientName : String
    public let ingredientDescription : String
    
    required public init(dictionary:[String:Any])
    {
        ingredientId = dictionary["ingredientId"] as! Int
        ingredientName = dictionary["ingredientName"] as! String
        ingredientDescription = dictionary["ingredientDescription"] as! String
        super.init(dictionary: dictionary)
    }
    
    override public func toDictionay() -> [String:Any]
    {
        return ["ingredientId" : ingredientId, "ingredientName" : ingredientName, "ingredientDescription" : ingredientDescription]
    }
    
    static func == (ingredient1: Ingredient, ingredient2: Ingredient) -> Bool
    {
        if ingredient1.ingredientId == ingredient2.ingredientId
        {
            return true
        }
        else
        {
            return false
        }
    }
}
