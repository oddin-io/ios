//
//  MenuTableViewController.swift
//  Mirage
//
//  Created by Siena Idea on 26/05/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var configLabel: UILabel!
    @IBOutlet weak var exitLabel: UILabel!
    @IBOutlet weak var imageViewConfig: UIImageView!
    @IBOutlet weak var imageViewExit: UIImageView!
    @IBOutlet weak var optionsLabel: UILabel!
    
    var email = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameLabel.text = "User Name"
        loginLabel.text = "email"
        configLabel.text = "Configurações"
        optionsLabel.text = "Opções"
        exitLabel.text = "Sair"
        
        imageViewExit.image = ImageUtil.imageExitButton
        imageViewConfig.image = ImageUtil.imageConfigButton
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

}
