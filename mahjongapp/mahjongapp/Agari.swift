//
//  Agari.swift
//  mahjongapp
//
//  Created by Takashi Tajimi on 2017/02/13.
//  Copyright © 2017年 Takashi Tajimi. All rights reserved.
//

import Foundation

struct Yaku{
    var name:String
    var han:Int
    
    init(name:String, han:Int) {
        self.name=name
        self.han=han
    }
    
    public func printYaku_debug(){
        print(name + " " + String(han))
    }
}


public class Agari{
    private var bahuu:Int
    private var jihuu:Int
    private var point=0;
    private var junme = -1;
    private var hand:Hand;
    private var agarihai:Pai
    private var ron:Bool
    private var chankan:Bool
    private var rinshan:Bool
    private var yaku = Array<Yaku>();
    private var dora = 0;
    private var mentu=Array<Mentu>()
    
    //符計算用変数
    private var fu=0
    private var ispinfu=false
    
    private var oya=false
    private var hurikomiplayer = -1
    
    init(hand:Hand,agarihai:Pai,ron:Bool,bahuu:Int,jihuu:Int,junme:Int,chankan:Bool, rinshan:Bool){
        self.hand=hand
        self.agarihai=agarihai
        self.ron=ron
        self.bahuu=bahuu;
        self.jihuu=jihuu;
        self.junme=junme
        self.chankan=chankan
        self.rinshan=rinshan
        separateMentu()
    }
    //役を追加する
    private func addYaku(name:String ,han:Int){
        yaku.append(Yaku(name:name, han:han))
    }
    
    //手牌の各牌の枚数を数えて配列にする
    private func maketemphand()->[[Int]]{
        var temphand:[[Int]]=Array(repeating: Array(repeating:0 ,count: 9), count: 4)
        
        for pai in hand.getpai(){
            temphand[pai.suit][pai.rank]+=1;
        }
        return temphand
        
    }
    //符と役から得点計算、誰がいくら減点されて誰がいくら加点されるかの管理方法を考え中
    private func calcpoint()->
    
    //七対子、国士に対して未対応
    //手牌のメンツ分解（頭を切り出す
    private func separateMentu(){
        var temphand = maketemphand()
        mentu = hand.getnaki()          //鳴き部分はメンツにダイレクトに追加
        //頭を切り出す
        for i in 0 ... 3{
            for j in 0...8{
                if(temphand[i][j]>=2){
                    temphand[i][j]-=2;
                    mentu.insert(Mentu(kind: Mentukind.TOITU, pai: Pai(rank: j, suit: i)),at:0)
                    calcMentu(hand:temphand)
                    mentu.remove(at: 0)
                    temphand[i][j]+=2
                }
            }
        }
        
    }
    
