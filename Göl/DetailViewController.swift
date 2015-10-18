//
//  DetailViewController.swift
//  Göl
//
//  Created by Ian Wolterstorff17 on 10/17/15.
//  Copyright (c) 2015 Ian Wolterstorff17. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    var detailItem: League? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: League = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.caption
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

