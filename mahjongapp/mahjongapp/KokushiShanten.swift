//
//  KokushiShanten.swift
//  mahjongapp
//
//  Created by Takashi Tajimi on 2017/02/13.
//  Copyright © 2017年 Takashi Tajimi. All rights reserved.
//

import Foundation

public class KokushiShanten{
    private var hand:Hand
    private var shanten:Int=8
    
    init(hand:Hand){
        self.hand=hand;
        self.calcShanten()
    }
    
    public func calcShanten(){
        self.shanten = 8;
    }
    public func getShanten()->Int{
        return shanten;
    }
}
