//
//  playerAI0.swift
//  mahjongapp
//
//  Created by Takashi Tajimi on 2017/03/27.
//  Copyright © 2017年 Takashi Tajimi. All rights reserved.
//

import Foundation
//
//  playerAI.swift
//  mahjongapp
//
//  Created by Takashi Tajimi on 2017/03/13.
//  Copyright © 2017年 Takashi Tajimi. All rights reserved.
//

//ツモ切りだけするやつ
public class playerAI0{
    private var point = 25000;
    private var hand = Hand();
    private var id:Int;
    init(id:Int){
        self.id=id
    }
    func play(){
        let border = estimateRichiMain()
        let exp = estimateHandMain()
        if(border<=exp){
            hand.kiru(index: 13)
        }
    }
    //0なし1ポン2チー3カン4ロン？
    func judgenaki()->Int{
        return 0
    }
    
    var nokori = Array(repeating: 4,count:34)
    //nokoriから重み付けされた乱数より牌を得る
    private func getRandomIndex()->Int{
        let totalWeight = nokori.reduce(0,+)
        var value = (Int)(arc4random_uniform(UInt32(totalWeight))) + 1
        var retIndex = -1;
        for i in 0...33
        {
            if (nokori[i] >= value)
            {
                retIndex = i;
                break;
            }
            value -= nokori[i];
        }
        return retIndex;
    }
    func estimateHandMain()->Int{
        let point=1000
        return point
    }
    func estimateRichiMain()->Int{
        let point=0
        return point
    }
        //引数は見えるようになった牌または鳴きメンツを入力する
    func updatenokori(pai:Pai){
        nokori[pai.suit*9 + pai.rank-1] -= 1
    }
    func updatenokori(mentu:Mentu){
        let pai = mentu.pai
        switch mentu.kind{
        case Mentukind.PON: nokori[pai.suit*9 + pai.rank-1] -= 3
        case Mentukind.CHII:
            nokori[pai.suit*9 + pai.rank-1] -= 1
            nokori[pai.suit*9 + pai.rank] -= 1
            nokori[pai.suit*9 + pai.rank+1] -= 1
        case Mentukind.ANKAN:fallthrough
        case Mentukind.MINKAN:fallthrough
        case Mentukind.KAKAN:nokori[pai.suit*9 + pai.rank-1] -= 4
        default:break;
        }
        //鳴かれた牌が多分１つ少なくなる、ここで修正するか呼び出されるところで修正するか考える
        
        /* ここで修正する場合
         pai=mentu.naki
         nokori[pai.suit*9 + pai.rank-1] += 1
         */
    }
    
}
