//
//  BookCategoryTableViewController.swift
//  NewYorkTimesDemo
//
//  Created by Ethan Chen on 10/27/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit

class BookCategoryTableViewController: UITableViewController {
    var categories : [Category] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIClient.shared.fetchAllCategories { (cl) in
            if let x = cl.results {
                self.categories = x
                DispatchQueue.main.async {
                   self.tableView.reloadData()
                }
                
            }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if categories.count == 0 {
            self.tableView.setEmptyMessage("Empty")
            self.tableView.isScrollEnabled = false
        } else {
            self.tableView.restore()
            self.tableView.isScrollEnabled = true
        }
        return categories.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cateCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = categories[indexPath.row].display_name
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Books", bundle:nil).instantiateViewController(withIdentifier: "books") as! BooksofCategoryTableViewController
        vc.list_name_encoded = categories[indexPath.row].list_name_encoded!
        vc.title = categories[indexPath.row].display_name
        self.navigationController?.pushViewController(vc, animated: true)
    }


}