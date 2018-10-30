//
//  RoundTextView.swift
//  NewYorkTimesDemo
//
//  Created by Ethan Chen on 10/29/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit

class RoundTextView: UITextView {

    override func layoutSubviews() {
        layer.cornerRadius = 8
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
    }

}
