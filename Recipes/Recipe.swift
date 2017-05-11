import Foundation

public class Recipe : DBObject
{
    public let recipeId: Int
    public let recipeName: String
    public let recipeDescription: String
    public let recipeImageFilePath: String
    public let recipeType: RecipeType
    public let publisherName : String
    public let measuredIngredients : [MeasuredIngredient]
    
    required public init(dictionary:[String:Any])
    {
        recipeId = dictionary["recipeId"] as! Int
        recipeName = dictionary["recipeName"] as! String
        recipeDescription = dictionary["recipeDescription"] as! String
        recipeImageFilePath = dictionary["recipeImageFilePath"] as! String
        let dict = dictionary["recipeType"] as! [String:Any]
        recipeType = RecipeType(dictionary: dict)
        publisherName = dictionary["publisherName"] as! String
        let temp = dictionary["measuredIngredients"] as! [[String:Any]]
        var array = [MeasuredIngredient]()
        for item in temp
        {
            let measuredIngredient = MeasuredIngredient(dictionary: item)
            array.append(measuredIngredient)
        }
        measuredIngredients = array
        super.init(dictionary: dictionary)
    }
    
    override public func toDictionay() -> [String:Any]
    {
        var dictionary : [String:Any] = ["recipeId":recipeId, "recipeName":recipeName, "recipeDescription":recipeDescription, "recipeImageFilePath":recipeImageFilePath, "publisherName":publisherName]
        var temp = [[String:Any]]()
        for item in measuredIngredients
        {
            temp.append(item.toDictionay())
        }
        dictionary["measuredIngredients"] = temp
        return dictionary
    }
    
    static func == (recipe1: Recipe, recipe2: Recipe) -> Bool
    {
        if recipe1.recipeId == recipe2.recipeId
        {
            return true
        }
        else
        {
            return false
        }
    }
}
