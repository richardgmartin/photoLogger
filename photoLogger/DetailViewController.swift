//
//  ViewController.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-07-19.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCellID")
        return cell!
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    



}

