import Foundation

public class Allergy : DBObject
{
    public let allergyId: Int
    public let allergyName: String
    public let allergyDescription: String
    
    required public init(dictionary:[String:Any])
    {
        allergyId = dictionary["allergyId"] as! Int
        allergyName = dictionary["allergyName"] as! String
        allergyDescription = dictionary["allergyDescription"] as! String
        super.init(dictionary: dictionary)
    }
    
    override public func toDictionay() -> [String:Any]
    {
        return ["allergyId" : allergyId, "allergyName" : allergyName, "allergyDescription" : allergyDescription]
    }
    
    static func == (allergy1: Allergy, allergy2: Allergy) -> Bool
    {
        if allergy1.allergyId == allergy2.allergyId
        {
            return true
        }
        else
        {
            return false
        }
    }
}
