//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Neosoft on 05/10/23.
//

import UIKit
import CoreData

class DeveloperVC: UIViewController {

    @IBOutlet weak var developersTableView: UITableView!
    @IBOutlet weak var btnplusBar: UIBarButtonItem!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var developers: [Developers] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    private func setUpTableView(){
        developersTableView.delegate = self
        developersTableView.dataSource = self
    }
    
    @IBAction func plusBarItemTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Enter Information", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField1) in
            textField1.placeholder = "Developer Name "
        }
        alertController.addTextField { (textField2) in
            textField2.placeholder = "Experience"
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            
        }

        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            if let devName = alertController.textFields?[0].text,
               let devExp = alertController.textFields?[1].text {
                self.saveData(devName: devName, devExp: Double(devExp) ?? 0.0)
                self.getData()
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func saveData(devName: String, devExp: Double){
        
        guard let context = appDelegate?.persistentContainer.viewContext else{
            return
        }
        let dev = Developers(context: context)
        dev.name = devName
        dev.experience = devExp
        do {
            try context.save()
            print("saved")
        } catch {
            print("error:",error)
        }
    }
    
    func getData(){
        guard let context = appDelegate?.persistentContainer.viewContext else{
            return
        }
        do {
            developers = try context.fetch(Developers.fetchRequest())
            developersTableView.reloadData()
        } catch {
            print("error:",error)
        }
    }
    
}

extension DeveloperVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return developers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = developers[indexPath.row].name
        content.secondaryText = String(developers[indexPath.row].experience)
        cell.contentConfiguration = content
        print(developers.count)
        return cell
    }
}
