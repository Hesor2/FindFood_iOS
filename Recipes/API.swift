import Foundation
import Firebase

public class API
{
    private static var baseUrl = ""
    private static func makeRequest(url : String, method: String, body: Data?, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void)
    {
        let currentUser = FIRAuth.auth()?.currentUser
        currentUser?.getTokenForcingRefresh(false) {idToken, error in
            if let error = error
            {
                completion(nil, nil, error)
                return
            }
            print("token: \(idToken)")
            // Send token to your backend via HTTPS
            // ...
            guard let requestUrl = URL(string:baseUrl+url) else { return }
            var request = URLRequest(url:requestUrl)
            request.httpMethod = method
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(idToken, forHTTPHeaderField: "Authorization")
            if body != nil
            {
                request.httpBody = body
            }
            
            let config = URLSessionConfiguration.default // Session Configuration
            //config.httpAdditionalHeaders?["Authorization"] = idToken
            let session = URLSession(configuration: config) // Load configuration into Session
            
            let task = session.dataTask(with: request, completionHandler: {
                (data, response, error) in
                
                DispatchQueue.main.async
                    {
                        if let httpResponse = response as? HTTPURLResponse
                        {
                            print("statusCode: \(httpResponse.statusCode)")
                            if httpResponse.statusCode != 200
                            {
                                completion(nil, response, error)
                            }
                            completion(data, response, error)
                        }
                        
                }
            })
            task.resume()
        }
    }
    
    private static func fromJSONCollection<T: DBObject>(collectionID: String, data: Data?) -> [T]
    {
        var objectArray = [T]()
        if data != nil
        {
            do
            {
                if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                {
                    if let objects = json[collectionID] as? [[String: Any]]
                    {
                        for item in objects
                        {
                            let object = T(dictionary: item)
                            
                            objectArray.append(object)
                        }
                    }
                    //print("array size: \(objectArray.count)")
                    
                }
            }
            catch
            {
                print("error in JSONSerialization")
            }
        }
        return objectArray
    }
    
    private static func toJSONCollection<T: DBObject>(collectionID: String, collection: [T]) -> Data?
    {
        var dictionary = [[String:Any]]()
        for item in collection
        {
            dictionary.append(item.toDictionay())
        }
        if let jsonData = try? JSONSerialization.data(withJSONObject: [collectionID:dictionary], options: [])
        {
            return jsonData
        }
        else
        {
            return nil
        }
    }
    
    public static func setBaseUrl(region:Region)
    {
        baseUrl = region.address
    }
    
    
    public class Allergies
    {
        private static var baseUrl = "allergies"
        
        public static func getAllergies(completion: @escaping (_ allergies: [Allergy]?, _ error: Error?) -> Void)
        {
            API.makeRequest(url: baseUrl, method: "GET", body: nil, completion:
                {
                    (data, response, error) in
                    if error != nil
                    {
                        completion(nil, error)
                    }
                    else
                    {
                        if let allergies = API.fromJSONCollection(collectionID: "allergies", data: data) as [Allergy]?
                        {
                            completion(allergies, nil)
                        }
                    }
            })
        }
        
        public static func getUserAllergies(completion: @escaping (_ allergies: [Allergy]?, _ error: Error?) -> Void)
        {
            API.makeRequest(url: baseUrl + "/user", method: "GET", body: nil, completion:
                {
                    (data, response, error) in
                    if error != nil
                    {
                        completion(nil, error)
                    }
                    else
                    {
                        
                        if let allergies = API.fromJSONCollection(collectionID: "allergies", data: data) as [Allergy]?
                        {
                            completion(allergies, nil)
                        }
                    }
            })
        }
        
        public static func putUserallergies(allergies: [Allergy], completion: @escaping (_ error: Error?) -> Void)
        {
            
            let json = API.toJSONCollection(collectionID: "allergies", collection: allergies)
            API.makeRequest(url: baseUrl, method: "PUT", body: json, completion:
                {
                    (data, response, error) in
                    completion(error)
            })
        }
    }
    
    public class Ingredients
    {
        private static var baseUrl = "ingredients"
        
        public static func getIngredients(completion: @escaping (_ ingredients: [Ingredient]?, _ error: Error?) -> Void)
        {
            API.makeRequest(url: baseUrl, method: "GET", body: nil, completion:
                {
                    (data, response, error) in
                    if error != nil
                    {
                        completion(nil, error)
                    }
                    else
                    {
                        if let ingredients = API.fromJSONCollection(collectionID: "ingredients", data: data) as [Ingredient]?
                        {
                            completion(ingredients, nil)
                        }
                    }
            })
        }
        
        public static func getFavorites(completion: @escaping (_ favorites: [Ingredient]?, _ error: Error?) -> Void)
        {
            API.makeRequest(url: baseUrl + "/favorites", method: "GET", body: nil, completion:
                {
                    (data, response, error) in
                    if error != nil
                    {
                        completion(nil, error)
                    }
                    else
                    {
                        if let favorites = API.fromJSONCollection(collectionID: "ingredients", data: data) as [Ingredient]?
                        {
                            completion(favorites, nil)
                        }
                    }
            })
        }
        
