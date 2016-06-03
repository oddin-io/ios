//
//  ClosedPresentationViewController.swift
//  Mirage
//
//  Created by Siena Idea on 20/04/16.
//  Copyright © 2016 Siena Idea. All rights reserved.
//

import UIKit

class ClosedPresentationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddNewPresentationDelegate {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    //inicialização de variaveis para disciplinas
    var idDisc: Int = Discipline().id
    var profileDisc: Int = Discipline().profile
    var nameDisc: String = Discipline().name
    
    //inicialização de variaveis para apresentações
    var id = Presentation().id
    var subject  = Presentation().subject
    
    var presentation = Array<Presentation>()
    var closedPresentation = Array<Presentation>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: StringUtil.pullToRefresh)
        refreshControl.tintColor = ColorUtil.orangeColor
        refreshControl.addTarget(self, action: #selector(ClosedPresentationViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        
        refreshTableView()
    }
    
    override func viewDidAppear(animated: Bool) {
        refreshTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        refreshTableView()
    }
    
    func refreshTableView() {
        
        if tableView == nil {
            return
        } else {
            tableView.delegate = self
            tableView.dataSource = self
            let nib = UINib(nibName: StringUtil.presentationCell, bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: StringUtil.cellIdentifier)
            view.addSubview(tableView)
            
            getPresentation()
            tableView.reloadData()
        }
    }
    
    // pull to refresh
    func refresh() {
        getPresentation()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func getPresentation() {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        let urlPath = Server.presentationURL+"\(idDisc)" + Server.presentaion
        let url = NSURL(string: urlPath)!
        
        let cookieHeaderField = [StringUtil.set_Cookie : StringUtil.key_Value]
        
        let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(cookieHeaderField, forURL: url)
        NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: url, mainDocumentURL: nil)
        
        request.HTTPMethod = StringUtil.httpGET
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        print(cookies)
        
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                
                let presentationJSONData = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    let info : NSArray =  presentationJSONData.valueForKey(StringUtil.presentations) as! NSArray
                    let person : NSArray = info.valueForKey(StringUtil.person) as! NSArray
                    
                    for i in 0 ..< info.count {
                        if self.presentation.count == info.count {
                            return
                        } else {
                            
                            let presentations = Presentation()
                            let persons = Person()
                            
                            for j in 0 ..< person.count {
                                persons.name = person[j].valueForKey(StringUtil.name) as! String
                            }
                            
                            presentations.id = info[i].valueForKey(StringUtil.id) as! Int
                            presentations.person = persons
                            presentations.createdat = info[i].valueForKey(StringUtil.createdat) as! String
                            presentations.status = info[i].valueForKey(StringUtil.status) as! Int
                            presentations.subject = info[i].valueForKey(StringUtil.subject) as! String
                            
                            self.presentation.insert(presentations, atIndex: i)
                        }
                    }
                print(presentationJSONData)
            }
        })
        
        task.resume()
        
        closedPresentation.removeAll()
        
        var auxPresent = Array<Presentation>()
        
        for i in 0 ..< presentation.count {
            var j = 0
            
            if presentation[i].status == 1 {
                auxPresent.insert(presentation[i], atIndex: j)
                j += 1
            }
        }
        
        closedPresentation = auxPresent.reverse()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return closedPresentation.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StringUtil.cellIdentifier, forIndexPath: indexPath) as! PresentationTableViewCell
        
        let present = closedPresentation[ indexPath.row ]
        
        cell.subjectLabel.text = present.subject
        cell.dateLabel.text = DateUtil.date1(present.createdat)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        id = closedPresentation[ indexPath.row ].id
        subject = closedPresentation[ indexPath.row ].subject
        
        let doubtTabBar  = DoubtTabBarViewController()
        
        doubtTabBar.idDisc = idDisc
        doubtTabBar.profileDisc = profileDisc
        doubtTabBar.nameDisc = nameDisc
        
        doubtTabBar.idPresent = id
        doubtTabBar.subjectPresent = subject
        
        self.navigationController?.pushViewController(doubtTabBar, animated: true)
    }
    
    init() {
        super.init(nibName: StringUtil.closedPresentationViewController, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
