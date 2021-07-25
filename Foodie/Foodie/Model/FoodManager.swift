//
//  FoodManager.swift
//  Foodie
//
//  Created by Minna on 23/07/21.
//

import Foundation


protocol FoodManegerDelegate {
    func didUpdateFoodList(_ foodManager : FoodManager, foodModel: FoodModel)
    func didUpdateWithError(error: Error)

}

struct FoodManager{
    
   // let apiString = "https://www.themealdb.com/api/json/v1/1/filter.php?a=Canadian"
    let apiString = "https://www.themealdb.com/api/json/v1/1/search.php?s="
    var delegate : FoodManegerDelegate?

    func searchForFood(searchText:String){
        let url = "\(apiString)\(searchText)"
               print(url)
               
               perfoamRequeste(urlstring: url)
    }
    func fetchFoodList(){
        perfoamRequeste(urlstring: apiString)
    }
    
    func perfoamRequeste(urlstring:String){
        
        if let url = URL(string: urlstring){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    delegate?.didUpdateWithError(error: error!)

                    return
                }
                
                if let safeData = data{
                    
                    
                    if let foodModal = parseJoson(foodData: safeData){
                        
                        delegate?.didUpdateFoodList(self, foodModel: foodModal)
                    }
                    
                }
            }
            task.resume()
            
        }
    }
    
    func parseJoson(foodData: Data) -> FoodModel?{
            
            let decoder = JSONDecoder()
            do {
              let data =  try   decoder.decode(FoodModel.self, from: foodData)

          
    return data
                
            } catch {
                print(error)
                delegate?.didUpdateWithError(error: error)

                return nil
            }
        }
    
}
