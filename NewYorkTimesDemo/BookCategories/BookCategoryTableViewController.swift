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
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    var repeatFetching : Timer! //refetch timer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.hidesWhenStopped = true
        showIndicator() //start spinner
        fetchingData()
        repeatFetching = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(fetchingData), userInfo: nil, repeats: true)
        
    }
    @objc func fetchingData(){
        APIClient.shared.fetchAllCategories { (categoryObj) in
            if let results = categoryObj.results {
                self.categories = results //populate array
                DispatchQueue.main.async {
                    self.tableView.reloadData() //update UI
                    self.hideIndicator() //stop spinner when complete
                    self.repeatFetching.invalidate()
                }
                
            }
        }
    }
    
    //function to show the spinner
    func showIndicator() {
        self.navigationItem.titleView = self.activityIndicator
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
    }
    //function to hide the spinner
    func hideIndicator() {
        self.activityIndicator.stopAnimating()
        self.navigationItem.titleView = nil
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if categories.count == 0 {
            //display inital empty msg
            self.tableView.setEmptyMessage("Fetching data. Please wait..")
        }
        else {
            self.repeatFetching.invalidate()
            self.tableView.removeMsg()
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
