import Foundation
import Firebase

class User
{
    var role: String
    
    init()
    {
        role = "client"
    }
    
    init(snapshot:FIRDataSnapshot)
    {  // When an object is loaded from Firebase
        let value = snapshot.value as! [String: AnyObject]
        role = value["role"] as! String
    }
    
    func toDictionary() -> Any
    {
        return ["role": role]
    }
}
