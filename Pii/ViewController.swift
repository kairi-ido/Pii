//
//  ViewController.swift
//  Pii
//
//  Created by 井戸海里 on 2020/10/03.
//

import UIKit
import HealthKit
import RealmSwift
import Lottie

class ViewController: UIViewController {
   
    
    //ボタンとラベルの宣言
    @IBOutlet var goukeiLabel: UILabel!
    
    @IBOutlet var esaButton: UIButton!
    
    @IBOutlet var calendarButton: UIButton!
    
    
    
    @IBOutlet var imageView:UIImageView!
    
    @IBOutlet var onakaLabel: UILabel!
    
    @IBOutlet var manpukuLabel: UILabel!
    
    @IBOutlet var dateplusLabel: UILabel!
    
    @IBOutlet var huki: UIImageView!
    
    @IBOutlet var dasi: UIImageView!
    
    
    
    @IBOutlet var onpu: UIImageView!
    
    
    
    //日付を数えることができる変数
    var number: Int = 0
    //続けた日にちを確認するもの 
    let saveData: UserDefaults = UserDefaults.standard
    // userdefaultsを用意しておく
    let UD = UserDefaults.standard
    
    
    let type = HKObjectType.quantityType(forIdentifier: .stepCount)!
    //今日の日付を取得
    let now = Date()
    
    //結果を格納するための変数
    var step = 0.0
    
    
    
    //HealthKitストアを作成する(インスタンス作成）
    let healthStore = HKHealthStore()
    //歩数のみを読みこむ
    let hosu = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
    
    
    
    //日本時間を設定
    
    //日付判定結果
    var judge = Bool()

    
    //AnimationViewを宣言
    var animationView = AnimationView()
    
