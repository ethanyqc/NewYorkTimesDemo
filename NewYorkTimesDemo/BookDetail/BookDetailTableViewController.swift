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
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookDescrpt: UITextView!
    @IBOutlet weak var bookLink: UITextView!
    @IBOutlet weak var amazonLink: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amazonLink.text = amazonLinkStr
        for x in bookdetail {
            bookTitle.text = x.title
            bookAuthor.text = x.author
            bookDescrpt.text = x.description
        }
        for y in review {
            bookLink.text = y.book_review_link
        }

    }



}
