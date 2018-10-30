//
//  BooksofCategoryTableViewController.swift
//  NewYorkTimesDemo
//
//  Created by Ethan Chen on 10/28/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit

class BooksofCategoryTableViewController: UITableViewController {
    var list_name_encoded = ""
    var bookList : [Book] = []
    var names : [String] = []
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.hidesWhenStopped = true
        showIndicator() //display spinner
        setUpSortButton() //set up sort button
        APIClient.shared.fetchBooksofCategory(category: list_name_encoded) { (books) in
            //get the user preference of ranking order from user default
            if let orderPref = UserDefaults.standard.string(forKey: "order") {
                if orderPref == "rank"{
                    //order by rank
                    self.bookList = books.results!.sorted(by: { Double($0.rank!) < Double($1.rank!) })
                }
                else{
                    //order by week
                    self.bookList = books.results!.sorted(by: { Double($0.weeks_on_list!) > Double($1.weeks_on_list!) })
                }
            }
            else{
               self.bookList = books.results!
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.hideIndicator()
            }
        }
    }
    //function to show spinner
    func showIndicator() {
        self.navigationItem.titleView = self.activityIndicator
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
    }
    //function to stop spinner
    func hideIndicator() {
        self.activityIndicator.stopAnimating()
        self.navigationItem.titleView = nil
    }
    //function to setup sort button according to preference stored in user default
    func setUpSortButton() {
        if let orderPref = UserDefaults.standard.string(forKey: "order") {
            if orderPref == "rank" {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "By rank", style: .plain, target: self, action: #selector(sortBooks))
            }
            else{
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "By week", style: .plain, target: self, action: #selector(sortBooks))
            }
        }
        else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortBooks))
        }
    }
    @objc func sortBooks(){
        let sortActionSheet = UIAlertController(title: "Sort the books", message: "You can sort the books by number of weeks each book has stayed on list or by the current rank of the book", preferredStyle: .actionSheet)
        
        sortActionSheet.addAction(UIAlertAction(title: "By Week", style: .default , handler:{ (UIAlertAction)in
            self.bookList.sort(by: { Double($0.weeks_on_list!) > Double($1.weeks_on_list!) })
            UserDefaults.standard.set("week", forKey: "order")
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "By week", style: .plain, target: self, action: #selector(self.sortBooks))
            self.tableView.reloadData()
        }))
        
        sortActionSheet.addAction(UIAlertAction(title: "By Rank", style: .default , handler:{ (UIAlertAction)in
            self.bookList.sort(by: { Double($0.rank!) < Double($1.rank!) })
            UserDefaults.standard.set("rank", forKey: "order")
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "By rank", style: .plain, target: self, action: #selector(self.sortBooks))
            self.tableView.reloadData()
        }))
        
        sortActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            
        }))
        
        self.present(sortActionSheet, animated: true, completion: {
           
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bookList.count == 0 {
            //display inital empty msg
            self.tableView.setEmptyMessage("")
            //if fetching more than 3 sec, display alternative empty msg
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.tableView.setEmptyMessage("Unable to fetch data. Please check your connection")
                self.hideIndicator()
            }
        } else {
            self.tableView.removeMsg()
        }
        return bookList.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as UITableViewCell
        if let bookDetails = self.bookList[indexPath.row].book_details {
            if let detail = bookDetails.first { //unwrap the book detail
                cell.textLabel?.text = detail.title //update UI with title
            }
        }
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "BookDetail", bundle:nil).instantiateViewController(withIdentifier: "bookDetail") as! BookDetailTableViewController
        
        //pass on the parameter to the detail page
        vc.bookdetail = bookList[indexPath.row].book_details!
        vc.review = bookList[indexPath.row].reviews!
        vc.amazonLinkStr = bookList[indexPath.row].amazon_product_url!
        vc.title = "Book Detail"
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
