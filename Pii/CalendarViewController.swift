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
    
    
    
    
    
    
    var objs: Results<CalendarRealm>!
    
    
    
    private var realm: Realm!
    
   
    
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //背景変更
        self.tableView.backgroundColor = UIColor(red: 44/255, green: 112/255, blue: 51/255, alpha: 1)
        
        do{
                   let realm = try Realm()
            objs = realm.objects(CalendarRealm.self)
                   
            print("realmのデータを取得")
               }catch{

               }
        
        //カスタムセル
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        

           }
        
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
        tableView.reloadData()
            
        }
   
        
        
   

        // Do any additional setup after loading the view.
    
    //セクション内のCellの数を指定する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return objs.count
    }
   
    //セルに値を設定するデータソースメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルの内容を取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell",for: indexPath ) as! TableViewCell
        
        cell.backgroundColor = UIColor(red: 44/255, green: 112/255, blue: 51/255, alpha: 1)
        
        cell.hosuLabel.textColor = UIColor(red: 228/255, green: 245/255, blue: 222/255, alpha: 1)
        cell.dateLabel.textColor = UIColor(red: 228/255, green: 245/255, blue: 222/255, alpha: 1)
        
        
        //歩数を表示(realm)
        cell.hosuLabel?.text = objs[indexPath.row].hosu
        cell.dateLabel?.text = objs[indexPath.row].date
        print("表示完了")
        
        
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

