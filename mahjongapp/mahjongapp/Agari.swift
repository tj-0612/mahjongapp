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

public struct Point{
    public var id:Int
    public var payment=[0,0,0,0]
    public var get:Int
    
    init(id:Int, payment:Array<Int>){
        if(payment[id] != 0){
            print("payment error")
        }
        self.id=id
        self.payment=payment
        get=payment[0]+payment[1]+payment[2]+payment[3]
    }
}

infix operator ^^
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}

//一応検証したけど七対子系で正しく動くかはまだ怪しい

public class Agari{
    private var bahuu:Int
    private var jihuu:Int
    private var point=Point(id:0,payment:[0,0,0,0]);
    private var junme = -1;
    private var han=0
    private var hand:Hand;
    private var agarihai:Pai
    private var ron:Bool
    private var chankan:Bool
    private var rinshan:Bool
    private var yaku = Array<Yaku>();
    private var tempyaku = Array<Yaku>();
    private var dora = 0;
    private var mentu=Array<Mentu>()
    private var id:Int
    
    //符計算用変数
    private var fu=0
    private var ispinfu=false
    
    private var oya=false
    private var hurikomiplayer = 1
    
    init(id:Int,hand:Hand,agarihai:Pai,ron:Bool,bahuu:Int,jihuu:Int,junme:Int,chankan:Bool, rinshan:Bool){
        self.id=id
        self.hand=hand
        self.agarihai=agarihai
        self.ron=ron
        self.bahuu=bahuu;
        self.jihuu=jihuu;
        self.junme=junme
        self.chankan=chankan
        self.rinshan=rinshan
        self.separateMentu()
    }
    //役を追加する
    private func addYaku(name:String ,han:Int){
        tempyaku.append(Yaku(name:name, han:han))
    }
    
    //手牌の各牌の枚数を数えて配列にする
    private func maketemphand()->[[Int]]{
        var temphand:[[Int]]=Array(repeating: Array(repeating:0 ,count: 9), count: 4)
        
        for pai in hand.getpai(){
            temphand[pai.suit][pai.rank-1]+=1;
        }
        return temphand
        
    }
    //符と役から得点計算、誰がいくら減点されて誰がいくら加点されるかの管理方法を考え中 -> structを作る
    //tableは作らない方針
    private func calcpoint()->Point{
        var basepoint:Int //基本点（子のツモ時の子が支払う点数）
        var han=0
        for y in yaku{
            han += y.han
        }
        if han>=5 {
            switch(han){
            case 5: basepoint=2000
            case 6: fallthrough
            case 7: basepoint=3000
            case 8: fallthrough
            case 9: fallthrough
            case 10: basepoint=4000
            case 11: fallthrough
            case 12: basepoint=6000
            default: basepoint=8000*Int(han/13)
            }
        }else{
            basepoint=fu * (2^^(han+2))
            if(basepoint>2000){
                basepoint=2000
            }
            if(han==0){
                basepoint=0
                print("あがれない")
            }
        }
        var pay=[0,0,0,0]
        if ron {
            pay[hurikomiplayer] = oya ? basepoint*6 : basepoint*4
        }else{
            let oyaplayer = jihuu==1 ? id : (5-jihuu+id)%4
            if(oyaplayer==id){
                for i in 0...3{
                    if(i==id){
                        pay[i]=0
                    }else{
                        pay[i]=(basepoint*2)%100>0 ? (basepoint*2)+100-(basepoint*2)%100 : (basepoint*2)
                    }
                }
            }else{
                for i in 0...3{
                    if(i==id){
                        pay[i]=0
                    }else{
                        if(i==oyaplayer){
                            pay[i]=(basepoint*2)%100>0 ? (basepoint*2)+100-(basepoint*2)%100 : (basepoint*2)
                        }else{
                            pay[i]=(basepoint)%100>0 ? (basepoint)+100-(basepoint)%100 : (basepoint)
                        }
                    }
                }
            }
        }
        let p=Point(id: id,payment: pay)
        return p
    }
    
