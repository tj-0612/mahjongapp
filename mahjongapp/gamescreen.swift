//
//  gamescreen.swift
//  mahjongapp
//
//  Created by Takashi Tajimi on 2017/02/22.
//  Copyright © 2017年 Takashi Tajimi. All rights reserved.
//

import UIKit

class gamescreen: UIViewController {
    
    
    var imagepai:[[[UIImage?]]] = [[[]]]
    
    var m = Mahjong()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //牌画像の初期化
        for i in 0...3{
            for j in 1...9{
                for k in 1...4{
                    var str:String
                    if(i<3){
                        switch i{
                        case 0: str="p_ms"
                        case 1: str="p_ps"
                        case 2: str="p_ss"
                        default:break;
                        }
                        str+=String(j)
                    }else{
                        switch j{
                        case 1: str="p_ji_e"
                        case 2: str="p_ji_s"
                        case 3: str="p_ji_w"
                        case 4: str="p_ji_n"
                        case 5: str="p_no"
                        case 6: str="p_ji_h"
                        case 7: str="p_ji_c"
                        }
                    }
                    
                    str += "_"+String(k)+".gif"
                    //この書き方もしかしたらやばいかも
                    imagepai[i][j-1][k-1]=UIImage(named: str)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //struct Pai型から牌画像を取得 directionは1:上 2:左 3:下 4:右 (playeridに合わせる
    func convertimagepai(pai:Pai,direction:Int)->UIImage!{
        return imagepai[pai.suit][pai.rank-1][direction-1]
    }
    //左から順に1~13
    @IBOutlet weak var ButtonHand1: UIButton!
    @IBOutlet weak var ButtonHand2: UIButton!
    @IBOutlet weak var ButtonHand3: UIButton!
    @IBOutlet weak var ButtonHand4: UIButton!
    @IBOutlet weak var ButtonHand5: UIButton!
    @IBOutlet weak var ButtonHand6: UIButton!
    @IBOutlet weak var ButtonHand7: UIButton!
    @IBOutlet weak var ButtonHand8: UIButton!
    @IBOutlet weak var ButtonHand9: UIButton!
    @IBOutlet weak var ButtonHand10: UIButton!
    @IBOutlet weak var ButtonHand11: UIButton!
    @IBOutlet weak var ButtonHand12: UIButton!
    @IBOutlet weak var ButtonHand13: UIButton!
    
    
    //ダブルタップで実行するようにした方がいいかも
    @IBAction func tappedHand1(_ sender: Any) {
        m.play(index: 1)
    }
    @IBAction func tappedHand2(_ sender: Any) {
        m.play(index: 2)
    }
    @IBAction func tappedHand3(_ sender: Any) {
        m.play(index: 3)
    }
    @IBAction func tappedHand4(_ sender: Any) {
        m.play(index: 4)
    }
    @IBAction func tappedHand5(_ sender: Any) {
        m.play(index: 5)
    }
    @IBAction func tappedHand6(_ sender: Any) {
        m.play(index: 6)
    }
    @IBAction func tappedHand7(_ sender: Any) {
        m.play(index: 7)
    }
    @IBAction func tappedHand8(_ sender: Any) {
        m.play(index: 8)
    }
    @IBAction func tappedHand9(_ sender: Any) {
        m.play(index: 9)
    }
    @IBAction func tappedHand10(_ sender: Any) {
        m.play(index: 10)
    }
    @IBAction func tappedHand11(_ sender: Any) {
        m.play(index: 11)
    }
    @IBAction func tappedHand12(_ sender: Any) {
        m.play(index: 12)
    }
    @IBAction func tappedHand13(_ sender: Any) {
        m.play(index: 13)
    }
}
