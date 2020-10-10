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
    
    
    var hosuArray:[CalendarRealm] = []
    
    var calendarRealm : Results<CalendarRealm>!
    
    let ViewSegueIdentifier = "toView"
    
    private var realm: Realm!
    
   
    
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        //realmのインスタンス作成
        realm = try! Realm()
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
        
        
   

        // Do any additional setup after loading the view.
    
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let objs: Results<CalendarRealm> = realm.objects(CalendarRealm.self)
        return objs.count
    }
   
    //セルに値を設定するデータソースメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの内容を取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell",for: indexPath ) as! TableViewCell
        
        let objs: Results<CalendarRealm>  = realm.objects(CalendarRealm.self)
        //歩数を表示(realm)
        cell.hosuLabel?.text = objs[indexPath.row].hosu
        cell.dateLabel?.text = objs[indexPath.row].date
        
        
        
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

