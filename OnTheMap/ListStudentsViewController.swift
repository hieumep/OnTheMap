//
//  ListStudentsViewController.swift
//  On The Map
//
//  Created by Hieu Vo on 1/23/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import UIKit

class ListStudentsViewController : UITableViewController, Refeshable{
    
    @IBOutlet var studentTableView: UITableView!
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = false
        tabBarController?.tabBar.hidden = false
        activityIndicator = UIActivityIndicatorView(frame: view.frame)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        loadStudentObjects()
       
    }
    
    func refesh() {
        loadStudentObjects()
    }    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DBStudent.sharedInstance().studentObjects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        /* Get cell type */
        let cellReuseIdentifier = "studentCell"
        let studentObject = DBStudent.sharedInstance().studentObjects[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! ListStudentViewcell
        
        /* Set cell defaults */
        cell.nameLabel.text = "\(studentObject.firstName) \(studentObject.lastName)"
        cell.pinImage!.image = UIImage(named: "Pin")
        cell.pinImage.contentMode = .ScaleAspectFill
        cell.mediaURLLabel.text = studentObject.mediaURL
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let studentObject = DBStudent.sharedInstance().studentObjects[indexPath.row]
        let urlString = studentObject.mediaURL
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: urlString)!)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func displayError(error: NSError?) {
        stopActivityIndicator()
        let alertVC = Alert(controller: self, message: error?.localizedDescription)
        alertVC.present()
    }
    
    func startActivityIndicator(){
        for view in self.view.subviews{
            view.alpha = 0.3
        }
        self.view.addSubview(activityIndicator)
        self.view.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator(){
        for view in self.view.subviews{
            view.alpha = 1
        }
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    func loadStudentObjects (){
        startActivityIndicator()
        DBClient.sharedInstance().getListStudent(){(success,error) in
            if !success{
                self.displayError(error)
            }else{
                self.studentTableView.reloadData()
                self.stopActivityIndicator()
            }
        }
    }

}