    private func calcFu(){
        var tempfu=0
        //平和
        if(ispinfu){
            if(ron){
                tempfu=30
            }else{
                tempfu=20
            }
            if(fu < tempfu){
                fu = tempfu
            }
            return
        }
        tempfu=20 //副底20
        //面前ロン10
        if(hand.isMenzen() && ron){
            tempfu += 10
        }
        //ツモ2
        if(!ron){
            tempfu += 2
        }
        //手牌構成
        for m in mentu{
            //頭
            if(m.kind == Mentukind.TOITU){
                //単騎待ち2
                if(Pai.paiEqual(p1:m.pai, p2:agarihai)){
                    tempfu += 2
                }
                //役牌の頭2 連風牌4
                if(m.pai.judgejihai()){
                    tempfu += m.pai.rank==jihuu ? 2 : 0
                    tempfu += m.pai.rank==bahuu ? 2 : 0
                    tempfu += m.pai.rank>=5 ? 2 : 0
                }
            }
            //シュンツの待ち
            else if(m.judgeShuntu()){
                if( (Pai.paiEqual(p1: m.pai, p2: agarihai) && m.pai.rank==7) || //7ペンチャン 2
                    (Pai.paiEqual(p1: m.pai, p2: Pai(rank: agarihai.rank-2, suit: agarihai.suit)) && m.pai.rank==1) || //3ペンチャン 2
                    (Pai.paiEqual(p1: m.pai, p2: Pai(rank: agarihai.rank-1, suit: agarihai.suit))) || //カンチャン 2
                    (Pai.paiEqual(p1: m.pai, p2: Pai(rank: agarihai.rank+1, suit: agarihai.suit)))){ //カンチャン 2
                        tempfu+=2
                }
            }
            //刻子
            else{
                //暗刻 8or4
                if(m.kind==Mentukind.ANKO){
                    tempfu += m.pai.judgeyaochu() ? 8 : 4
                }else if(m.kind==Mentukind.MINKO || m.kind==Mentukind.PON){ //明刻 4or2
                    tempfu += m.pai.judgeyaochu() ? 4 : 2
                }else if(m.kind==Mentukind.ANKAN){ //アンカン 32or16
                    tempfu += m.pai.judgeyaochu() ? 32 : 16
                }else if(m.kind==Mentukind.KAKAN || m.kind==Mentukind.MINKAN){ //ミンカン 16or8
                    tempfu += m.pai.judgeyaochu() ? 16 : 8
                }
            }
        }
        //鳴き平和系 30符
        if(tempfu==20){
            tempfu=30
        }
        //切り上げ
        tempfu += (tempfu%10 > 0) ? (10-(tempfu%10)) : 0
        if(fu<tempfu){
            fu=tempfu
        }
    }
    //手牌のメンツ分解（メンツを切り出す
    //全て切り出したら役を数えて得点計算に移り、最大得点となるメンツを選ぶ
    private func calcMentu(hand:[[Int]]){
        var temphand=hand
        
        //分解完了
        if(mentu.count==5 && self.hand.getForm()==0){
            judgeYaku()
            //未実装
            
        }
        //メンツを切り出す
        for i in 0...3 {
            for j in 0...8{
                //刻子
                if(temphand[i][j]>=3){
                    temphand[i][j]-=3;
                    if(ron==true){
                        mentu.insert(Mentu(kind: Mentukind.MINKO,pai: Pai(rank: j,suit: i)), at: 0)
                    }else{
                        mentu.insert(Mentu(kind: Mentukind.ANKO,pai: Pai(rank: j,suit: i)), at: 0)
                    }
                    calcMentu(hand: temphand)
                    mentu.remove(at: 0)
                    temphand[i][j]+=3
                }
                //順子
                if(temphand[i][j]>=1 && temphand[i][j+1]>=1 && temphand[i][j+2]>=1 && i<3 && j<7){
                    temphand[i][j]-=1;
                    temphand[i][j+1]-=1;
                    temphand[i][j+2]-=1;
                    mentu.insert(Mentu(kind: Mentukind.SHUNTU, pai: Pai(rank: j, suit: i)), at: 0)
                    calcMentu(hand: temphand)
                    mentu.remove(at: 0)
                    temphand[i][j]+=1;
                    temphand[i][j+1]+=1;
                    temphand[i][j+2]+=1;
                }
            }
        }
        
    }
    
    //役を判定する
    public func judgeYaku(){
        if(judgeYakuman()==true){ //役満の判定
            return
        }else{//標準役の判定
            if(titoitsu()){//七対子形
                if(richi()==true){
                    doublerichi()
                    
                    ippatsu()
                }
                tsumo()
                
                if(tanyao()==false){
                    honroto()
                }
                
                honitsu()
                chinitsu()
            }
            else{//一般形
                if(hand.isMenzen()==true){
                    if(richi()==true){
                        ippatsu()
                    }
                    tsumo()
                    pinfu()
                    if(ryanpeko()==false){
                        ipeko()
                    }
                    
                }
                if(haiteitsumo()==false){
                    haiteiron()
                }
                rinshankaiho()
                chankan_yaku()
                yakuhai()
                tanyao()
                toitoi()
                sanshokudoujun()
                ittsu()
                sananko()
                chanta()
                sanshokudoko()
                sankantsu()
                honitsu()
                junchan()
                shosangen()
                honroto()
                chinitsu()
                
            }
        }
        
    }
    
