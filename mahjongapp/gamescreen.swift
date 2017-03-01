//
//  gamescreen.swift
//  mahjongapp
//
//  Created by Takashi Tajimi on 2017/02/22.
//  Copyright © 2017年 Takashi Tajimi. All rights reserved.
//

import UIKit

class gamescreen: UIViewController {
    
    
    var imagepai = [[[UIImage?]]]()
    
    var m=Mahjong()
    static var h=Hand()
    static var sutehai=Array<[Pai]>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        gamescreen.sutehai.append(Array<Pai>())
        gamescreen.h = m.getplayer(id: 0).getHand()
        //牌画像の初期化
        print("aa")
        for i in 0...3{
            imagepai.append([[UIImage?]]())
            for j in 1...9{
                imagepai[i].append([UIImage?]())
                for k in 1...4{
                    var str=""
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
                        default: break;
                        }
                    }
                    
                    str += "_"+String(k)+".gif"
                    //この書き方もしかしたらやばいかも(解決した)
                    imagepai[i][j-1].append(UIImage(named: str))
                }
            }
        }
        print("end initialize photo")
        
        m.haipai()
        updatehandimage()
        updatetsumoimage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //struct Pai型から牌画像を取得 directionは1:上 2:左 3:下 4:右 (playeridに合わせる
    func convertUIImagepai(pai:Pai,direction:Int)->UIImage!{
        if(pai.isnull()){
            return UIImage(named:"toumei.png")
        }
        print(String(pai.suit)+" "+String(pai.rank-1)+" "+String(direction-1))
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
    @IBOutlet weak var ButtonHand14: UIButton!
    //ポンチーカンツモロンリーチボタン
    
    
    var waitbuttontap=true
    //ダブルタップで実行するようにした方がいいかも
    //Mahjongクラスのplayメソッドでやってたことをこっちに移すべき説
    func handButtontapped(index: Int){
        if(waitbuttontap){
            waitbuttontap=false
            m.play(index: index)
            waitbuttontap=true
        }
        updatehandimage()
        updatetsumoimage()
    }
    
    func updatehandimage(){
        ButtonHand1.setImage(convertUIImagepai(pai: m.getplayer(id:0).getHand().getpai()[0], direction: 1), for: .normal)
        ButtonHand2.setImage(convertUIImagepai(pai: m.getplayer(id:0).getHand().getpai()[1], direction: 1), for: UIControlState.normal)
        ButtonHand3.setImage(convertUIImagepai(pai: m.getplayer(id:0).getHand().getpai()[2], direction: 1), for: UIControlState.normal)
        ButtonHand4.setImage(convertUIImagepai(pai: m.getplayer(id:0).getHand().getpai()[3], direction: 1), for: UIControlState.normal)
        ButtonHand5.setImage(convertUIImagepai(pai: m.getplayer(id:0).getHand().getpai()[4], direction: 1), for: UIControlState.normal)
        ButtonHand6.setImage(convertUIImagepai(pai: m.getplayer(id:0).getHand().getpai()[5], direction: 1), for: UIControlState.normal)
        ButtonHand7.setImage(convertUIImagepai(pai: m.getplayer(id:0).getHand().getpai()[6], direction: 1), for: UIControlState.normal)
        ButtonHand8.setImage(convertUIImagepai(pai: m.getplayer(id:0).getHand().getpai()[7], direction: 1), for: UIControlState.normal)
        ButtonHand9.setImage(convertUIImagepai(pai: m.getplayer(id:0).getHand().getpai()[8], direction: 1), for: UIControlState.normal)
        ButtonHand10.setImage(convertUIImagepai(pai: m.getplayer(id:0).getHand().getpai()[9], direction: 1), for: UIControlState.normal)
        ButtonHand11.setImage(convertUIImagepai(pai: m.getplayer(id:0).getHand().getpai()[10], direction: 1), for: UIControlState.normal)
        ButtonHand12.setImage(convertUIImagepai(pai: m.getplayer(id:0).getHand().getpai()[11], direction: 1), for: UIControlState.normal)
        ButtonHand13.setImage(convertUIImagepai(pai: m.getplayer(id:0).getHand().getpai()[12], direction: 1), for: UIControlState.normal)
    }
    func updatetsumoimage(){
        ButtonHand14.setImage(convertUIImagepai(pai:gamescreen.h.getpai()[13],direction: 1), for: .normal)
    }
    @IBAction func tappedHand1(_ sender: Any) {
        handButtontapped(index: 1)
    }
    @IBAction func tappedHand2(_ sender: Any) {
        handButtontapped(index: 2)
    }
    @IBAction func tappedHand3(_ sender: Any) {
        handButtontapped(index: 3)
    }
    @IBAction func tappedHand4(_ sender: Any) {
        handButtontapped(index: 4)
    }
    @IBAction func tappedHand5(_ sender: Any) {
        handButtontapped(index: 5)
    }
    @IBAction func tappedHand6(_ sender: Any) {
        handButtontapped(index: 6)
    }
    @IBAction func tappedHand7(_ sender: Any) {
        handButtontapped(index: 7)
    }
    @IBAction func tappedHand8(_ sender: Any) {
        handButtontapped(index: 8)
    }
    @IBAction func tappedHand9(_ sender: Any) {
        handButtontapped(index: 9)
    }
    @IBAction func tappedHand10(_ sender: Any) {
        handButtontapped(index: 10)
    }
    @IBAction func tappedHand11(_ sender: Any) {
        handButtontapped(index: 11)
    }
    @IBAction func tappedHand12(_ sender: Any) {
        handButtontapped(index: 12)
    }
    @IBAction func tappedHand13(_ sender: Any) {
        handButtontapped(index: 13)
    }
    @IBAction func tappedHand14(_ sender: Any) {
        handButtontapped(index: 14)
    }
}
