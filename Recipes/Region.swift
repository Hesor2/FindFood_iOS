//
//  Region.swift
//  Recipes
//
//  Created by Markus Sørensen on 01/05/17.
//  Copyright © 2017 Markus Sørensen. All rights reserved.
//

import Foundation
import Firebase

public class Region
{
    public let name: String
    public let address: String
    public let enabled: Bool
    
    init(snapshot:FIRDataSnapshot)
    {  // When an object is loaded from Firebase
        name = snapshot.key
        let value = snapshot.value as! [String: AnyObject]
        address = value["address"] as! String
        enabled = value["enabled"] as! Bool
    }
}