    private func titoitsu()->Bool{
        if(hand.getForm()==1){
            addYaku(name: "七対子", han: 2)
            return true
        }
        return false
    }
    
//余裕があれば食い下がり用の関数を用意した方が見やすい（別になくてもいいし面倒）
    private func yakuhai()->Bool{
        var han:Int=0;
        for temp in mentu{
            if(temp.pai.suit == 3){
                if(temp.pai.rank == bahuu){
                    han+=1;
                }
                if(temp.pai.rank == jihuu){
                    han+=1;
                }
                if(temp.pai.rank == 5){
                    han+=1;
                }
                if(temp.pai.rank == 6){
                    han+=1;
                }
                if(temp.pai.rank == 7){
                    han+=1;
                }
            }
        }
        if(han>=1){
            addYaku(name: "役牌", han: han)
            return true;
        }else{
            return false;
        }
    }
    private func judgeryanmen(mentu:Mentu)->Bool{
        if(mentu.pai.suit==agarihai.suit){
            if(mentu.pai.rank==agarihai.rank-2 || mentu.pai.rank==agarihai.rank+2){
                return true
            }
        }
        return false
    }
    private func pinfu()->Bool{
        var ryanmen=false
        for temp in mentu{
            if(temp.judgeKoutu()){
                return false
            }else if(temp.judgeShuntu()){
                if(ryanmen == false){
                    if(judgeryanmen(mentu: temp)){
                        ryanmen=true
                    }
                }
            }else{
                if(temp.pai.suit == 3){
                    if(temp.pai.rank == bahuu || temp.pai.rank==jihuu || temp.pai.rank>=5){
                        return false
                    }
                }
            }
        }
        if(ryanmen==true){
            addYaku(name: "平和", han: 1)
            ispinfu=true //符計算用
            return true
        }
        return false
    }
    private func rinshankaiho()->Bool{
        if(rinshan){
            addYaku(name: "嶺上開花", han: 1)
            return true
        }
        return false
    }
    private func richi()->Bool{
        if(hand.getrichi().flag==true){
            addYaku(name: "リーチ", han: 1)
            return true
        }else{
            return false
        }
    }
    private func tsumo()->Bool{
        if(ron==false){
            addYaku(name: "ツモ", han: 1)
            return true
        }else{
            return false
        }
    }
    private func tanyao()->Bool{
        for temp in mentu{
            if(temp.pai.judgekazuhai()==true){
                if(temp.pai.judgeyaochu() || (temp.pai.rank==7&&temp.judgeShuntu())){
                    return false
                }
            }else{
                return false
            }
        }
        addYaku(name: "タンヤオ", han: 1)
        return true
    }
    private func ippatsu()->Bool{
        if(hand.getrichi().ippatsu==true){
            addYaku(name: "一発", han: 1)
            return true
        }
        return false
    }
    private func ipeko()->Bool{
        if(hand.isMenzen()==false){
            return false
        }
        for temp in mentu{
            if(temp.judgeShuntu()){
                for temp2 in mentu{
                    if(Pai.paiEqual(p1:temp.pai,p2:temp2.pai)){
                        addYaku(name: "一盃口", han: 1)
                        return true
                    }
                }
            }
        }
        return false
    }
    private func haiteitsumo()->Bool{
        if(junme==136 && !ron){
            addYaku(name: "海底摸月", han: 1)
            return true
        }
        return false
    }
    private func haiteiron()->Bool{
        if(junme==136 && ron){
            addYaku(name: "河底撈魚", han: 1)
            return true
        }
        return false
    }
    private func chankan_yaku()->Bool{
        if(chankan){
            addYaku(name: "槍槓", han: 1)
            return true
        }
        return false
    }
    private func toitoi()->Bool{
        for temp in mentu{
            if(temp.judgeShuntu()){
                return false
            }
        }
        addYaku(name: "対々和", han: 2)
        return true
    }
    private func sanshokudoujun()->Bool{
        var manzu=false
        var pinzu=false
        var sozu=false
        for i in 1...9{
            manzu=false
            pinzu=false
            sozu=false
            for temp in mentu{
                if(temp.pai.judgekazuhai() && temp.judgeShuntu()){
                    if(temp.pai.rank==i){
                        switch temp.pai.suit{
                        case 0: manzu=true
                        case 1: pinzu=true
                        case 2: sozu=true
                        default: break
                        }
                    }
                }
            }
            if(manzu && pinzu && sozu){
                var han=2
                if(hand.isMenzen()==false){
                    han=1
                }
                addYaku(name: "三色同順", han: han)
                return true
            }
        }
        return false
    }
    private func ittsu()->Bool{
        var flag1=false
        var flag2=false
        var flag3=false
        for i in 0...2{
            flag1=false
            flag2=false
            flag3=false
            for temp in mentu{
                if(temp.judgeShuntu()||temp.pai.suit==i){
                    switch temp.pai.rank{
                    case 1:flag1=true
                    case 4:flag2=true
                    case 7:flag3=true
                    default: break;
                    }
                }
            }
            if(flag1&&flag2&&flag3){
                var han=2
                if(hand.isMenzen()==false){
                    han=1
                }
                addYaku(name: "一気通貫", han: han)
                return true
            }
        }
        return false
    }
    private func sananko()->Bool{
        var count=0
        for temp in mentu{
            if(temp.kind==Mentukind.ANKO || temp.kind==Mentukind.ANKAN){
                count += 1
            }
            if(count==3){
                addYaku(name: "三暗刻", han: 2)
                return true
            }
        }
        return false
    }
    private func sankantsu()->Bool{
        var count=0;
        for temp in hand.getnaki(){
            if(temp.judgeKantu()){
                count += 1
            }
        }
        if(count==3){
            addYaku(name: "三槓子", han: 2)
            return true
        }
        return false
    }
    private func chanta()->Bool{
        var jihai=false
        var shuntu=false
        for temp in mentu{
            if(temp.pai.judgekazuhai()==true){
                if !(temp.pai.judgeyaochu() || (temp.pai.rank==7&&temp.judgeShuntu()==true)){
                    return false
                }else if(temp.judgeShuntu()==true){
                    shuntu=true
                }
            }else{
                jihai=true
            }
        }
        //ホンロー、ジュンチャンと被らないように
        if(jihai==true && shuntu==true){
            var han=2
            if(!hand.isMenzen()==true){
                han=1
            }
            addYaku(name: "チャンタ", han: han)
            return true
        }else{
            return false
        }
    }
    private func sanshokudoko()->Bool{
        var manzu=false
        var pinzu=false
        var sozu=false
        for i in 1...9{
            manzu=false
            pinzu=false
            sozu=false
            for temp in mentu{
                if(temp.pai.judgekazuhai() && temp.judgeKoutu()){
                    if(temp.pai.rank==i){
                        switch temp.pai.suit{
                        case 0: manzu=true
                        case 1: pinzu=true
                        case 2: sozu=true
                        default: break
                        }
                    }
                }
            }
            if(manzu && pinzu && sozu){
                addYaku(name: "三色同刻", han: 2)
                return true
            }
        }
        return false
    }
    private func doublerichi()->Bool{
        
    }
    private func honitsu()->Bool{
        var jihai=false
        var suit = -1
        for i in 0...mentu.count{
            if(mentu[i].pai.judgekazuhai()){
                if(suit == -1){
                    suit = mentu[i].pai.suit
                }
                if(suit != mentu[i].pai.suit){
                    return false
                }
            }else{
                jihai = true
            }
        }
        if(jihai){
            var han = 3
            if(!hand.isMenzen()){
                han=2
            }
            addYaku(name: "混一色", han: han)
            return true
        }
        return false
    }
    private func junchan()->Bool{
        var shuntu=false
        for temp in mentu{
            if(temp.pai.judgekazuhai()==true){
                if !(temp.pai.judgeyaochu() || (temp.pai.rank==7&&temp.judgeShuntu()==true)){
                    return false
                }else if(temp.judgeShuntu()==true){
                    shuntu=true
                }
            }else{
                return false
            }
        }
        if(shuntu==true){
            var han=3
            if(!hand.isMenzen()==true){
                han=2
            }
            addYaku(name: "ジュンチャン", han: han)
            return true
        }else{
            return false
        }
    }
    private func ryanpeko()->Bool{
        var count=0
        var index = -1
        var index2 = -1
        for i in 0...mentu.count{
            if(mentu[i].judgeShuntu() && i != index){
                for j in i+1...mentu.count{
                    if(Pai.paiEqual(p1:mentu[i].pai,p2:mentu[j].pai) && j != index2){
                        index = i
                        index2 = j
                        count += 1
                    }
                }
            }
        }
        if(count==2){
            addYaku(name: "二盃口", han: 3)
            return true
        }
        return false
    }
    private func shosangen()->Bool{
        var count=0
        var toitu=false
        for temp in mentu{
            if(temp.judgeKoutu() && temp.pai.judgejihai()){
                if(temp.pai.rank>=5 && temp.pai.rank<=7){
                    count+=1
                }
            }
            else if(temp.kind==Mentukind.TOITU && temp.pai.judgejihai()){
                if(temp.pai.rank>=5 && temp.pai.rank<=7){
                    toitu=true
                }
            }
            if(count==2 && toitu){
                addYaku(name: "小三元", han: 2)
                return true
            }
        }
        return false;
    }
    private func honroto()->Bool{
        var jihai=false
        for temp in mentu{
            if(temp.pai.judgekazuhai()==true){
                if !(temp.pai.judgeyaochu() && temp.judgeKoutu()){
                    return false
                }
            }else{
                jihai=true
            }
        }
        //チンローは回避されるはずだけど一応
        if(jihai==true){
            addYaku(name: "混老頭", han: 2)
            return true
        }else{
            return false
        }
    }
    private func chinitsu()->Bool{
        var suit = -1
        for i in 0...mentu.count{
            if(mentu[i].pai.judgekazuhai()){
                if(suit == -1){
                    suit = mentu[i].pai.suit
                }
                if(suit != mentu[i].pai.suit){
                    return false
                }
            }else{
                return false
            }
        }
        var han = 6
        if(!hand.isMenzen()){
            han=5
        }
        addYaku(name: "清一色", han: han)
        return true
    }
    private func setdora()->Bool{
    }
    
