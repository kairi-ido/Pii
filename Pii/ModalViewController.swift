//
//  ModalViewController.swift
//  Pii
//
//  Created by 井戸海里 on 2020/10/15.
//

import UIKit

class ModalViewController: UIViewController {
    
    var number:Int!
    
    @IBOutlet var kotoriImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        // Do any additional setup after loading the view.
        
        number = Int.random(in: 0...9)
        
        if number > 5 {
            kotoriImageView.image = UIImage(named: "sakurabuncyo")
        }else {
            kotoriImageView.image = UIImage(named: "kiui")
        }
        

    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
        
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
