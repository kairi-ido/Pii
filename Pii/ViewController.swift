//
//  ViewController.swift
//  Pii
//
//  Created by 井戸海里 on 2020/10/03.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    //ボタンとラベルの宣言
    @IBOutlet var goukeiLabel: UILabel!
    
    @IBOutlet var esaButton: UIButton!
    
    @IBOutlet var okameImage: UIView!
    
    //HealthKitストアを作成する(インスタンス作成）
    let healthStore = HKHealthStore()
    //歩数のみを読みこむ
    let hosu = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
    
    //アプリが起動したら一度だけ呼び出される
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //HealthKitの可用性を確認する
        if HKHealthStore.isHealthDataAvailable() {
                    healthStore.requestAuthorization(toShare: nil, read: hosu) { (success, error) in}

                    //対応しているかどうかの確認
                   print("対応")
                }else {
                    print("非対応")
                }
        
        animation()
        //メソッドの呼び出し
        health()
        // Do any additional setup after loading the view.
    }
    //アニメーションのメソッド
    func animation(){
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseIn, .autoreverse,.repeat], animations: {
            self.okameImage.center.y += 100.0
        }) { _ in
            self.okameImage.center.y -= 100.0
        }
    }
    
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
            //doubleに変換
            step = (query_result as AnyObject).doubleValue(for: HKUnit.count())
            //コンソールに表示
            print(step)
            //メインスレッド対応
            DispatchQueue.main.async {
                //歩数のラベルに表示
                self.goukeiLabel.text = String(step)
                
                if step >= 10.0 {

                                    self.esaButton.backgroundColor = UIColor.brown
                                }

                            
                            }
        }
        //クエリの実行
        healthStore.execute(query)
    }
    //エサを与えるボタンのメソッド
        @IBAction func eat(){


        }


}

