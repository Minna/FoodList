//
//  FoodListViewController.swift
//  Foodie
//
//  Created by Minna on 23/07/21.
//

import UIKit
import CoreData

class FoodListViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    var foodManager = FoodManager()
    var foodList =  [NSManagedObject]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var selectedFav = false
    override func viewDidLoad() {
        super.viewDidLoad()
        print(appDelegate.persistentContainer.persistentStoreDescriptions)

        foodManager.delegate = self
        foodManager.fetchFoodList()
        searchBar.delegate = self
       
    }

    @IBAction func favoriteButtonPressed(_ sender: Any) {
        selectedFav = !selectedFav
        favoriteButton.title = !selectedFav ? "Favorite":"All"
        loadItems(search: nil)
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return foodList.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.userCellIdentifier, for: indexPath) as! FoodTableViewCell
        
        cell.textLabel?.text = foodList[indexPath.row].value(forKey: K.Model.mealString) as? String
        cell.imageView?.load(urlstring:(foodList[indexPath.row].value(forKey: K.Model.mealThumb) as? String)!)
        let imgName = foodList[indexPath.row].value(forKey: K.Model.isFav) as! Bool ? K.Resorce.heartFill : K.Resorce.heart
        let image1 = UIImage(systemName: imgName)
        cell.favoriteButton.setImage(image1, for: .normal)
        cell.favoriteButtonAction = { [unowned self] in
            let imgName = foodList[indexPath.row].value(forKey: K.Model.isFav) as! Bool ? K.Resorce.heart : K.Resorce.heartFill
            let image1 = UIImage(systemName: imgName)
            cell.favoriteButton.setImage(image1, for: .normal)
            favorite(foodItem:foodList[indexPath.row])
        }
        
        return cell
    }
    

   

}

extension FoodListViewController: FoodManegerDelegate
{
    func didUpdateFoodList(_ foodManager: FoodManager, foodModel: FoodModel) {
        
        guard let list = foodModel.meals else {
            return
        }
        DispatchQueue.main.async {
            self.saveFoodListToDB(list: list)
        }
       
    }
    
    func didUpdateWithError(error: Error) {
        DispatchQueue.main.async {
            self.tableView.reloadData()

        }
    }
    
    func saveFoodListToDB(list:[Meal]) {
      let managedContext =
        appDelegate.persistentContainer.viewContext
        managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        for item in list{
            
            let meal :Meals!
            let fetchMeal: NSFetchRequest<Meals> = Meals.fetchRequest()
            fetchMeal.predicate = NSPredicate(format: "strMeal = %@", item.strMeal! as String)
            let results = try? managedContext.fetch(fetchMeal)

             if results?.count == 0 {
                meal = Meals(context: managedContext)
             } else {
                meal = results?.first
             }

            meal.setValue(item.strMeal, forKeyPath: K.Model.mealString)
            meal.setValue(item.strMealThumb, forKeyPath: K.Model.mealThumb)
           
            do {
              try managedContext.save()
             
            } catch let error as NSError {
              print("Could not save. \(error), \(error.userInfo)")
            }
        }
        loadItems(search: nil)

      
      
    }
    
    func loadItems(search:String?){

        // 1
        var searchPredicate : NSPredicate?
        var favPredicate : NSPredicate?
        let managedContext =
          appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Meals> = Meals.fetchRequest()
        
        //
        if(selectedFav){
            favPredicate = NSPredicate(format: "isFav == true")
            request.predicate = favPredicate
        }
        if let s = search {
            searchPredicate = NSPredicate(format: "strMeal CONTAINS[cd] %@", s)
            request.predicate = searchPredicate
        }
         if let search = searchPredicate, let fav = favPredicate {
                    let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [search,fav])

                    request.predicate = compoundPredicate
                }
                  do {
                   foodList = try managedContext.fetch(request)
                } catch {
                    print("Error loading items\(error)")
                }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()

        }
        
    }
    
   
    func favorite(foodItem:NSManagedObject){
        
        if(foodItem.value(forKey: K.Model.isFav) as! Bool){
            foodItem.setValue(false, forKeyPath: K.Model.isFav)
        }else{
            foodItem.setValue(true, forKeyPath: K.Model.isFav)

        }
        do {
          try appDelegate.persistentContainer.viewContext.save()
         // people.append(person)
         
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
        
    }


}

extension FoodListViewController :UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadItems(search: searchText)
        if searchBar.text?.count == 0{
            loadItems(search: nil)

         searchBar.resignFirstResponder()
         }
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
        return true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
extension UIImageView {
    func load(urlstring: String) {
        if let url = URL(string: urlstring){
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
        }
    }
}

