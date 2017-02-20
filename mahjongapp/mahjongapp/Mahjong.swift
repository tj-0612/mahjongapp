//
//  Mahjong.swift
//  mahjongapp
//
//  Created by Takashi Tajimi on 2017/02/13.
//  Copyright © 2017年 Takashi Tajimi. All rights reserved.
//

import Foundation


class Mahjong{
    private var yama = Array(repeating: Pai(rank: -1,suit: -1),count:136);
    private var bahuu = 1;
    private var player = [Player(id: 0),Player(id:1),Player(id:2),Player(id:3)];
    private var countkan=0;
    private var yamanokori:Int;
    private var dora = Array<Pai>();
    private var junme:Int
    
    init(){
        self.yamaInit()
    }
    //山生成
    public func yamaInit(){
        self.yamanokori = 136
        self.junme=0
        var painum = Array(repeating: 4,count:34)
        for i in 0 ... 135{
            var rand:Int;
            repeat {
                rand=(Int)(arc4random_uniform(34));
            }while(painum[rand] != 0)
            self.yama[i]=Pai(rank: Pai.getPairank(painum: rand), suit:Pai.getPaisuit(painum: rand));
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
    }
    public func tsumo(id:Int){
        let temp = self.yama[0];
        self.yama.remove(at:0);
        yamanokori -= 1;
        player[id].tsumo(pai: temp);
        junme+=1
    }
    
    //ゲーム進行(未実装)
    public func gameMain(){
        var i=0
        yamaInit()
        haipai()
        
        while(agari==false){
            tsumo(id: i)
            player[i].play(select: hoge)
            
            
            
        }
    }

}

