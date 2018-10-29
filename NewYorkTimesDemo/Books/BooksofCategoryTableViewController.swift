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
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSortButton()
        APIClient.shared.fetchBooksofCategory(category: list_name_encoded) { (books) in
            if let orderPref = UserDefaults.standard.string(forKey: "order") {
                if orderPref == "rank"{
                    self.bookList = books.results!.sorted(by: { Double($0.rank!) < Double($1.rank!) })
                }
                else{
                    self.bookList = books.results!.sorted(by: { Double($0.weeks_on_list!) > Double($1.weeks_on_list!) })
                }
            }
            else{
               self.bookList = books.results!
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    func setUpSortButton() {
        if let orderPref = UserDefaults.standard.string(forKey: "order") {
            if orderPref == "rank" {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "By rank", style: .plain, target: self, action: #selector(addTapped))
            }
            else{
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "By week", style: .plain, target: self, action: #selector(addTapped))
            }
        }
        else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(addTapped))
        }
    }
    @objc func addTapped(){
        let alert = UIAlertController(title: "Sort the books", message: "You can sort the books by number of weeks each book has stayed on list or by the current rank of the book", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "By Week", style: .default , handler:{ (UIAlertAction)in
            self.bookList.sort(by: { Double($0.weeks_on_list!) > Double($1.weeks_on_list!) })
            UserDefaults.standard.set("week", forKey: "order")
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "By week", style: .plain, target: self, action: #selector(self.addTapped))
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "By Rank", style: .default , handler:{ (UIAlertAction)in
            self.bookList.sort(by: { Double($0.rank!) < Double($1.rank!) })
            UserDefaults.standard.set("rank", forKey: "order")
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "By rank", style: .plain, target: self, action: #selector(self.addTapped))
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if bookList.count == 0 {
            self.tableView.setEmptyMessage("Empty")
            self.tableView.isScrollEnabled = false
        } else {
            self.tableView.restore()
            self.tableView.isScrollEnabled = true
        }
        return bookList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as UITableViewCell
        if let bookDetails = self.bookList[indexPath.row].book_details {
            for detail in bookDetails {
                cell.textLabel?.text = detail.title
            }
            
        }
        

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "BookDetail", bundle:nil).instantiateViewController(withIdentifier: "bookDetail") as! BookDetailTableViewController
        vc.bookdetail = bookList[indexPath.row].book_details!
        vc.review = bookList[indexPath.row].reviews!
        vc.amazonLinkStr = bookList[indexPath.row].amazon_product_url!
        vc.title = "Book Detail"
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
