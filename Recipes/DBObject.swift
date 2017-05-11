import Foundation

public class DBObject
{
    required public init(dictionary: [String:Any])
    {
        
    }
    
    public func toDictionay() -> [String:Any]
    {
        return ["key":"value"]
    }
}