        public static func putFavorites(favorites: [Ingredient], completion: @escaping (_ error: Error?) -> Void)
        {
            
            let json = API.toJSONCollection(collectionID: "ingredients", collection: favorites)
            API.makeRequest(url: baseUrl + "/favorites", method: "Put", body: json, completion:
                {
                    (data, response, error) in
                    completion(error)
            })
        }
        
        public static func getDislikes(completion: @escaping (_ dislikes: [Ingredient]?, _ error: Error?) -> Void)
        {
            API.makeRequest(url: baseUrl + "/dislikes", method: "GET", body: nil, completion:
                {
                    (data, response, error) in
                    if error != nil
                    {
                        completion(nil, error)
                    }
                    else
                    {
                        if let dislikes = API.fromJSONCollection(collectionID: "ingredients", data: data) as [Ingredient]?
                        {
                            completion(dislikes, nil)
                        }
                    }
            })
        }
        
        public static func putDislikes(dislikes: [Ingredient], completion: @escaping (_ error: Error?) -> Void)
        {
            
            let json = API.toJSONCollection(collectionID: "ingredients", collection: dislikes)
            API.makeRequest(url: baseUrl + "/dislikes", method: "Put", body: json, completion:
                {
                    (data, response, error) in
                    completion(error)
            })
        }
    }
    
    public class Recipes
    {
        private static var baseUrl = "recipes"
        
        public static func getRecipes(completion: @escaping (_ recipes: [Recipe]?, _ error: Error?) -> Void)
        {
            API.makeRequest(url: baseUrl, method: "GET", body: nil, completion:
                {
                    (data, response, error) in
                    if error != nil
                    {
                        completion(nil, error)
                    }
                    else
                    {
                        if let recipes = API.fromJSONCollection(collectionID: "recipes", data: data) as [Recipe]?
                        {
                            completion(recipes, nil)
                        }
                    }
            })
        }
        
        public static func getUserrecipes(completion: @escaping (_ recipes: [Recipe]?, _ error: Error?) -> Void)
        {
            API.makeRequest(url: baseUrl + "/user", method: "GET", body: nil, completion:
                {
                    (data, response, error) in
                    if error != nil
                    {
                        completion(nil, error)
                    }
                    else
                    {
                        if let recipes = API.fromJSONCollection(collectionID: "recipes", data: data) as [Recipe]?
                        {
                            completion(recipes, nil)
                        }
                    }
            })
        }
        
        public static func buyRecipe(recipe: Recipe, completion: @escaping (_ error: Error?) -> Void)
        {
            API.makeRequest(url: baseUrl + "/buy/\(recipe.recipeId)", method: "POST", body: nil, completion:
                {
                    (data, response, error) in
                    completion(error)
            })
        }
        
        public static func removeRecipe(recipe: Recipe, completion: @escaping (_ error: Error?) -> Void)
        {
            API.makeRequest(url: baseUrl + "/remove/\(recipe.recipeId)", method: "DELETE", body: nil, completion:
                {
                    (data, response, error) in
                    completion(error)
            })
        }
    }
    
    public class Menus
    {
        private static var baseUrl = "menus"
        
        public static func getMenus(completion: @escaping (_ menus: [Menu]?, _ error: Error?) -> Void)
        {
            API.makeRequest(url: baseUrl, method: "GET", body: nil, completion:
                {
                    (data, response, error) in
                    if error != nil
                    {
                        completion(nil, error)
                    }
                    else
                    {
                        if let menus = API.fromJSONCollection(collectionID: "menus", data: data) as [Menu]?
                        {
                            completion(menus, nil)
                        }
                    }
            })
        }
        
        public static func getUsermenus(completion: @escaping (_ menus: [Menu]?, _ error: Error?) -> Void)
        {
            API.makeRequest(url: baseUrl + "/user", method: "GET", body: nil, completion:
                {
                    (data, response, error) in
                    if error != nil
                    {
                        completion(nil, error)
                    }
                    else
                    {
                        if let menus = API.fromJSONCollection(collectionID: "menus", data: data) as [Menu]?
                        {
                            completion(menus, nil)
                        }
                    }
            })
        }
        
        public static func buyMenu(menu: Menu, completion: @escaping (_ error: Error?) -> Void)
        {
            API.makeRequest(url: baseUrl + "/buy/\(menu.menuId)", method: "POST", body: nil, completion:
                {
                    (data, response, error) in
                    completion(error)
            })
        }
        
        public static func removeMenu(menu: Menu, completion: @escaping (_ error: Error?) -> Void)
        {
            API.makeRequest(url: baseUrl + "/remove/\(menu.menuId)", method: "DELETE", body: nil, completion:
                {
                    (data, response, error) in
                    completion(error)
            })
        }
    }
    
}


