//
//  gamedebug.swift
//  mahjongapp
//
//  Created by Takashi Tajimi on 2017/03/08.
//  Copyright © 2017年 Takashi Tajimi. All rights reserved.
//

import UIKit

class gamedebug: UIViewController {
    
    
    
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
        
        updatehandimage()
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
    
    

    
    
    //左から順に1~13
    @IBOutlet var ButtonHand: [UIButton]!

    
    //ポンチーカンツモロンリーチボタン
    
    
    var waitbuttontap=true
    //ダブルタップで実行するようにした方がいいかも
    //Mahjongクラスのplayメソッドでやってたことをこっちに移すべき説
    
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
    func updatehandimage(){
        if(player[0].getHand().getpai().count==0){
            return
        }
        for i in 0...player[0].getHand().getpai().count-1{
            ButtonHand[i].setImage(convertUIImagepai(pai: player[0].getHand().getpai()[i], direction: 1), for: UIControlState.normal)
        }
    }
    func deletehandimage(){
        for b in ButtonHand{
            b.setImage(UIImage(named:"toumei.png"), for: .normal)
        }
    }
    
    var nextpon=false
    var nextkan=false
    var nextchi=false
    var selectchi=false
    var selectchipai:Pai!
    
    func tappedadd(pai:Pai){
        if(nextpon==true){
            player[0].doPon(nakihai: pai)
            nextpon=false
        }
        else if(nextchi==true){
            if(selectchi==false){
                selectchipai=pai
                selectchi=true
            }else{
                player[0].doChi(pai:selectchipai, nakihai: pai)
                nextchi=false
                selectchi=false
            }
        }
        else if(nextkan==true){
            player[0].doKan(nakihai: pai)
            nextkan=false
        }else{
            player[0].tsumo(pai: pai)
        }
        updatehandimage()
    }
    @IBAction func Buttonaddm1(_ sender: Any) {
        tappedadd(pai: Pai(rank: 1, suit: 0))
    }
    @IBAction func ButtonAddm2(_ sender: Any) {
        tappedadd(pai: Pai(rank: 2, suit: 0))
    }
    @IBAction func ButtonAddm3(_ sender: Any) {
        tappedadd(pai: Pai(rank: 3, suit: 0))
    }
    @IBAction func ButtonAddm4(_ sender: Any) {
        tappedadd(pai: Pai(rank: 4, suit: 0))
    }

    @IBAction func ButtonAddm5(_ sender: Any) {
        tappedadd(pai: Pai(rank: 5, suit: 0))
    }
    @IBAction func ButtonAddm6(_ sender: Any) {
        tappedadd(pai: Pai(rank: 6, suit: 0))
    }
    @IBAction func ButtonAddm7(_ sender: Any) {
        tappedadd(pai: Pai(rank: 7, suit: 0))
    }
    @IBAction func ButtonAddm8(_ sender: Any) {
        tappedadd(pai: Pai(rank: 8, suit: 0))
    }
    @IBAction func ButtonAddm9(_ sender: Any) {
        tappedadd(pai: Pai(rank: 9, suit: 0))
    }
    @IBAction func ButtonAddp1(_ sender: Any) {
        tappedadd(pai: Pai(rank: 1, suit: 1))
    }
    @IBAction func ButtonAddp2(_ sender: Any) {
        tappedadd(pai: Pai(rank: 2, suit: 1))
    }
    @IBAction func ButtonAddp3(_ sender: Any) {
        tappedadd(pai: Pai(rank: 3, suit: 1))
    }
    @IBAction func ButtonAddp4(_ sender: Any) {
        tappedadd(pai: Pai(rank: 4, suit: 1))
    }
    @IBAction func ButtonAddp5(_ sender: Any) {
        tappedadd(pai: Pai(rank: 5, suit: 1))
    }
    @IBAction func ButtonAddp6(_ sender: Any) {
        tappedadd(pai: Pai(rank: 6, suit: 1))
    }
    @IBAction func ButtonAddp7(_ sender: Any) {
        tappedadd(pai: Pai(rank: 7, suit: 1))
    }
    @IBAction func ButtonAddp8(_ sender: Any) {
        tappedadd(pai: Pai(rank: 8, suit: 1))
    }
    @IBAction func ButtonAddp9(_ sender: Any) {
        tappedadd(pai: Pai(rank: 9, suit: 1))
    }
    @IBAction func ButtonAdds1(_ sender: Any) {
        tappedadd(pai: Pai(rank: 1, suit: 2))
    }
    @IBAction func ButtonAdds2(_ sender: Any) {
        tappedadd(pai: Pai(rank: 2, suit: 2))
    }
    @IBAction func ButtonAdds3(_ sender: Any) {
        tappedadd(pai: Pai(rank: 3, suit: 2))
    }
    @IBAction func ButtonAdds4(_ sender: Any) {
        tappedadd(pai: Pai(rank: 4, suit: 2))
    }
    @IBAction func ButtonAdds5(_ sender: Any) {
        tappedadd(pai: Pai(rank: 5, suit: 2))
    }
    @IBAction func ButtonAdds6(_ sender: Any) {
        tappedadd(pai: Pai(rank: 6, suit: 2))
    }
    @IBAction func ButtonAdds7(_ sender: Any) {
        tappedadd(pai: Pai(rank: 7, suit: 2))
    }
    @IBAction func ButtonAdds8(_ sender: Any) {
        tappedadd(pai: Pai(rank: 8, suit: 2))
    }
    @IBAction func ButtonAdds9(_ sender: Any) {
        tappedadd(pai: Pai(rank: 9, suit: 2))
    }
    @IBAction func ButtonAddz1(_ sender: Any) {
        tappedadd(pai: Pai(rank: 1, suit: 3))
    }
    @IBAction func ButtonAddz2(_ sender: Any) {
        tappedadd(pai: Pai(rank: 2, suit: 3))
    }
    @IBAction func ButtonAddz3(_ sender: Any) {
        tappedadd(pai: Pai(rank: 3, suit: 3))
    }
    @IBAction func ButtonAddz4(_ sender: Any) {
        tappedadd(pai: Pai(rank: 4, suit: 3))
    }
    @IBAction func ButtonAddz5(_ sender: Any) {
        tappedadd(pai: Pai(rank: 5, suit: 3))
    }
    @IBAction func ButtonAddz6(_ sender: Any) {
        tappedadd(pai: Pai(rank: 6, suit: 3))
    }
    @IBAction func ButtonAddz7(_ sender: Any) {
        tappedadd(pai: Pai(rank: 7, suit: 3))
    }
    @IBAction func tappedtsumo(_ sender: Any) {
        play(index:20)
        
    }
    @IBAction func tappeddelete(_ sender: Any) {
        player[0]=Player(id:0)
        deletehandimage()
    }
    @IBAction func tappedpon(_ sender: Any) {
        nextpon=true
        nextchi=false
        nextkan=false
        selectchi=false
    }
    @IBAction func tappedchi(_ sender: Any) {
        nextchi=true
        nextpon=false
        nextkan=false
        selectchi=false
    }
    @IBAction func tappedkan(_ sender: Any) {
        nextkan=true
        nextpon=false
        nextchi=false
        selectchi=false
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
            agari=Agari(id: 0, hand: player[0].getHand(), agarihai: player[0].getHand().getpai()[13-player[0].getHand().getnaki().count*3] , ron: false, bahuu: bahuu, jihuu: 1, junme: junme, chankan: false, rinshan: false)
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
