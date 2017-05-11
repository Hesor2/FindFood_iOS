import Foundation

public class RecipeType : DBObject
{
    public let recipeTypeId : Int
    public let recipeTypeName : String
    
    required public init(dictionary:[String:Any])
    {
        recipeTypeId = dictionary["recipeTypeId"] as! Int
        recipeTypeName = dictionary["recipeTypeName"] as! String
        super.init(dictionary: dictionary)
    }
    
    override public func toDictionay() -> [String:Any]
    {
        return ["recipeTypeId" : recipeTypeId, "recipeTypeName" : recipeTypeName]
    }
    
    static func == (recipetype1: RecipeType, recipetype2: RecipeType) -> Bool
    {
        if recipetype1.recipeTypeId == recipetype2.recipeTypeId
        {
            return true
        }
        else
        {
            return false
        }
    }
}
