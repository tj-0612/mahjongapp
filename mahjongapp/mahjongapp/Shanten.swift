//
//  AbstractShanten.swift
//  mahjongapp
//
//  Created by Takashi Tajimi on 2017/02/13.
//  Copyright © 2017年 Takashi Tajimi. All rights reserved.
//

import Foundation

public class Shanten{
    private var hand:Hand;
    private var shanten=8;
    private var normalshanten:NormalShanten ;
    private var titoishanten:TitoiShanten ;
    private var kokushishanten:KokushiShanten;
    public func getShanten(){
        
    }
    
    init(hand:Hand){
        self.hand=hand;
        self.normalshanten=NormalShanten(hand: self.hand)
        self.titoishanten=TitoiShanten(hand: self.hand)
        self.kokushishanten=KokushiShanten(hand: self.hand)
    }
}
