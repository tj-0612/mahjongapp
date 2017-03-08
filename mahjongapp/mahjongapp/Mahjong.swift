//
//  Mahjong.swift
//  mahjongapp
//
//  Created by Takashi Tajimi on 2017/02/13.
//  Copyright © 2017年 Takashi Tajimi. All rights reserved.
//

import Foundation

//Mahjongクラスの中身を全部gamescreenに移せば楽になるかも->写したのでこのファイルはいらない（一応最後まで残す）
class Mahjong{
    private var yama = Array(repeating: Pai(rank: -1,suit: -1),count:136);
    private var bahuu = 1;
    private var oya = 0
    private var player = [Player(id: 0),Player(id:1),Player(id:2),Player(id:3)];
    private var countkan=0;
    private var yamanokori=136
    private var dora = Array<Pai>();
    private var junme=0
    
    private var renchancount=0
    private var kyotaku=0 //供託
    
    public func getplayer(id:Int)->Player{
        return player[id]
    }
    private var nakikind=[0,0,0,0]
    
    init(){
        self.yamaInit()
    }
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
        var nakihai:Pai
        var next=0;
        //上がりなら（playで上がり、打牌、鳴きの全ての処理を行う）
        if(player[0].play(select: index-1)){
            //上がり処理（未実装）
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
        
        tsumo(id: 0)
        //gamescreen.h=player[0].getHand()
        return true
    }

}

