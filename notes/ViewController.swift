//
//  ViewController.swift
//  notes
//
//  Created by Hsuan Lin on 4/20/17.
//  Copyright © 2017 Hsuan Lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    
    @IBOutlet weak var table: UITableView!
    
    //for saving data
    var data:[String] = []
    var file:String!
    //create a reference to a file, it's a string represented the file path
    var selectedRow:Int = -1
    var newRowText:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Hsuan's Notes"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        //call addNote function
        
        self.navigationItem.rightBarButtonItem = addButton
        //put the addbutton in the navigation controller
        
        self.navigationItem.leftBarButtonItem = editButtonItem
        //existing property in navigation controller
        
        let docsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        file = docsDir[0].appending("notes.txt")
        
        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedRow == -1 {
            return
        }
        data[selectedRow] = newRowText
        if newRowText == ""{
            data.remove(at: selectedRow)
        }
        table.reloadData()
        save()
    }

    
    func addNote(){
        if (table.isEditing){
            return
        }
        let name: String = ""
        data.insert(name, at: 0)
        let indexPath: IndexPath = IndexPath(row: 0, section: 0)
        table.insertRows(at: [indexPath], with: .automatic)
        
        table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        
        //save()
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        //recycle cell
        //UITableViewCell()
        
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated)
    }
    
    
    //funciton that delete rows in table
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        data.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .fade)
        save()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("\(data[indexPath.row])")
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView:DetailViewController = segue.destination as! DetailViewController
        selectedRow = table.indexPathForSelectedRow! .row
        detailView.masterView = self
        detailView.setText(t: data[selectedRow])
    }
    
    func save(){
        //UserDefaults.standard.set(data, forKey: "notes")
        //UserDefaults.standard.synchronize()
        
        let newData: NSArray = NSArray(array: data)
        newData.write(toFile: file, atomically: true)
    }
   
    func load(){
        //if let loadedData = UserDefaults.standard.value(forKey: "notes")as?[String]{
        //    data = loadedData
        //    table.reloadData()
        //}
        
        
        if let loadedData = NSArray(contentsOfFile:file) as? [String]{
            data = loadedData
            table.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}




























