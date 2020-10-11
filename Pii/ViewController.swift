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
    
    @IBOutlet var calendarButton: UIButton!
    
    @IBOutlet var esaLabel: UILabel!
    
    @IBOutlet var imageView:UIImageView!
    
    @IBOutlet var onakaLabel: UILabel!
    
    @IBOutlet var manpukuLabel: UILabel!
    
    @IBOutlet var dateplusLabel: UILabel!
    
    
    
    
    
    //日付を数えることができる変数
    var number: Int = 0
    //続けた日にちを確認するもの 
    let saveData: UserDefaults = UserDefaults.standard
    // userdefaultsを用意しておく
    let UD = UserDefaults.standard
    
    //
    let type = HKObjectType.quantityType(forIdentifier: .stepCount)!
    //今日の日付を取得
    let now = Date()
    
    //結果を格納するための変数
    var step = 0.0
    
    
    
    //HealthKitストアを作成する(インスタンス作成）
    let healthStore = HKHealthStore()
    //歩数のみを読みこむ
    let hosu = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])

    
   
    
    
    //アプリが起動したら一度だけ呼び出される
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //ボタンを各丸にする
        calendarButton.layer.cornerRadius = 30
        esaButton.layer.cornerRadius = 30
        //「お腹すいた」ラベルを表示する
        onakaLabel.isHidden = false
        //「満腹」ラベルを非表示にする
        manpukuLabel.isHidden = true
        
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
        
        NotificationCenter.default.addObserver(
                   self,
                   selector: #selector(ViewController.viewWillEnterForeground(_:)),
                   name: UIApplication.willEnterForegroundNotification,
                   object: nil)
        NotificationCenter.default.addObserver(
                   self,
                   selector: #selector(ViewController.viewWillEnterForeground2(_:)),
                   name: UIApplication.willEnterForegroundNotification,
                   object: nil)
       
        //メソッドの呼び出し
        
    
        self.health()
        self.judgeDate()
        self.animation()
        self.Achievement()
        
    }
   
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
       }
    
    @objc func viewWillEnterForeground(_ notification: Notification?) {
            if (self.isViewLoaded && (self.view.window != nil)) {
                print("フォアグラウンド1")
                self.health()
            }
        }
    @objc func viewWillEnterForeground2(_ notification: Notification?) {
            if (self.isViewLoaded && (self.view.window != nil)) {
                print("フォアグラウンド2")
                self.judgeDate()
            }
    
    }
    
    

    
   
    
   
    
    //アニメーションのメソッド
    @objc func animation(){
        //パラパラ漫画にする
        imageView.animationImages = [UIImage(named: "pii1"),UIImage(named: "pii2")]as? [UIImage]
        imageView.animationDuration =  1
        imageView.startAnimating()
    }
    //ヘルスケアのメソッド
    @objc func health(){
        
       
        //スタートの日付を設定する
        let startDay = Calendar.current.startOfDay(for: now)
        //取得するデータの開始と終わりを入れる
        let predicate = HKQuery.predicateForSamples(withStart: startDay, end: now)
        
        
        
        //クエリを作る、統計データを取得するために使う、数値で計測できるデータのみ、cumulativeSum：合計値
        let query = HKStatisticsQuery(quantityType: self.type,
                                              quantitySamplePredicate: predicate,
                                              options: .cumulativeSum) { [self] (query, statistics, error) in
            
            let query_result = statistics?.sumQuantity() as Any
            //記録がないのをnilとするならば
            if error == nil {
            //doubleに変換
            step = (query_result as AnyObject).doubleValue(for: HKUnit.count())
            //コンソールに表示
            print(step)
                
                
            }
            //メインスレッド対応
            DispatchQueue.main.async { [self] in
                //歩数のラベルに表示
                self.goukeiLabel.text = "今日の歩数は"+String(step)+"歩"
                
                }
                
                
            }
        
        //クエリの実行
        healthStore.execute(query)
        
        }
    
    
    //日付判定関数
   @objc func judgeDate(){
    
        //現在のカレンダ情報を設定
        let calender = Calendar.current
        //日本時間を設定
        let now_day = Date(timeIntervalSinceNow: 60 * 60 * 9)
        //日付判定結果
        var judge = Bool()

        // 日時経過チェック
        //UserDefaultsにtodayキーに値があるか判定、あるならば
        if UD.object(forKey: "today") != nil {
            //最初にpast_dayにすでに保存してあった日時情報を取り出して代入
             let past_day = UD.object(forKey: "today") as! Date
            //nowに現在の日付を代入
             let now = calender.component(.day, from: now_day)
            //pastにpast_dayの日時情報を使って過去の日付を代入
             let past = calender.component(.day, from: past_day)

             //日にちが変わっていた場合
             if now != past {
                judge = true
                debugPrint("変わっていた")
             }
             else {
                judge = false
                debugPrint("そのまま")
             }
         }else {
            judge = true
            /* 今の日時を保存 */
            UD.set(now_day, forKey: "today")
        }
        
       
        //realm関係
        //モデルクラスをインスタンス化
        let calendarRealm = CalendarRealm()
    
    var maxId: Int { return try! Realm().objects(CalendarRealm.self).sorted(byKeyPath: "id").last?.id ?? 0 }
    
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
            
        calendarRealm.hosu = String(step)
        calendarRealm.date = formatter.string(from: now)
        
        
        let realm = try! Realm()
        
       
        
       
        //日付がことなったら
        if judge == true {
                
                //新しく登録する、idを＋１する
                try! realm.write {
                    realm.add(calendarRealm)
                    print("成功",calendarRealm)
                    debugPrint("日付変更処理が実行された！")
                }
                
                  judge = false
             }
        //日付が一緒なら、idのラスト
             else {
                
                //realmの更新
                let hosuData = realm.objects(CalendarRealm.self).filter("id == \(maxId)").last
                
                try! realm.write{
                    hosuData?.hosu = String(step)
                    hosuData?.date = formatter.string(from: now)
                   
                    debugPrint("更新の処理が実行された")
                    print(hosuData as Any)
                }
             }
    
   }
    
   @objc func Achievement(){
        //歩数を達成したら
        if step >= 0 {
                            //エサが与えられるようになる
                            self.esaButton.isEnabled = true
            
                            
                        }
        
    }
    
    
    //エサを与えるボタンのメソッド
        @IBAction func eat(){
            
            //エサを与えたら・・
            
           //とりあえず文字を出す（アニメーション）
            esaLabel.alpha = 0.0
            UIView.animate(withDuration: 2.0, delay: 1.0, options: [.curveEaseIn], animations: {
                self.esaLabel.alpha = 1.0
            }, completion: nil)
            
            //「お腹すいた」ラベルを非表示にする
            onakaLabel.isHidden = true
            //「満腹」ラベルを表示する
            manpukuLabel.isHidden = false
            
            
        
                
                //取り出したものから＋１する
                self.number = self.number + 1
                
                
                //新しい値を保存する
                self.saveData.set(self.number, forKey: "d")
                
                //コンソールに表示
                print("成功",self.number)
                
                //保存したものを取り出す
                self.number = saveData.object(forKey: "d") as! Int
                
                //ラベルに表示する
                self.dateplusLabel.text = String(self.number) + "日目"
                
           
            esaButton.isEnabled = false
          

        }
    //とりあえず、歩数を日付確認するための更新ボタンを作ってみた
    @IBAction func load(){
      
        
        
        print(self.step,"更新成功")
    }
    
    }


