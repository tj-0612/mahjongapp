//
//  playerAI.swift
//  mahjongapp
//
//  Created by Takashi Tajimi on 2017/03/13.
//  Copyright © 2017年 Takashi Tajimi. All rights reserved.
//

import Foundation

struct kikenpai{
    var pai:Pai
    var p:Double
    init(pai:Pai,p:Double){
        self.pai=pai
        self.p=p
    }
}

//未検証
//捨て牌に応じた上がり推定の実装がまだ
//複数回繰り返して平均得点を推定したのちに自分の得点と照らし合わせる処理がまだ
//危険牌を管理する処理がまだ
public class playerAI{
    private var point = 25000;
    private var hand = Hand();
    private var id:Int;
    init(id:Int){
        self.id=id
    }
    func play(){
        
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
    func estimateRichiMain(){
        var point=0
        for _ in 1...100{
            point += estimateRichiHand()
        }
        point /= 100
    }
    func estimateRichiHand()->Int{
        var estimatehand = Hand()
        var point=0
        var agari:Agari
        var agarihai:Pai
        //頭の生成
        while(true){
            let pai=getRandomIndex()
            if(pai == -1){
                print("error")
                return 0
            }else if(nokori[pai]>=2){
                nokori[pai] -= 2
                estimatehand.tsumo(pai: Pai(rank:pai%9,suit:pai/9))
                estimatehand.tsumo(pai: Pai(rank:pai%9,suit:pai/9))
                break
            }
        }
        //メンツの生成(最後ひとつはターツにするべきかも->するなら1...3にしてこの後ろに新しく記述->とりあえず書いてみた)
        //生成できないとき無限ループが起こると思うので要修正->ループの場所を変えてrandの値も毎回変動させれば解決かな->とりあえず書いてみた
        for _ in 1...3{
            while(true){
                let rand=(Int)(arc4random_uniform(5))
                if(rand==0){
                    let pai=getRandomIndex()
                    if(pai == -1){
                        print("error")
                        return 0
                    }else if(nokori[pai]>=3){
                        nokori[pai] -= 3
                        estimatehand.tsumo(pai: Pai(rank:pai%9,suit:pai/9))
                        estimatehand.tsumo(pai: Pai(rank:pai%9,suit:pai/9))
                        estimatehand.tsumo(pai: Pai(rank:pai%9,suit:pai/9))
                        break
                    }
                }else{
                    let pai=getRandomIndex()
                    if(pai == -1){
                        print("error")
                        return 0
                    }else if !(pai>=27 || pai%9>=7) {
                        if(nokori[pai]>=1 && nokori[pai+1]>=1 && nokori[pai+2]>=1){
                            nokori[pai] -= 1
                            nokori[pai+1] -= 1
                            nokori[pai+2] -= 1
                            estimatehand.tsumo(pai: Pai(rank:(pai)%9,suit:(pai)/9))
                            estimatehand.tsumo(pai: Pai(rank:(pai+1)%9,suit:(pai+1)/9))
                            estimatehand.tsumo(pai: Pai(rank:(pai+2)%9,suit:(pai+2)/9))
                            break
                        }
                    }
                }
            }
        }
        while(true){
            let rand=(Int)(arc4random_uniform(8))
            //シャボ待ち
            if(rand==0){
                let pai=getRandomIndex()
                if(pai == -1){
                    print("error")
                    return 0
                }else if(nokori[pai]>=2){
                    nokori[pai] -= 2
                    agarihai=Pai(rank:pai%9,suit:pai/9)
                    estimatehand.tsumo(pai: Pai(rank:(pai)%9,suit:(pai)/9))
                    estimatehand.tsumo(pai: Pai(rank:(pai)%9,suit:(pai)/9))
                    break
                }
            }else if(rand<=6){//シュンツ
                let pai=getRandomIndex()
                if(pai == -1){
                    print("error")
                    return 0
                }else if !(pai>=27 || pai%9<=7) {
                    if(rand<=4 && (pai%9) != 0 && nokori[pai]>=1 && nokori[pai+1]>=1){
                        nokori[pai] -= 1
                        nokori[pai+1] -= 1
                        estimatehand.tsumo(pai: Pai(rank:(pai)%9,suit:(pai)/9))
                        estimatehand.tsumo(pai: Pai(rank:(pai+1)%9,suit:(pai+1)/9))
                        break
                    }else if(rand==5 && nokori[pai]>=1 && nokori[pai+2]>=1){//カンチャン待ち
                        nokori[pai] -= 1
                        nokori[pai+2] -= 1
                        estimatehand.tsumo(pai: Pai(rank:(pai)%9,suit:(pai)/9))
                        estimatehand.tsumo(pai: Pai(rank:(pai+2)%9,suit:(pai+2)/9))
                        break
                    }else if((pai%9==0 || pai%9==8) && rand==6){//ペンチャン待ち
                        if(pai%9==0 && nokori[pai]>=1 && nokori[pai+1]>=1){
                            nokori[pai] -= 1
                            nokori[pai+1] -= 1
                            estimatehand.tsumo(pai: Pai(rank:(pai)%9,suit:(pai)/9))
                            estimatehand.tsumo(pai: Pai(rank:(pai+1)%9,suit:(pai+1)/9))
                            break
                        }else if(pai%9==8 && nokori[pai]>=1 && nokori[pai+1]>=1){
                            nokori[pai] -= 1
                            nokori[pai+1] -= 1
                            estimatehand.tsumo(pai: Pai(rank:(pai)%9,suit:(pai)/9))
                            estimatehand.tsumo(pai: Pai(rank:(pai+1)%9,suit:(pai+1)/9))
                            break
                        }
                    }
                }
            }
        }
        //単騎待ちは面倒なので無視、多分影響は小さい（と思ったけどノベタンの形は多いので無視できなさそう）->作るなら頭を生成する最初のところを幾らかの確率で１枚だけ生成する
        
        //待ちを計算（多面チャンの場合があるので手牌13枚を生成したのちにsetMachiで待ちを計算する）
        //得点計算
        
        //nokoriの修正
        for p in estimatehand.getpai(){
            nokori[p.suit*9 + p.rank-1] += 1
        }
        
        return point
    }
    //返り値は得点　アンカンを含む時処理できない->どこかで引数にアンカンがあることをもらって渡す
    //アンカンを修正できればうまく用いることで鳴き手の推定もできるはず
    //Mentuで作るよりHandで作ってAgariに直接渡す方がいいかも->修正版が上
    /*func estimateRichiHand()->Int{
        var estimatehand = Array<Mentu>()
        var point=0
        var agari:Agari
        var agarihai:Pai
        //頭の生成
        while(true){
            let pai=getRandomIndex()
            if(pai == -1){
                print("error")
                return 0
            }else if(nokori[pai]>=2){
                nokori[pai] -= 2
                estimatehand.append(Mentu(kind: Mentukind.TOITU, pai: Pai(rank:pai%9 ,suit:pai/9)))
            }
        }
        //メンツの生成(最後ひとつはターツにするべきかも->するなら1...3にしてこの後ろに新しく記述->とりあえず書いてみた)
        //生成できないとき無限ループが起こると思うので要修正->ループの場所を変えてrandの値も毎回変動させれば解決かな->とりあえず書いてみた
        for _ in 1...3{
            while(true){
                let rand=(Int)(arc4random_uniform(5))
                if(rand==0){
                    let pai=getRandomIndex()
                    if(pai == -1){
                        print("error")
                        return 0
                    }else if(nokori[pai]>=3){
                        nokori[pai] -= 3
                        estimatehand.append(Mentu(kind: Mentukind.ANKO, pai: Pai(rank:pai%9 ,suit:pai/9)))
                        break
                    }
                }else{
                    let pai=getRandomIndex()
                    if(pai == -1){
                        print("error")
                        return 0
                    }else if !(pai>=27 || pai%9>=7) {
                        if(nokori[pai]>=1 && nokori[pai+1]>=1 && nokori[pai+2]>=1){
                            nokori[pai] -= 1
                            nokori[pai+1] -= 1
                            nokori[pai+2] -= 1
                            estimatehand.append(Mentu(kind: Mentukind.SHUNTU, pai: Pai(rank:pai%9 ,suit:pai/9)))
                            break
                        }
                    }
                }
            }
        }
        while(true){
            let rand=(Int)(arc4random_uniform(8))
            //シャボ待ち
            if(rand==0){
                let pai=getRandomIndex()
                if(pai == -1){
                    print("error")
                    return 0
                }else if(nokori[pai]>=2){
                    nokori[pai] -= 2
                    agarihai=Pai(rank:pai%9,suit:pai/9)
                    estimatehand.append(Mentu(kind: Mentukind.MINKO, pai: Pai(rank:pai%9 ,suit:pai/9)))
                }
            }else if(rand<=6){//シュンツ
                let pai=getRandomIndex()
                if(pai == -1){
                    print("error")
                    return 0
                }else if !(pai>=27 || pai%9>=7) {
                    if(nokori[pai]>=1 && nokori[pai+1]>=1 && nokori[pai+2]>=1){
                        if (pai%9>0 && rand<=4){//両面待ち
                            if(rand==1 || rand==2){
                                nokori[pai] -= 1
                                nokori[pai+1] -= 1
                                agarihai=Pai(rank:(pai+2)%9 ,suit:(pai+2)/9)
                                estimatehand.append(Mentu(kind: Mentukind.SHUNTU, pai: Pai(rank:pai%9 ,suit:pai/9)))
                                break
                            }else{
                                nokori[pai+1] -= 1
                                nokori[pai+2] -= 1
                                agarihai=Pai(rank:(pai)%9 ,suit:(pai)/9)
                                estimatehand.append(Mentu(kind: Mentukind.SHUNTU, pai: Pai(rank:(pai+1)%9 ,suit:(pai+1)/9)))
                                break
                            }
                        }else if(rand==5){//カンチャン待ち
                            nokori[pai] -= 1
                            nokori[pai+2] -= 1
                            agarihai=Pai(rank:(pai+1)%9 ,suit:(pai+1)/9)
                            estimatehand.append(Mentu(kind: Mentukind.SHUNTU, pai: Pai(rank:pai%9 ,suit:pai/9)))
                            break
                        }else if((pai%9==0 || pai%9==8) && rand==6){//ペンチャン待ち
                            if(pai%9==0){
                                nokori[pai] -= 1
                                nokori[pai+1] -= 1
                                agarihai=Pai(rank:(pai+2)%9 ,suit:(pai+2)/9)
                                estimatehand.append(Mentu(kind: Mentukind.SHUNTU, pai: Pai(rank:pai%9 ,suit:pai/9)))
                                break
                            }else if(pai%9==8){
                                nokori[pai+1] -= 1
                                nokori[pai+2] -= 1
                                agarihai=Pai(rank:(pai)%9 ,suit:(pai)/9)
                                estimatehand.append(Mentu(kind: Mentukind.SHUNTU, pai: Pai(rank:pai%9 ,suit:pai/9)))
                                break
                            }
                        }
                    }
                }
            }
        }
        //単騎待ちは面倒なので無視、多分影響は小さい
        //得点計算
        
        //nokoriの修正
        for e in estimatehand{
            if e.kind==Mentukind.TOITU{
                nokori[e.pai.suit*9 + e.pai.rank-1] += 2
            }else if e.kind==Mentukind.ANKO{
                nokori[e.pai.suit*9 + e.pai.rank-1] += 3
            }else if e.kind==Mentukind.SHUNTU{
                nokori[e.pai.suit*9 + e.pai.rank-1] += 1
                nokori[e.pai.suit*9 + e.pai.rank] += 1
                nokori[e.pai.suit*9 + e.pai.rank+1] += 1
            }
        }
        
        return point
    }
     */
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
