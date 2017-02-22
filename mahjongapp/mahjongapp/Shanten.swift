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
    private var titoishanten=6;
    private var kokushishanten=13;
    private var machi=Array<Pai>()
    
    
    private var mentu=0
    private var toitu=0
    private var tatsu=0
    
    //最もシャンテン数の小さい上がり形式を返す(一般形:0七対子形:1国士無双形:2
    public func getForm()->Int{
        if(normalshanten<=titoishanten && normalshanten<kokushishanten){
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
        self.shanten=8
        self.normalshanten=8
        self.titoishanten=6
        self.kokushishanten=13
        self.mentu=0
        self.toitu=0
        self.tatsu=0
        calcNormalShanten()
        calcTitoiShanten()
        calcKokushiShanten()
        if(getShanten()==0){
            setMachi()
        }
    }
    
    private func maketemphand()->[[Int]]{
        var temphand:[[Int]]=Array(repeating: Array(repeating:0 ,count: 9), count: 4)
        
        for pai in hand{
            temphand[pai.suit][pai.rank]+=1;
        }
        return temphand

    }
    //ターツを切り出す
    private func tatsucut(hand:[[Int]]){
        var temphand=hand
        var tempshanten=8
        for i in 0...3{
            for j in 0 ... 8{
                //対子
                if(temphand[i][j]>=2){
                    tatsu+=1
                    temphand[i][j]-=2
                    tatsucut(hand:temphand)
                    temphand[i][j]+=2
                    tatsu-=1
                }
                //順子（リャンメンまたはペンチャン
                if(temphand[i][j]>0 && temphand[i][j+1]>0 && i<3 && j<8){
                    tatsu+=1
                    temphand[i][j]-=1
                    temphand[i][j+1]-=1
                    tatsucut(hand:temphand)
                    temphand[i][j]+=1
                    temphand[i][j+1]+=1
                    tatsu-=1
                }
                //順子（カンチャン
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
    //メンツを切り出す
    private func mentucut(hand:[[Int]]){
        var temphand=hand
        for i in 0 ... 3{
            for j in 0 ... 8{
                //刻子
                if(temphand[i][j]>=3){
                    mentu+=1
                    temphand[i][j]-=3
                    mentucut(hand:temphand)
                    temphand[i][j]+=3
                    mentu-=1
                }
                //順子
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
    //一般形のシャンテン数を計算するときはこの関数を呼び出す
    public func calcNormalShanten(){
        mentu=0;
        toitu=0;
        tatsu=0;
        var temphand = maketemphand()
        normalshanten=8
        for i in 0 ... 3{
            for j in 0...8{
                //頭の切り出し
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
    //七対子形のシャンテン数の計算
    public func calcTitoiShanten(){
        titoishanten=6;
        var temphand = maketemphand()
        var kind=0
        //面前でない時シャンテン数は存在しないのでmaxの値としておく
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
        //４枚使いの七対子を避ける
        if(kind<7){
            titoishanten+=7-kind;
        }
    }
    //国士無双のシャンテン数の計算
    public func calcKokushiShanten(){
        var temp = 13 //シャンテン数
        var toitu = false
        var temphand=maketemphand()
        for i in 0...3{
            for j in 0...8{
                //数牌
                if(i <= 2){
                    if(j==1 || j==9){
                        if(temphand[i][j]>=1){
                            //ヤオチュー牌があれば
                            temp -= 1
                        }else if(temphand[i][j]>=2 && !toitu){
                            //2枚使いのものがあれば
                            toitu=true
                        }
                    }
                }
                //字牌
                else if(i==3){
                    if(temphand[i][j]>=1){
                        temp -= 1
                    }else if(temphand[i][j]>=2 && !toitu){
                        toitu=true
                    }
                }
            }
        }
        //２枚使いのものがあればシャンテン数を１減らす
        temp -= toitu ? 1 : 0
        kokushishanten=temp
    }
    
    private func normalMachi(){
        var temphand=maketemphand()
        
        for i in 0...3{
            for j in 1...9{
                if(temphand[i][j-2]>=1 || temphand[i][j-1]>=1 || temphand[i][j]>=1){
                    hand.append(Pai(rank: j,suit: i))
                    let temp = normalshanten
                    calcNormalShanten()
                    if(normalshanten == -1){
                        machi.append(Pai(rank: j,suit: i))
                    }
                    normalshanten=temp
                    hand.remove(at: hand.count - 1)
                }
            }
        }
    }
    private func titoiMachi(){
        var temphand = maketemphand()
        for i in 0...3{
            for j in 0...8{
                //無い物があればそれを待ちにしてreturn
                if(temphand[i][j-1]==1){
                    machi.append(Pai(rank: j+1,suit: i))
                    return
                }
            }
        }
    }
    
    private func kokushiMachi(){
        var toitu=false
        var temphand=maketemphand()
        for i in 0...3{
            for j in 0...8{
                //数牌
                if(i <= 2){
                    if(j==1 || j==9){
                        //無い物があればそれを待ちにしてreturn
                        if(temphand[i][j]==0){
                            machi.append(Pai(rank: j+1, suit: i))
                            return
                        }
                        if(temphand[i][j]>=2 && !toitu){
                            //2枚使いのものがあれば
                            toitu=true
                        }
                    }
                }
                //字牌
                else if(i==3){
                    if(temphand[i][j]==0){
                        machi.append(Pai(rank: j+1, suit: i))
                        return
                    }
                    if(temphand[i][j]>=2 && !toitu){
                        toitu=true
                    }
                }
            }
        }
        //２枚使いがない->13面待ち
        if(!toitu){
            for i in 0...2{
                machi.append(Pai(rank: 1,suit: i))
                machi.append(Pai(rank: 9,suit: i))
            }
            for i in 1...7{
                machi.append(Pai(rank: i,suit: 3))
            }
        }
    }
    
    //待ちの計算(有効牌の計算アルゴリズムを流用予定)
    //テンパイしている時に呼び出される前提のアルゴリズムなのでテンパイしていない時の有効牌は計算できない
    private func setMachi(){
        switch getForm(){
        case 0: normalMachi()
        case 1: titoiMachi()
        case 2: kokushiMachi()
        default: break
        }
    }
}