    private func judgeYakuman()->Bool{
        return suanko() || sukantu() || kokushimusou() || daisangen() || tenhou() || chihou() || sushihou() || tuiso() || chinroto() || ryuiso() || churenpoto()
    }
    private func suanko()->Bool{
        var count=0
        for temp in mentu{
            if(temp.kind==Mentukind.ANKAN || temp.kind==Mentukind.ANKO){
                count+=1
            }
            if(count==4){
                addYaku(name: "四暗刻", han: 13)
                return true
            }
        }
        return false
    }
    
    private func sukantu()->Bool{
        var count=0
        for temp in mentu{
            if(temp.judgeKantu()){
                count+=1
            }
            if(count==4){
                addYaku(name: "四槓子", han: 13)
                return true
            }
        }
        return false
    }
    
    private func kokushimusou()->Bool{
        var count:[Int] = Array(repeating: 0, count: 13)
        for temp in hand.getpai(){
            if(temp.judgejihai()){
                count[5+temp.rank]+=1
            }else if(temp.rank==1 || temp.rank==9){
                count[temp.suit * 2 - 1 + ((temp.rank==9) ? 1 : 0)] += 1
            }else{
                return false
            }
        }
        for loop in count{
            if(loop==0){
                return false
            }
        }
        addYaku(name: "国士無双", han: 13)
        return false
    }
    
