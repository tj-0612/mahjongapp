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
}

public class Agari{
    private var bahuu:Int
    private var jihuu:Int
    private var point=0;
    private var hand:Hand;
    private var agarihai:Pai
    private var ron:Bool
    private var yaku = Array<Yaku>();
    private var dora = 0;
    private var mentu=Array<Mentu>()
    
    init(hand:Hand,agarihai:Pai,ron:Bool,bahuu:Int,jihuu:Int){
        self.hand=hand
        self.agarihai=agarihai
        self.ron=ron
        self.bahuu=bahuu;
        self.jihuu=jihuu;
    }
    
    private func addYaku(name:String ,han:Int){
        
    }
    
    private func maketemphand()->[[Int]]{
        var temphand:[[Int]]=Array(repeating: Array(repeating:0 ,count: 9), count: 4)
        
        for pai in hand.getpai(){
            temphand[pai.suit][pai.rank]+=1;
        }
        return temphand
        
    }
    
    public func separateMentu(){
        var temphand = maketemphand()
        mentu = hand.getnaki()
        
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
    
    private func calcMentu(hand:[[Int]]){
        var temphand=hand
        
        if(mentu.count==5 && self.hand.getForm()==0){
            judgeYaku()
        }
        for i in 0...3 {
            for j in 0...8{
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
    
    public func judgeYaku(){
        if(judgeYakuman()==true){
            return
        }else{
            if(hand.getForm()==1){//チートイ
                addYaku(name: "七対子", han: 2)
                
                if(richi()==true){
                    if(doublerichi()==true){
                        addYaku(name: "ダブルリーチ", han: 2)
                    }
                    else{
                        addYaku(name: "リーチ",han: 1)
                    }
                    
                    if(ippatsu()==true){
                        addYaku(name: "一発",han: 1)
                    }
                }
                if(tsumo()==true){
                    addYaku(name: "ツモ",han: 1)
                }
                
                if(tanyao()==true){
                    addYaku(name: "タンヤオ", han: 1)
                }
                else if(honroto()==true){
                    addYaku(name:"混老頭",han:2)
                }
                
                if(chinitsu()==true){
                    addYaku(name: "清一色", han: 6)
                }
            }
            else{
                if(hand.returnnaki()==false){
                    if(richi()==true){
                        addYaku(name: "リーチ",han: 1)
                        if(ippatsu()==true){
                            addYaku(name: "一発",han: 1)
                        }
                    }
                    if(tsumo()==true){
                        addYaku(name: "ツモ",han: 1)
                    }
                    if(pinfu()==true){
                        addYaku(name: "平和", han: 1)
                    }
                    if(ryanpeko()==true){
                        addYaku(name: "二盃口", han: 3)
                    }else{
                        if(ipeko()==true){
                            addYaku(name:"一盃口",han:1)
                        }
                    }
                }else{
                    if(tanyao()==true){
                        addYaku(name: "タンヤオ", han: 1)
                    }
                }
            }
        }
        
    }
    
    private func yakuhai()->Bool{
        var han:Int=0;
        for i in mentu{
            if(i.pai.suit == 3){
                if(i.pai.rank == bahuu){
                    han+=1;
                }
                if(i.pai.rank == jihuu){
                    han+=1;
                }
                if(i.pai.rank == 5){
                    han+=1;
                }
                if(i.pai.rank == 6){
                    han+=1;
                }
                if(i.pai.rank == 7){
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
    private func pinfu()->Bool{
        
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
                if(temp.pai.rank==1 || temp.pai.rank==9 || (temp.pai.rank==7&&temp.judgeShuntu()==true)){
                    return false
                }
            }
        }
        addYaku(name: "タンヤオ", han: 1)
        return true
    }
    private func ippatsu()->Bool{
        if(hand.getrichi().ippatsu==true){
            addYaku(name: "一発", han: 1)
        }
    }
    private func ipeko()->Bool{
        
    }
    private func haiteitsumo()->Bool{
        
    }
    private func haiteiron()->Bool{
        
    }
    private func cyankan()->Bool{
        
    }
    private func toitoi()->Bool{
        for temp in mentu{
            if(temp.judgeShuntu()==true){
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
                if(hand.returnnaki()){
                    han=1
                }
                addYaku(name: "三色同順", han: han)
                return true
            }
        }
        return false
    }
    private func ittsu()->Bool{
        
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
    private func chanta()->Bool{
        var jihai=false
        var shuntu=false
        for temp in mentu{
            if(temp.pai.judgekazuhai()==true){
                if !(temp.pai.rank==1 || temp.pai.rank==9 || (temp.pai.rank==7&&temp.judgeShuntu()==true)){
                    return false
                }else if(temp.judgeShuntu()==true){
                    shuntu=true
                }
            }else{
                jihai=true
            }
        }
        if(jihai==true && shuntu==true){
            var han=2
            if(hand.returnnaki()==true){
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
        
    }
    private func junchan()->Bool{
        var jihai=false
        var shuntu=false
        for temp in mentu{
            if(temp.pai.judgekazuhai()==true){
                if !(temp.pai.rank==1 || temp.pai.rank==9 || (temp.pai.rank==7&&temp.judgeShuntu()==true)){
                    return false
                }else if(temp.judgeShuntu()==true){
                    shuntu=true
                }
            }else{
                jihai=true
            }
        }
        if(jihai==false && shuntu==true){
            var han=3
            if(hand.returnnaki()==true){
                han=2
            }
            addYaku(name: "ジュンチャン", han: han)
            return true
        }else{
            return false
        }
    }
    private func ryanpeko()->Bool{
        
    }
    private func shosangen()->Bool{
        
    }
    private func honroto()->Bool{
        var jihai=false
        var shuntu=false
        for temp in mentu{
            if(temp.pai.judgekazuhai()==true){
                if !(temp.pai.rank==1 || temp.pai.rank==9 || (temp.pai.rank==7&&temp.judgeShuntu()==true)){
                    return false
                }else if(temp.judgeShuntu()==true){
                    shuntu=true
                }
            }else{
                jihai=true
            }
        }
        if(jihai==true && shuntu==false){
            addYaku(name: "混老頭", han: 2)
            return true
        }else{
            return false
        }
    }
    private func chinitsu()->Bool{
        
    }
    private func setdora()->Bool{
    }
    
    private func judgeYakuman()->Bool{
        return suanko() || sukantu() || kokushimusou() || daisangen() || tenhou() || chihou() || shousushi() || daisushi() || tuiso() || chinroto() || ryuiso() || churenpoto()
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
        
    }
    private func chihou()->Bool{
        
    }
    private func shousushi()->Bool{
        
    }
    private func daisushi()->Bool{
        
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
            if !(temp.pai.judgekazuhai() && temp.pai.rank==1 && temp.pai.rank==9 && (temp.judgeKoutu() || temp.kind==Mentukind.TOITU)){
                return false
            }
        }
        addYaku(name: "清老頭", han: 13)
        return true
    }
    private func ryuiso()->Bool{
        
    }
    private func churenpoto()->Bool{
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
