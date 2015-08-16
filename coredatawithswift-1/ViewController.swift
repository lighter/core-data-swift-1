//
//  ViewController.swift
//  coredatawithswift-1
//
//  Created by lighter on 2015/8/9.
//  Copyright (c) 2015年 Lighter. All rights reserved.
//

import UIKit
import CoreData // import core data

class ViewController: UIViewController,  UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    //var lists = [String]()
    var lists = [NSManagedObject]()

    @IBAction func add(sender: AnyObject) {
        var alert = UIAlertController(title: "加入新的東東", message: "加入點東西", preferredStyle: .Alert)
        let save = UIAlertAction(title: "儲存", style: .Default) {
            (action: UIAlertAction!) -> Void in
                let textField = alert.textFields![0] as! UITextField
                //self.lists.append(textField.text)
                self.saveList(textField.text)

                self.tableView.reloadData()
        }

        let cancel = UIAlertAction(title: "取消", style: .Default) {
            (action: UIAlertAction!) -> Void in
        }

        alert.addTextFieldWithConfigurationHandler {(textField: UITextField!) -> Void in}

        alert.addAction(save)
        alert.addAction(cancel)

        presentViewController(alert, animated: true, completion: nil)
    }

    func saveList(list: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        let managedContext = appDelegate.managedObjectContext!

        let entity = NSEntityDescription.entityForName("Somthing", inManagedObjectContext: managedContext)

        let somthing = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)

        somthing.setValue(list, forKey: "detail")

        var error: NSError?

        if !managedContext.save(&error) {
            println("失敗囉~ \(error), \(error?.userInfo)")
        }

        lists.append(somthing)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "第一次CoreData"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        let managedContext = appDelegate.managedObjectContext

        let fetchRequest = NSFetchRequest(entityName: "Somthing")

        var error: NSError?

        let fetchedResult = managedContext?.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]


        if let results = fetchedResult {
            lists = results
        }
        else {
            println("Fetch 失敗囉~ \(error), \(error!.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        //cell.textLabel!.text = lists[indexPath.row]

        let list = lists[indexPath.row]
        cell.textLabel!.text = list.valueForKey("detail") as? String
        return cell
    }
}

