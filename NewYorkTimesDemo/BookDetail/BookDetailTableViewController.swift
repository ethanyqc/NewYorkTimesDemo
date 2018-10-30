//
//  BookDetailTableViewController.swift
//  NewYorkTimesDemo
//
//  Created by Ethan Chen on 10/28/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit

class BookDetailTableViewController: UITableViewController {
    var bookdetail : [BookDetail] = []
    var review : [Review] = []
    var amazonLinkStr = ""
    @IBOutlet weak var bookTitle: UITextView!
    @IBOutlet weak var bookAuthor: UITextView!
    @IBOutlet weak var bookDescrpt: UITextView!
    @IBOutlet weak var bookLink: UITextView!
    @IBOutlet weak var amazonLink: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //update ui, if empty, show as Not Avaliable
        amazonLink.text = (amazonLinkStr == "") ? "Not Avaliable" : amazonLinkStr
        if let detail = bookdetail.first { //unwrap book details
            //update ui
            bookTitle.text = detail.title
            bookAuthor.text = detail.author
            bookDescrpt.text = detail.description
        }
        if let bookReviewLink = review.first {//unwrap review links
            //update ui, if empty, show as Not Avaliable
           bookLink.text = (bookReviewLink.book_review_link == "") ? "Not Avaliable" : bookReviewLink.book_review_link
        }

    }
    //change the ui of header view
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        header?.textLabel?.textColor = UIColor.black
    }



}