    public func printagari(){
        print(String(fu)+"符")
        for y in yaku{
            y.printYaku_debug()
        }
        print("計"+String(han)+"役")
        for p in point.payment{
            print(String(p)+",")
        }
        print(String(point.get))
    }
    //七対子、国士に対して未対応
    //手牌のメンツ分解（頭を切り出す
    private func separateMentu(){
        var temphand = maketemphand()
        mentu = hand.getnaki()          //鳴き部分はメンツにダイレクトに追加
        if(hand.getForm()==2){
            addYaku(name: "国士無双", han: 13)
            return
        }else if(hand.getForm()==1){
            for i in 0...3{
                for j in 0...8{
                    if(temphand[i][j]==2){
                        mentu.append(Mentu(kind: Mentukind.TOITU, pai: Pai(rank:j+1,suit:i)))
                    }
                }
            }
            judgeYaku()
            yaku=tempyaku
            for y in yaku{
                han += y.han
            }
            fu=25
            point=calcpoint()
            return
        }

        //頭を切り出す
        for i in 0 ... 3{
            for j in 0...8{
                if(temphand[i][j]>=2){
                    temphand[i][j]-=2;
                    mentu.insert(Mentu(kind: Mentukind.TOITU, pai: Pai(rank: j+1, suit: i)),at:0)
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
        var temppoint:Point
        var temphan=0
        //分解完了
        if(mentu.count==5 && self.hand.getForm()==0){
            judgeYaku()
            for y in tempyaku{
                temphan+=y.han
            }
            if(temphan>=han){
                if(temphan>han){
                    yaku=tempyaku
                    han=temphan
                    fu=0
                }
                calcFu()
                temppoint=calcpoint()
                if(temppoint.get>point.get){
                    point=temppoint
                }
            }
            return
            
        }
        //メンツを切り出す
        for i in 0...3 {
            for j in 0...8{
                //刻子
                if(temphand[i][j]>=3){
                    temphand[i][j]-=3;
                    if(ron==true && Pai.paiEqual(p1: agarihai, p2: Pai(rank:j+1,suit:i))){
                        mentu.insert(Mentu(kind: Mentukind.MINKO,pai: Pai(rank: j+1,suit: i)), at: 0)
                    }else{
                        mentu.insert(Mentu(kind: Mentukind.ANKO,pai: Pai(rank: j+1,suit: i)), at: 0)
                    }
                    calcMentu(hand: temphand)
                    mentu.remove(at: 0)
                    temphand[i][j]+=3
                }
                //順子
                if(j<7 && i<3){
                    if(temphand[i][j]>=1 && temphand[i][j+1]>=1 && temphand[i][j+2]>=1){
                        temphand[i][j]-=1;
                        temphand[i][j+1]-=1;
                        temphand[i][j+2]-=1;
                        mentu.insert(Mentu(kind: Mentukind.SHUNTU, pai: Pai(rank: j+1, suit: i)), at: 0)
                        calcMentu(hand: temphand)
                        mentu.remove(at: 0)
                        temphand[i][j]+=1;
                        temphand[i][j+1]+=1;
                        temphand[i][j+2]+=1;
                    }
                }
            }
        }
        
    }
    
    //役を判定する
    public func judgeYaku(){
        tempyaku=Array<Yaku>()
        ispinfu=false
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
    @discardableResult
    private func titoitsu()->Bool{
        if(hand.getForm()==1){
            addYaku(name: "七対子", han: 2)
            return true
        }
        return false
    }
    
//余裕があれば食い下がり用の関数を用意した方が見やすい（別になくてもいいし面倒）
    @discardableResult
    private func yakuhai()->Bool{
        var han:Int=0;
        for temp in mentu{
            if(temp.pai.suit == 3 && temp.judgeKoutu()){
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
        if (Pai.paiEqual(p1: mentu.pai, p2: agarihai) && mentu.pai.rank != 7) || (Pai.paiEqual(p1: mentu.pai, p2: Pai(rank: agarihai.rank-2, suit: agarihai.suit)) && mentu.pai.rank != 1){
                return true
            }

        return false
    }
    @discardableResult
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
    @discardableResult
    private func rinshankaiho()->Bool{
        if(rinshan){
            addYaku(name: "嶺上開花", han: 1)
            return true
        }
        return false
    }
    @discardableResult
    private func richi()->Bool{
        if(hand.getrichi().flag==true){
            addYaku(name: "リーチ", han: 1)
            return true
        }else{
            return false
        }
    }
    @discardableResult
    private func tsumo()->Bool{
        if(ron==false){
            addYaku(name: "ツモ", han: 1)
            return true
        }else{
            return false
        }
    }
    @discardableResult
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
    @discardableResult
    private func ippatsu()->Bool{
        if(hand.getrichi().ippatsu==true){
            addYaku(name: "一発", han: 1)
            return true
        }
        return false
    }
    @discardableResult
    private func ipeko()->Bool{
        if(hand.isMenzen()==false){
            return false
        }
        for i in 0...mentu.count-1{
            if(mentu[i].judgeShuntu()){
                for j in 0...mentu.count-1{
                    if(Pai.paiEqual(p1:mentu[i].pai,p2:mentu[j].pai) && i != j && mentu[j].judgeShuntu()){
                        addYaku(name: "一盃口", han: 1)
                        return true
                    }
                }
            }
        }
        return false
    }
    @discardableResult
    private func haiteitsumo()->Bool{
        if(junme==136 && !ron){
            addYaku(name: "海底摸月", han: 1)
            return true
        }
        return false
    }
    @discardableResult
    private func haiteiron()->Bool{
        if(junme==136 && ron){
            addYaku(name: "河底撈魚", han: 1)
            return true
        }
        return false
    }
    @discardableResult
    private func chankan_yaku()->Bool{
        if(chankan){
            addYaku(name: "槍槓", han: 1)
            return true
        }
        return false
    }
    @discardableResult
    private func toitoi()->Bool{
        for temp in mentu{
            if(temp.judgeShuntu()){
                return false
            }
        }
        addYaku(name: "対々和", han: 2)
        return true
    }
    @discardableResult
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
    @discardableResult
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
    @discardableResult
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
    @discardableResult
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
    @discardableResult
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
    @discardableResult
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
    @discardableResult
    private func doublerichi()->Bool{
        return false
    }
    @discardableResult
    private func honitsu()->Bool{
        var jihai=false
        var suit = -1
        for i in 0...mentu.count-1{
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
    @discardableResult
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
    @discardableResult
    private func ryanpeko()->Bool{
        var count=0
        var index = -1
        var index2 = -1
        for i in 0...mentu.count-2{
            if(mentu[i].judgeShuntu() && i != index2){
                for j in i+1...mentu.count-1{
                    if(Pai.paiEqual(p1:mentu[i].pai,p2:mentu[j].pai) && j != index2 && mentu[j].judgeShuntu()){
                        index = i
                        index2 = j
                        count += 1
                        break;
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
    @discardableResult
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
    @discardableResult
    private func honroto()->Bool{
        var jihai=false
        for temp in mentu{
            if(temp.pai.judgekazuhai()==true){
                if !(temp.pai.judgeyaochu() && (temp.judgeKoutu() || temp.kind==Mentukind.TOITU)){
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
    @discardableResult
    private func chinitsu()->Bool{
        var suit = -1
        for i in 0...mentu.count-1{
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
    @discardableResult
    private func setdora()->Bool{
        return false
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
                count[temp.suit * 2 + ((temp.rank==9) ? 1 : 0)] += 1
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
        if(hand.getForm()==0){
            for temp in mentu{
                if(temp.pai.judgekazuhai()){
                    return false
                }
            }
        }else if(hand.getForm()==1){
            for p in hand.getpai(){
                if(p.judgekazuhai()){
                    return false
                }
            }
        }else{
            return false
        }
        addYaku(name: "字一色", han: 13)
        return true
    }
    private func chinroto()->Bool{
        if(hand.getForm()==0){
            for temp in mentu{
                if !(temp.pai.judgekazuhai() && temp.pai.judgeyaochu() && (temp.judgeKoutu() || temp.kind==Mentukind.TOITU)){
                    return false
                }
            }
            addYaku(name: "清老頭", han: 13)
            return true
        }else{
            return false
        }
    }
    private func ryuiso()->Bool{
        if(hand.getForm()==0){
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
        else{
            return false
        }
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
