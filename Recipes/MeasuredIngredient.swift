import Foundation

public class MeasuredIngredient : DBObject
{
    public let measuredIngredientId: Int
    public let ingredient: Ingredient
    public let amount: Double
    public let measure: String
    
    required public init(dictionary:[String:Any])
    {
        measuredIngredientId = dictionary["measuredIngredientId"] as! Int
        let temp = dictionary["ingredient"] as! [String:Any]
        ingredient = Ingredient(dictionary: temp)
        amount = dictionary["amount"] as! Double
        measure = dictionary["measure"] as! String
        super.init(dictionary: dictionary)
    }
    
    override public func toDictionay() -> [String:Any]
    {
        return ["measuredIngredientId" : measuredIngredientId, "ingredient" : ingredient.toDictionay(), "amount" : amount, "measure" : measure]
    }
    
    static func == (measuredIngredient1: MeasuredIngredient, measuredIngredient2: MeasuredIngredient) -> Bool
    {
        if measuredIngredient1.measuredIngredientId == measuredIngredient2.measuredIngredientId
        {
            return true
        }
        else
        {
            return false
        }
    }
}
