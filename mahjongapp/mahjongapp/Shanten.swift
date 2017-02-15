//
//  AbstractShanten.swift
//  mahjongapp
//
//  Created by Takashi Tajimi on 2017/02/13.
//  Copyright © 2017年 Takashi Tajimi. All rights reserved.
//

import Foundation

public class Shanten{
    private var hand=Array<Pai>();
    private var naki=Array<Mentu>();
    private var shanten=8;
    private var normalshanten=8;
    private var titoishanten:Int;
    private var kokushishanten:Int;
    private var Machi=Array<Pai>()
    
    
    private var mentu=0
    private var toitu=0
    private var tatsu=0
    
    public func getForm()->Int{
        if(normalshanten<titoishanten && normalshanten<kokushishanten){
            return 0
        }else if(titoishanten<kokushishanten){
            return 1
        }else{
            return 2
        }
    }
    public func getShanten()->Int{
        return min(normalshanten, titoishanten, kokushishanten)
    }
    
    init(hand:[Pai],naki:[Mentu]){
        self.hand=hand;
        self.naki=naki;
        self.calcNormalShanten()
        self.calcTitoiShanten()
        self.calcKokushiShanten()
    }
    
    private func maketemphand()->[[Int]]{
        var temphand:[[Int]]=Array(repeating: Array(repeating:0 ,count: 9), count: 4)
        
        for pai in hand{
            temphand[pai.suit][pai.rank]+=1;
        }
        return temphand

    }
    private func tatsucut(hand:[[Int]]){
        var temphand=hand
        var tempshanten=8
        for i in 0...3{
            for j in 0 ... 8{
                if(temphand[i][j]>=2){
                    tatsu+=1
                    temphand[i][j]-=2
                    tatsucut(hand:temphand)
                    temphand[i][j]+=2
                    tatsu-=1
                }
                if(temphand[i][j]>0 && temphand[i][j+1]>0 && i<3 && j<8){
                    tatsu+=1
                    temphand[i][j]-=1
                    temphand[i][j+1]-=1
                    tatsucut(hand:temphand)
                    temphand[i][j]+=1
                    temphand[i][j+1]+=1
                    tatsu-=1
                }
                if(temphand[i][j]>0&&temphand[i][j+2]>0 && i<3 && j<6){
                    tatsu+=1
                    temphand[i][j]-=1
                    temphand[i][j+2]-=1
                    tatsucut(hand:temphand)
                    temphand[i][j]+=1
                    temphand[i][j+2]+=1
                    tatsu-=1
                }
            }
        }
        tempshanten=8-mentu*2-tatsu-toitu-naki.count*2;
        if(normalshanten>tempshanten){
            normalshanten=tempshanten
        }
    }
    
    private func mentucut(hand:[[Int]]){
        var temphand=hand
        for i in 0 ... 3{
            for j in 0 ... 8{
                if(temphand[i][j]>=3){
                    mentu+=1
                    temphand[i][j]-=3
                    mentucut(hand:temphand)
                    temphand[i][j]+=3
                    mentu-=1
                }
                if(temphand[i][j]>0 && temphand[i][j+1]>0 && temphand[i][j+2]>0 && i<3){
                    mentu+=1
                    temphand[i][j]-=1
                    temphand[i][j+1]-=1
                    temphand[i][j+2]-=1
                    mentucut(hand:temphand)
                    temphand[i][j]+=1
                    temphand[i][j+1]+=1
                    temphand[i][j+2]+=1
                    mentu-=1
                }
            }
        }
        tatsucut(hand:temphand)
    }
    
    public func calcNormalShanten(){
        mentu=0;
        toitu=0;
        tatsu=0;
        var temphand = maketemphand()
        normalshanten=8
        for i in 0 ... 3{
            for j in 0...8{
                if(temphand[i][j]>=2){
                    toitu+=1
                    temphand[i][j]-=2;
                    mentucut(hand:temphand)
                    temphand[i][j]+=2
                    toitu-=1
                }
            }
        }
    }
    public func calcTitoiShanten(){
        titoishanten=6;
        var temphand = maketemphand()
        var kind=0
        if(naki.isEmpty==false){
            titoishanten=14;
            return
        }
        for i in 0...3{
            for j in 0...8{
                if(temphand[i][j]>0){
                    kind += 1;
                }
                if(temphand[i][j]>=2){
                    toitu += 1;
                }
            }
        }
        titoishanten=6-toitu;
        if(kind<7){
            titoishanten+=7-kind;
        }
    }
    public func calcKokushiShanten(){
        
    }
    
    private func setMachi(){
        
    }
}
