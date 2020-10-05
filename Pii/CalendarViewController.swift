//
//  CalendarViewController.swift
//  Pii
//
//  Created by 井戸海里 on 2020/10/03.
//

import UIKit
import RealmSwift

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    
    @IBOutlet var tableView:UITableView!
    
    @IBOutlet var goukeiLabel: UILabel!
    
   
    
    var datenow: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        

        // Do any additional setup after loading the view.
    }
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
   
    //セルに値を設定するデータソースメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // セルの内容を取得
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell" ) as! TableViewCell
        
        let realm = try! Realm()
        
        let results = realm.objects(CalendarRealm.self)
        
        print(results)
        
           //歩数を表示
        cell.hosuLabel.text = results[1].hosu
        cell.dateLabel.text = datenow.string(from: Date())
            return cell
        }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
