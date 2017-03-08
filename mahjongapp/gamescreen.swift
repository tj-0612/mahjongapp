//
//  gamescreen.swift
//  mahjongapp
//
//  Created by Takashi Tajimi on 2017/02/22.
//  Copyright © 2017年 Takashi Tajimi. All rights reserved.
//

import UIKit

class gamescreen: UIViewController {
    
    
    @IBOutlet weak var shantenlabel: UILabel!
    @IBOutlet weak var tsumolabel: UILabel!
    @IBOutlet weak var yamalabel: UILabel!
    @IBOutlet weak var kyokusuulabel: UILabel!

    var imagepai = [[[UIImage?]]]()
    
    //mahjongクラスをこっちにうつすならここはいらない
    /*var m=Mahjong()
    static var h=Hand()
    static var sutehai=Array<[Pai]>()
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        //gamescreen.sutehai.append(Array<Pai>())
        //gamescreen.h = m.getplayer(id: 0).getHand()
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
        
        yamaInit()
        kyokusuulabel.text="東"+String(kyokusuu)+" "+String(kyokusuu)
        haipai()
        updatehandimage()
        updatetsumoimage()
        setlabel()
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
        //print(String(pai.suit)+" "+String(pai.rank-1)+" "+String(direction-1))
        return imagepai[pai.suit][pai.rank-1][direction-1]
    }
    @IBOutlet var sutehai0: [UIImageView]!

    
    
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
    @IBOutlet weak var ButtonPon: UIButton!
    @IBOutlet weak var ButtonChi: UIButton!
    @IBOutlet weak var ButtonKan: UIButton!
    @IBOutlet weak var ButtonRon: UIButton!
    @IBOutlet weak var ButtonTsumo: UIButton!

    //ポンチーカンツモロンリーチボタン
    
    
    var waitbuttontap=true
    //ダブルタップで実行するようにした方がいいかも
    //Mahjongクラスのplayメソッドでやってたことをこっちに移すべき説
    func handButtontapped(index: Int){
        //ボタンの入力待ちなら
        if(waitbuttontap){
            waitbuttontap=false
            //入力に対する処理を行う
            play(index: index)
            waitbuttontap=true
        }
        updatehandimage()
        updatetsumoimage()
        addsutehaiimage()
        setlabel()
    }
    
    //mahjongクラスをうつすなら書き換え
    /*
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
    }*/
    func addsutehaiimage(){
        for i in 1...player[0].getHand().getsutehai().count{
            if(i>sutehai0.count){
                break
            }
            sutehai0[i-1].image=convertUIImagepai(pai: player[0].getHand().getsutehai()[i-1], direction: 1)
        }
    }
    func setlabel(){
        yamalabel.text="山"+String(yama.count)
        tsumolabel.text="ツモ"+String(junme)
        shantenlabel.text="s"+String(player[0].getHand().getshanten().getShanten())
    }
    func updatehandimage(){
        ButtonHand1.setImage(convertUIImagepai(pai: player[0].getHand().getpai()[0], direction: 1), for: .normal)
        ButtonHand2.setImage(convertUIImagepai(pai: player[0].getHand().getpai()[1], direction: 1), for: UIControlState.normal)
        ButtonHand3.setImage(convertUIImagepai(pai: player[0].getHand().getpai()[2], direction: 1), for: UIControlState.normal)
        ButtonHand4.setImage(convertUIImagepai(pai: player[0].getHand().getpai()[3], direction: 1), for: UIControlState.normal)
        ButtonHand5.setImage(convertUIImagepai(pai: player[0].getHand().getpai()[4], direction: 1), for: UIControlState.normal)
        ButtonHand6.setImage(convertUIImagepai(pai: player[0].getHand().getpai()[5], direction: 1), for: UIControlState.normal)
        ButtonHand7.setImage(convertUIImagepai(pai: player[0].getHand().getpai()[6], direction: 1), for: UIControlState.normal)
        ButtonHand8.setImage(convertUIImagepai(pai: player[0].getHand().getpai()[7], direction: 1), for: UIControlState.normal)
        ButtonHand9.setImage(convertUIImagepai(pai: player[0].getHand().getpai()[8], direction: 1), for: UIControlState.normal)
        ButtonHand10.setImage(convertUIImagepai(pai: player[0].getHand().getpai()[9], direction: 1), for: UIControlState.normal)
        ButtonHand11.setImage(convertUIImagepai(pai: player[0].getHand().getpai()[10], direction: 1), for: UIControlState.normal)
        ButtonHand12.setImage(convertUIImagepai(pai: player[0].getHand().getpai()[11], direction: 1), for: UIControlState.normal)
        ButtonHand13.setImage(convertUIImagepai(pai: player[0].getHand().getpai()[12], direction: 1), for: UIControlState.normal)
    }
    func updatetsumoimage(){
        ButtonHand14.setImage(convertUIImagepai(pai:player[0].getHand().getpai()[13],direction: 1), for: UIControlState.normal)
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
    @IBAction func tappedTsumo(_ sender: Any) {
        play(index:20)
    }

    
    //mahjongクラス全部コピペ private修飾子は最終的には消すべき
    private var yama = Array(repeating: Pai(rank: -1,suit: -1),count:136);
    private var bahuu = 1;
    private var oya = 0
    private var player = [Player(id: 0),Player(id:1),Player(id:2),Player(id:3)];
    private var countkan=0;
    private var yamanokori=136
    private var dora = Array<Pai>();
    private var junme=0
    private var richijunme=[0,0,0,0]
    private var kyokusuu=0
    
    private var renchancount=0
    private var kyotaku=0 //供託
    
    public func getplayer(id:Int)->Player{
        return player[id]
    }
    private var nakikind=[0,0,0,0]
    

    private func endgame(){
        
    }
    public func nextgame(renchan: Bool){
        
        
        yamaInit()
        if(!renchan){
            if(oya==3 && bahuu==2){
                endgame()
                return
            }
            oya += 1
            if(oya==4){
                oya=0
                bahuu+=1
            }
        }else{
            renchancount+=1
        }
        haipai()
    }
    //山生成
    public func yamaInit(){
        self.yamanokori = 136
        self.junme=0
        kyokusuu+=1
        var painum = Array(repeating: 4,count:34)
        for i in 0 ... 135{
            var rand:Int;
            while(true){
                print("a")
                rand=(Int)(arc4random_uniform(34));
                if(painum[rand]>0){
                    painum[rand] -= 1
                    self.yama[i]=Pai(rank: Pai.getPairank(painum: rand), suit:Pai.getPaisuit(painum: rand));
                    break;
                }
            }
            print("set " + String(i))
        }
        dora.append(yama[135-10]);
    }
    //配牌
    public func haipai(){
        for _ in 1 ... 13{
            for i in 0...3{
                tsumo(id:i);
            }
        }
        for p in player{
            p.getHand().sort()
        }
        tsumo(id: 0)
        //gamescreen.h=player[0].getHand()
    }
    public func tsumo(id:Int){
        let temp = self.yama[0];
        self.yama.remove(at:0);
        yamanokori -= 1;
        player[id].tsumo(pai: temp);
        junme+=1
    }
    
    //ゲーム進行(未実装)
    /*
     public func gameMain(){
     var i=0
     var agari=false
     yamaInit()
     haipai()
     
     while(agari==false){
     tsumo(id: i)
     agari = player[i].play(select: hoge)
     
     
     
     }
     }
     */
    //ポンチーカンの優先順位管理
    private func manageNaki(nakihai:Pai)->Int{
        for i in 1...3{
            nakikind[i]=player[i].selectNaki(nakihai: nakihai,id: 0)
            if(nakikind[i]>=2){
                //鳴いて打牌(COMは鳴かない実装にする予定だが一応作った
                return i+1
            }
        }
        if(nakikind[1]==1){
            return 2
        }else{
            return 1
        }
    }
    
    //自分vsCOM3人を想定
    //リーチボタンが押された後の処理 -> 要検討
    //ボタンプッシュから次のボタンプッシュ待ちまでの処理を行う (もしかしたらgamescreenに書いた方が画面遷移が楽かも
    public func play(index: Int)->Bool{
        var agari:Agari
        var nakihai:Pai
        var next=0;
        //上がりなら（playで上がり、打牌、鳴きの全ての処理を行う）
        if(player[0].play(select: index-1)){
            print("hoge")
            agari=Agari(id: 0, hand: player[0].getHand(), agarihai: player[0].getHand().getpai()[13] , ron: false, bahuu: bahuu, jihuu: 1, junme: junme, chankan: false, rinshan: false)
            agari.printagari()
            return true
        }
        //適当に書いただけ
        /*
         nakihai=player[0].getHand().getsutehai()[player[0].getHand().getsutehai().count-1]
         next=manageNaki(nakihai: nakihai)
         while(next<4){
         //nakihai = player[next].autoPlay()
         next=manageNaki(nakihai: nakihai)
         }*/
        
        if(player[0].getHand().getpai().count%3==1){
            tsumo(id: 0)
        }
        //gamescreen.h=player[0].getHand()
        return true
    }
}
