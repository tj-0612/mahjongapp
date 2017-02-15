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
    
    
    init(id:Int){
        self.id = id;
        
    }
    
    public func play(select:Int){
        
    }
    
    public func tsumo(pai:Pai){
        hand.tsumo(pai: pai);
    }
    
}