    private func daisangen()->Bool{
        var count=0
        for temp in mentu{
            if(temp.judgeKoutu() && temp.pai.judgejihai()){
                if(temp.pai.rank>=5 && temp.pai.rank<=7){
                    count+=1
                }
            }
            if(count==3){
                addYaku(name: "大三元", han: 13)
                return true
            }
        }
        return false;
    }
    private func tenhou()->Bool{
        if(junme==1){
            addYaku(name: "天和", han: 13)
            return true
        }
        return false
    }
    //junmeの実装次第で変わる
    private func chihou()->Bool{
        if(junme==jihuu){
            addYaku(name: "地和", han: 13)
            return true
        }
        return false
    }
    private func sushihou()->Bool{
        var count=0
        var toitu=false
        for temp in mentu{
            if(temp.pai.judgejihai() && temp.pai.rank<=4){
                if(temp.judgeKoutu()){
                    count+=1
                }else if(temp.kind==Mentukind.TOITU){
                    toitu=true
                }
            }
        }
        if((count==3 && toitu) || count==4){
            addYaku(name: "四喜和", han: 13)
            return true
        }
        return false
    }
    private func tuiso()->Bool{
        for temp in mentu{
            if(temp.pai.judgekazuhai()){
                return false
            }
        }
        addYaku(name: "字一色", han: 13)
        return true
    }
    private func chinroto()->Bool{
        for temp in mentu{
            if !(temp.pai.judgekazuhai() && temp.pai.judgeyaochu() && (temp.judgeKoutu() || temp.kind==Mentukind.TOITU)){
                return false
            }
        }
        addYaku(name: "清老頭", han: 13)
        return true
    }
    private func ryuiso()->Bool{
        for temp in mentu{
            if(temp.pai.suit != 2 && !(temp.pai.suit == 3 && temp.pai.rank==6)){
                return false
            }
            else{
                if(temp.judgeShuntu()){
                    if(temp.pai.rank != 2){
                        return false
                    }
                }else if(temp.pai.suit==2){
                    if(temp.pai.rank==1 || temp.pai.rank==5 || temp.pai.rank==7 || temp.pai.rank==9){
                        return false
                    }
                }
            }
        }
        addYaku(name: "緑一色", han: 13)
        return true
    }
    private func churenpoto()->Bool{
        if(!hand.isMenzen()==false){
            return false
        }

        var kazuhai = -1;
        for temp in hand.getpai(){
            if(temp.judgejihai()){
                return false
            }else{
                if(kazuhai == -1){
                    kazuhai=temp.suit
                }else if(kazuhai != temp.suit){
                    return false
                }
            }
        }
        var count=[0,0,0,0,0,0,0,0,0]
        for temp in hand.getpai(){
            count[temp.rank - 1] += 1
        }
        for i in 1...9{
            if(i==9 || i==1){
                if(count[i]<3){
                    return false
                }
            }else{
                if(count[i]<1){
                    return false
                }
            }
        }
        addYaku(name: "九蓮宝燈", han: 13)
        return true
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
