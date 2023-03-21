//
//  ViewController.swift
//  SqlLite
//
//  Created by Admin on 19/03/23.
//

import UIKit

class AllStudentViewController: UIViewController {
    @IBOutlet weak var studentTableView: UITableView!
    var db = DBManager()
    var students:[Student] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentTableView.dataSource = self
        studentTableView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        students = db.read()
        studentTableView.reloadData()
    }
    
    @IBAction func goToAddPage(_ sender: UIBarButtonItem) {
        let addPage = self.storyboard?.instantiateViewController(withIdentifier: "AddPageViewController") as! AddPageViewController
        self.navigationController?.pushViewController(addPage, animated: true)
    }
}

extension AllStudentViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = studentTableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell")
        else{return UITableViewCell()}
        cell.textLabel?.text = students[indexPath.row].firstName + " " + students[indexPath.row].lastName
        cell.detailTextLabel?.text = students[indexPath.row].marks.description
        return cell
    }
}

extension AllStudentViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit"){_,_,_ in
            let editVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPageViewController") as! AddPageViewController
            editVC.fName = self.students[indexPath.row].firstName
            editVC.lName = self.students[indexPath.row].lastName
            editVC.marks = self.students[indexPath.row].marks.codingKey.intValue
            editVC.oldData = self.students[indexPath.row]
            editVC.update = true
            self.navigationController?.pushViewController(editVC, animated: true)
        }
        edit.backgroundColor = .blue
        let share = UIContextualAction(style: .normal, title: "Share"){_,_,_ in
            print("Share")
                   UIGraphicsBeginImageContext(self.view.frame.size)
                   self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
                   let image = UIGraphicsGetImageFromCurrentImageContext()
                   UIGraphicsEndImageContext()

            let obj = self.students[indexPath.row]
            let objectsToShare = [obj.firstName, obj.lastName, obj.marks.codingKey.stringValue] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = []
        
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC, animated: true, completion: nil)
        }
        share.backgroundColor = .green
        let actions = UISwipeActionsConfiguration(actions: [edit,share])
        return actions
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            print("Deletee")
           let s = students[indexPath.row]
           db.delete(fname: s.firstName, lname: s.lastName, marks: s.marks)
            students.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
