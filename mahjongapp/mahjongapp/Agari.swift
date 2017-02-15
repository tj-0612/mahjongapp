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
    private var point=0;
    private var hand:Hand;
    private var yaku = Array<Yaku>();
    private var dora = 0;
    
    init(hand:Hand){
        self.hand=hand
        
    }
    
    private func addYaku(name:String ,han:Int){
        
    }
    
    public func judgeYaku(){
        if(judgeYakuman()==true){
            return
        }else{
            if(hand.getForm()=1){//チートイ
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
                else if(honrouto()==true){
                    addYaku(name:"混老頭",han:2)
                }
                
                if(chinitsu()==true){
                    addYaku(name: "清一色", han: 6)
                }
            }
            else{
                if(menzen()==true){
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
                        addYaku(name: "タンヤオ", han: <#T##Int#>)
                    }
                }
            }
        }
        
    }
    
    private func yakuhai()->Bool{
        
    }
    private func pinfu()->Bool{
        
    }
    private func richi()->Bool{
    }
    private func tsumo()->Bool{
        
    }
    private func tanyao()->Bool{
        
    }
    private func ippatsu()->Bool{
        
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
        
    }
    private func sanshokudoujun()->Bool{
        
    }
    private func ittsu()->Bool{
        
    }
    private func sananko()->Bool{
        
    }
    private func chanta()->Bool{
        
    }
    private func sanshokudoko()->Bool{
        
    }
    private func doublerichi()->Bool{
        
    }
    private func honitsu()->Bool{
        
    }
    private func junchan()->Bool{
        
    }
    private func ryanpeko()->Bool{
        
    }
    private func shosangen()->Bool{
        
    }
    private func honroto()->Bool{
        
    }
    private func chinitsu()->Bool{
        
    }
    private func dora()->Bool{
    }
    
    
    
    
    private func judgeYakuman()->Bool{
        
    }
}
