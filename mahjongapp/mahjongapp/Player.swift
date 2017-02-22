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
    //リーチの実行
    public func dorichi(junme: Int){
        hand.dorichi(junme: junme)
    }
    //打牌、鳴き、上がり、リーチ
    public func play(select:Int)->Bool{
        return false
    }
    //COMプレイヤーの打牌など
    public func autoPlay(){
        
    }
    
    public func tsumo(pai:Pai){
        hand.tsumo(pai: pai);
    }
    
}