    //アプリが起動したら一度だけ呼び出される
    override func viewDidLoad() {
        super.viewDidLoad()
        //ボタンを各丸にする
        calendarButton.layer.cornerRadius = 30
        esaButton.layer.cornerRadius = 30
        //「お腹すいた」ラベルを表示する
        onakaLabel.isHidden = false
        //吹き出し１を表示
        huki.isHidden = false
        //「満腹」ラベルを非表示にする
        manpukuLabel.isHidden = true
        //吹き出し２を非表示
        dasi.isHidden = true
        
        
        onpu.isHidden = true
        
        //HealthKitの可用性を確認する
        if HKHealthStore.isHealthDataAvailable() {
                    healthStore.requestAuthorization(toShare: nil, read: hosu) { (success, error) in}

                //HealthKitが対応しているかどうかの確認
                    print("対応")
                }else {
                    print("非対応")
                }
        
        //フォアグランド対応
        NotificationCenter.default.addObserver(
                   self,
                   selector: #selector(ViewController.viewWillEnterForeground(_:)),
                   name: UIApplication.didBecomeActiveNotification,
                   object: nil)
        NotificationCenter.default.addObserver(
                   self,
                   selector: #selector(ViewController.viewWillEnterForeground1(_:)),
                   name: UIApplication.didBecomeActiveNotification,
                   object: nil)
        NotificationCenter.default.addObserver(
                   self,
                   selector: #selector(ViewController.viewWillEnterForeground2(_:)),
                   name: UIApplication.didBecomeActiveNotification,
                   object: nil)
       
        
        //メソッドの呼び出し
      
        health()
        
        date1()
       
        animation()
        
        Achievement()
        
    }
   
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
       }
   
    
    @objc func viewWillEnterForeground(_ notification: Notification?) {
            if (self.isViewLoaded && (self.view.window != nil)) {
                print("フォアグラウンド")
                self.health()
            }
    }
    @objc func viewWillEnterForeground1(_ notification: Notification?) {
            if (self.isViewLoaded && (self.view.window != nil)) {
                print("フォアグラウンド1")
                self.Achievement()
            }
    }
    @objc func viewWillEnterForeground2
    (_ notification: Notification?) {
            if (self.isViewLoaded && (self.view.window != nil)) {
                print("フォアグラウンド1")
                self.date1()
            }
    }
    //日時経過チェック
    @objc func date1(){
        
        //現在のカレンダ情報を設定
        let calender = Calendar(identifier: .gregorian)
        let now_day = now + (60 * 60 * 9)
        
            //UserDefaultsにtodayキーに値があるか判定、あるならば
            if UD.object(forKey: "today") != nil {
            //最初にpast_dayにすでに保存してあった日時情報を取り出して代入
            let past_day = UD.object(forKey: "today") as! Date
            print(past_day)
            //nowに現在の日付を代入
            let now1 = calender.dateComponents([.year,.month,.day], from: now_day)
            print(now_day)
            //pastにpast_dayの日時情報を使って過去の日付を代入
            let past = calender.dateComponents([.year,.month,.day], from: past_day)
           
            print(past)
            print(now1)
            

             //日にちが変わっていた場合
             if now1 != past {
                judge = true
                debugPrint("変わっていた")
                    //保存したものを取り出す
                    self.number = saveData.object(forKey: "d") as! Int
                    //取り出したものから＋１する
                    self.number = self.number + 1
                    
                
                //コンソールに表示
                print("成功",self.number)
                UD.set(now_day, forKey: "today")
                
                print("完了")
                
             }
             else {
                
                judge = false
                UD.set(now_day, forKey: "today")
                debugPrint("そのまま")
               
             }
         }else {
            judge = true
           //今の日時を保存
            UD.set(now_day, forKey: "today")
            //新しい値を保存する
            self.saveData.set(self.number, forKey: "d")
            print("保存できた")
        }
        //モデルクラスをインスタンス化
        let calendarRealm = CalendarRealm()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
                    
        calendarRealm.hosu = String(step)
        calendarRealm.date = formatter.string(from: now)
                   
                    print(calendarRealm)
        /* 日付が変わった場合はtrueの処理 */
             if judge == true {
                
                // Realmインスタンス取得
                let realm = try! Realm()
                         
                // DB登録処理
                try! realm.write {
                    realm.add(calendarRealm)
                    print("登録完了")
                }
                  judge = false
             }
             else {
            print("更新処理")
                // Realmインスタンス取得
                let realm = try! Realm()
                
                let data = realm.objects(CalendarRealm.self).last
                
                try! realm.write {
                    data?.hosu = String(step)
                    data?.date = formatter.string(from:now)
                    print("更新完了")
                }
             }
        
    }
    
    //オカメちゃんのアニメーションのメソッド
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
    //300歩の対応メソッド
   @objc func Achievement(){
        //歩数を達成したら
    if step >= 3000{
            //エサが与えられるようになる
            self.esaButton.isEnabled = true
            print("3000")
                            
    }else {
        print("未到達")
        self.esaButton.isEnabled = false
    }
        
    }
    
    //エサを与えるボタンのメソッド
        @IBAction func eat(){
            
            imageView.isHidden = true
            
            goukeiLabel.isHidden = true
            
            dateplusLabel.isHidden = true

                    addAnimationView()
            
            //「お腹すいた」ラベルを非表示にする
            onakaLabel.isHidden = true
            
            huki.isHidden = true
           
            //エサボタンを使えなくする
            esaButton.isEnabled = false
        }
    //ごはんを食べるアニメーション
    func addAnimationView() {
        let animationView = AnimationView(name: "animation2")
                animationView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
                animationView.center = self.view.center
                animationView.loopMode = .playOnce
                animationView.contentMode = .scaleAspectFit
                animationView.animationSpeed = 1

                view.addSubview(animationView)
        
        animationView.play { finished in
                    if finished {
                        animationView.removeFromSuperview()
                        
                        self.imageView.isHidden = false
                        self.animation()
                        
                        //「満腹」ラベルを表示する
                        self.manpukuLabel.isHidden = false
                        
                        self.dasi.isHidden = false
                        
                        self.onpu.isHidden = false
                        
                        self.goukeiLabel.isHidden = false
                        
                        self.dateplusLabel.isHidden = false
                        
                    }
                }
    }
       
    }

    


