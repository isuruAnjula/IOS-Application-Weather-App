//
//  HistoryViewController.swift
//  Isuru_Patabendi_FE_8922125
//
//  Created by user235715 on 12/4/23.
//

import UIKit

class HistoryViewController: UITableViewController {

    //THIS FUNCTION IS NOT WORKING CORRECTLY. PLEASE REVIEW THE CODE.
    
    // Outlets for UI elements
    @IBOutlet var myHistoryList: UITableView!
    @IBOutlet var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myHistoryList.delegate = self
        myHistoryList.dataSource = self
        
        // Register custom table view cell to the table
        myHistoryList.register(HistoryNewsTableViewCell.nib(), forCellReuseIdentifier: HistoryNewsTableViewCell.identifier)

//        myHistoryList.register(HistoryMapTableViewCell.nib(), forCellReuseIdentifier: HistoryMapTableViewCell.identifier)
        
        //fetch Data
        fetchData()
        
        //register a default cell if there's no custom data
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
    }
    
    //array to hold core data
    var myData: [CustomData]?
    
    let content = (UIApplication.shared.delegate as!
                   AppDelegate).persistentContainer.viewContext
    
    //fetch core data
    func fetchData(){
        do{
            self.myData = try content.fetch(CustomData.fetchRequest())
            DispatchQueue.main.async {
                self.myHistoryList.reloadData()
            }
        }catch{
            print("no data")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var count = (self.myData?.count)!
        if(count == 0){
            errorMessage.text = "No history to show! Please search a destination and come back..."
        }
        return self.myData?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //deque news reusable cell
        var cell = tableView.dequeueReusableCell(withIdentifier: HistoryNewsTableViewCell.identifier, for: indexPath) as! HistoryNewsTableViewCell
        
        let cellItem = self.myData![indexPath.row]

        if(cellItem.screenName == "News"){
            //configure news cell
            cell = tableView.dequeueReusableCell(withIdentifier: HistoryNewsTableViewCell.identifier, for: indexPath) as! HistoryNewsTableViewCell
            
            // Populate cell with article data
            cell.HNScreen.text = "News"
            cell.HNFrom.text = cellItem.newsTransaction
            cell.HNCity.text = cellItem.newsCityName
            cell.HNTitle.text = cellItem.newsTitle
            
            //if description is nil
            if(cellItem.newsDescription != nil){
                cell.HNDescription.text = cellItem.newsDescription
            }else{
                cell.HNDescription.text = "Article Description: not found!"
            }
            
            cell.HNSource.text = "Source: \(cellItem.newsSource!)"
            
            //if author is nil
            if(cellItem.newsAuthor != nil){
                cell.HNAuthor.text = "Author: \(cellItem.newsAuthor!)"
            }else{
                cell.HNAuthor.text = "Author: not found!"
            }
            
        }else if(cellItem.screenName == "Direction"){
//            cell = tableView.dequeueReusableCell(withIdentifier: HistoryMapTableViewCell.identifier, for: indexPath) as! HistoryMapTableViewCell
            
        }else if(cellItem.screenName == "Weather"){
//            cell = tableView.dequeueReusableCell(withIdentifier: HistoryNewsTableViewCell.identifier, for: indexPath)
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
