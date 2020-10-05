//
//  ViewController.swift
//  Pii
//
//  Created by 井戸海里 on 2020/10/03.
//

import UIKit
import HealthKit
import RealmSwift

class ViewController: UIViewController {
    //ボタンとラベルの宣言
    @IBOutlet var goukeiLabel: UILabel!
    
    @IBOutlet var esaButton: UIButton!
    
    @IBOutlet var okameImage: UIView!
    
    @IBOutlet var esaLabel: UILabel!
    
    //HealthKitストアを作成する(インスタンス作成）
    let healthStore = HKHealthStore()
    //歩数のみを読みこむ
    let hosu = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
    
    
    
   
    
    
    //アプリが起動したら一度だけ呼び出される
    override func viewDidLoad() {
        super.viewDidLoad()
        //エサボタンを使えなくする
        esaButton.isEnabled = false
        
        //HealthKitの可用性を確認する
        if HKHealthStore.isHealthDataAvailable() {
                    healthStore.requestAuthorization(toShare: nil, read: hosu) { (success, error) in}

                //HealthKitが対応しているかどうかの確認
                    print("対応")
                }else {
                    print("非対応")
                }
        //メソッドの呼び出し
        
        animation()
       
        health()
        
        addItem()
        
    }
    
    
    func addItem() {
        
        
        
        
        
        
          
    }
    //アニメーションのメソッド
    func animation(){
        
        //飛び跳ねるよ
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseIn, .autoreverse,.repeat], animations: {
            self.okameImage.center.y += 100.0
        }) { _ in
            self.okameImage.center.y -= 100.0
        }
    }
    //ヘルスケアのメソッド
    func health(){
        //
        let type = HKObjectType.quantityType(forIdentifier: .stepCount)!
        //今日の日付を取得
        let now = Date()
        //スタートの日付を設定する
        let startDay = Calendar.current.startOfDay(for: now)
        //取得するデータの開始と終わりを入れる
        let predicate = HKQuery.predicateForSamples(withStart: startDay, end: now)
        //結果を格納するための変数
        var step = 0.0
        
        //クエリを作る、統計データを取得するために使う、数値で計測できるデータのみ、cumulativeSum：合計値
        let query = HKStatisticsQuery(quantityType: type,
                                              quantitySamplePredicate: predicate,
                                              options: .cumulativeSum) { (query, statistics, error) in
            
            let query_result = statistics?.sumQuantity() as Any
            
            if error == nil {
            //doubleに変換
            step = (query_result as AnyObject).doubleValue(for: HKUnit.count())
            //コンソールに表示
            print(step)
                
                
            }
            //メインスレッド対応
            DispatchQueue.main.async {
                //歩数のラベルに表示
                self.goukeiLabel.text = String(step)
                //歩数を達成したら
                if step > 100 {
                                    //エサが与えられるようになる
                                    self.esaButton.isEnabled = true
                                    
                                }
                
                //realmに保存
                let calendarRealm = CalendarRealm()
                calendarRealm.hosu = String(step)
                
                let realm = try! Realm()
                try! realm.write {
                    realm.add(calendarRealm)
                    print("成功",calendarRealm)
                }
                
                            }
        }
        //クエリの実行
        healthStore.execute(query)
    }
    //エサを与えるボタンのメソッド
        @IBAction func eat(){
            
           //とりあえず文字を出す
            esaLabel.alpha = 0.0
            UIView.animate(withDuration: 2.0, delay: 1.0, options: [.curveEaseIn], animations: {
                self.esaLabel.alpha = 1.0
            }, completion: nil)



        }


}

