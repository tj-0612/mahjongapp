//
//  Player.swift
//  mahjongapp
//
//  Created by Takashi Tajimi on 2017/02/13.
//  Copyright © 2017年 Takashi Tajimi. All rights reserved.
//

import Foundation

public class Player{
    private var point = 25000;
    private var hand = Hand();
    private var id:Int;
    //buttonの出現の管理
    private var pon=false
    private var chi=false
    private var kan=false
    private var ron=false
    private var tsumo=false
    private var richi=false
    
    public func getHand()->Hand{
        return hand
    }
    init(id:Int){
        self.id = id;
        
    }
    //鳴かない0 チー1 ポン2 カン3
    public func selectNaki(nakihai: Pai, id: Int)->Int{
        return 0;
        
    }
    public func doPon(nakihai:Pai){
        hand.addnaki(pai: nakihai, nakihai: nakihai, kind: Mentukind.PON)
    }
    public func doChi(pai: Pai, nakihai: Pai){
        hand.addnaki(pai: pai, nakihai: nakihai, kind: Mentukind.CHII)
    }
    public func doKan(nakihai:Pai){
        hand.addnaki(pai: nakihai, nakihai: nakihai, kind: Mentukind.MINKAN)
    }
    //リーチの実行
    public func dorichi(junme: Int){
        hand.dorichi(junme: junme)
    }
    //打牌、鳴き、上がり、リーチ
    public func play(select:Int)->Bool{
        if(select==19 || select==20){
            if(hand.getshanten().getShanten() == -1){
                return true
            }
        }
        if(hand.getpai().count<select && select<15){
            print("not hand")
            return false
        }
        if(select<15){
            hand.kiru(index: select)
            //gamescreen.h=hand
            //gamescreen.sutehai[0]=hand.getsutehai()
        }
        return false
    }
    //COMプレイヤーの打牌など
    public func autoPlay(){
        
    }
    
    public func tsumo(pai:Pai){
        hand.tsumo(pai: pai);
    }
    
}
