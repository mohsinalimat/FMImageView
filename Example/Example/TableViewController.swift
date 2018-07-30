//
//  TableViewController.swift
//  Example
//
//  Created by Trần Quang Minh on 7/5/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit
import FMImageView

class TableViewController: UITableViewController {
    
    private var presentedPhotoIndex: Int?
    
    var vc: FMImageSlideViewController?
    
    let arrayURL = [
        URL(string: "https://media.funmee.jp/medias/6a6bdd8326c225b806021f39e19ed97b1cff8cc5/large.jpg")!,
        URL(string: "https://media.funmee.jp/medias/abbdda21d9c5859871bb88b521f6b4d2ab41601a/large.jpg")!,
        URL(string: "https://media.funmee.jp/medias/2833d8826ab34e3b9304b62bd3b4bda0164f8004/large.JPG")!,
        URL(string: "https://media.funmee.jp/medias/c455f72e904fbe0b22f44084c785f63a5367a54d/large.jpg")!
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayURL.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! ImageCell
        
        ImageLoader.sharedLoader.imageForUrl(url: self.arrayURL[indexPath.row]) { (image, urlString, networkErr) in
            cell.photoImageView.image = image
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentedPhotoIndex = indexPath.row
        let cell = tableView.cellForRow(at: indexPath) as! ImageCell
        self.presentPhotoViewer(fromImageView: cell.photoImageView, index: indexPath.row)
    }
    
}

extension TableViewController {
    private func presentPhotoViewer(fromImageView: UIImageView?, index: Int = 0) {
        self.vc = FMImageSlideViewController(datasource: FMImageDataSource(imageURLs: arrayURL), config: Config(initImageView: fromImageView!, initIndex: index))
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icn_like"), for: .normal)
        button.addTarget(self, action: #selector(target1(_:)), for: .touchUpInside)
        let label = UILabel()
        label.text = "10"
        
        let button1 = UIButton()
        button1.setImage(#imageLiteral(resourceName: "icn_comment"), for: .normal)
        button1.addTarget(self, action: #selector(target2(_:)), for: .touchUpInside)
        let label1 = UILabel()
        label1.text = "20"
        
        vc?.subAreaBottomView.append((button: button, label: label))
        vc?.subAreaBottomView.append((button: button1, label: label1))
        
        
        vc?.view.frame = UIScreen.main.bounds
        
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    
    @objc func target1(_ sender: UIButton) {
        print(#function)
    }
    
    @objc func target2(_ sender: UIButton) {
        print(#function)
    }
}