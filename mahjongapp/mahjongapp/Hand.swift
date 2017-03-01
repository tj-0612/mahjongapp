//
//  Hand.swift
//  mahjongapp
//
//  Created by Takashi Tajimi on 2017/02/13.
//  Copyright © 2017年 Takashi Tajimi. All rights reserved.
//

import Foundation
//メンツの種類
public enum Mentukind:Int{
    case ANKO
    case MINKO
    case PON
    case SHUNTU
    case CHII
    case ANKAN
    case MINKAN
    case KAKAN
    case TOITU
    //面前か否か
    var naki: Bool{
        switch self{
        case .ANKO: return false;
        case .MINKO: return false;
        case .PON:  return true;
        case .SHUNTU: return false;
        case .CHII: return true;
        case .ANKAN: return false;
        case .MINKAN: return true;
        case .KAKAN: return true;
        case .TOITU: return false;
        }
    }
}
//牌
public struct Pai{
    let rank: Int
    let suit: Int //-1:初期化用 0:m 1:p 2:s 3:z
    init(rank:Int, suit:Int){
        self.rank=rank;
        self.suit=suit;
    }
    //乱数からstruct Pai形式に変換
    public static func getPaisuit(painum:Int)->Int{
        if(0 <= painum && painum <= 8){
            return 0;
        }else if(9 <= painum && painum <= 17){
            return 1;
        }else if(18 <= painum && painum <= 26){
            return 2;
        }else if(27 <= painum && painum <= 33){
            return 3;
        }else{
            return -1;
        }
        
    }
    public func isnull()->Bool{
        if(suit == -1 && rank == -1){
            return true
        }
        return false
    }
    //ヤオチュー牌の判定
    public func judgeyaochu()->Bool{
        if(suit<3){
            if(rank==1 || rank==9){
                return true
            }
        }else{
            return true
        }
        return false
    }
    //数牌の判定
    public func judgekazuhai()->Bool{
        return (suit < 3)
    }
    //字牌の判定
    public func judgejihai()->Bool{
        return !(judgekazuhai())
    }
    //２つの牌が等しいかどうかの判定
    public static func paiEqual(p1:Pai,p2:Pai)->Bool{
        if(p1.rank==p2.rank && p1.suit==p2.suit){
            return true
        }
        return false
    }
    
    //乱数からstruct Pai形式に変換
    public static func getPairank(painum:Int)->Int{
        if(0 <= painum && painum <= 8){
            return painum+1;
        }else if(9 <= painum && painum <= 17){
            return (painum-9)+1;
        }else if(18 <= painum && painum <= 26){
            return (painum-18)+1;
        }else if(27 <= painum && painum <= 33){
            return (painum-27)+1;
        }else{
            return -1;
        }
    }
}
//メンツ
public struct Mentu{
    let kind:Mentukind
    let pai: Pai
    let naki: Pai //鳴いた牌
    init(kind:Mentukind,pai:Pai){
        self.kind=kind;
        self.pai=pai;
        self.naki=Pai(rank: -1,suit: -1)
    }
    //どの牌で鳴いたかを含む
    init(kind:Mentukind,pai:Pai,naki:Pai){
        self.kind=kind;
        self.pai=pai;
        self.naki=naki
    }
    //面前か否か
    public func returnnaki()->Bool{
        return kind.naki
    }
    //刻子の判定
    public func judgeKoutu()->Bool{
        if(kind==Mentukind.ANKO || kind==Mentukind.PON || kind==Mentukind.MINKO || kind==Mentukind.ANKAN || kind==Mentukind.MINKAN || kind==Mentukind.KAKAN){
            return true
        }else{
            return false
        }
    }
    //順子の判定
    public func judgeShuntu()->Bool{
        if(kind==Mentukind.SHUNTU || kind==Mentukind.CHII){
            return true
        }else{
            return false
        }
    }
    //槓子の判定
    public func judgeKantu()->Bool{
        if(kind==Mentukind.ANKAN || kind==Mentukind.MINKAN || kind==Mentukind.KAKAN){
            return true
        }else{
            return false
        }
    }
}
//リーチ(未完成)
public struct st_Richi{
    var flag:Bool
    var junme:Int
    var furiten=Array<Pai>()
    var ippatsu:Bool
    
    init(){
        self.flag=false
        self.junme = -1
        self.ippatsu=false
    }
    public mutating func doRichi(junme:Int){
        self.flag=true;
        self.junme=junme
        self.ippatsu=true;
    }
    public mutating func canselippatsu(){
        ippatsu=false;
    }
}

public class Hand{
    private var pai = Array<Pai>();
    private var naki = Array<Mentu>();
    private var shanten : Shanten
    private var sutehai = Array<Pai>();
    private var richi = st_Richi()
    
    public func isMenzen()->Bool{
        for temp in naki{
            if(temp.returnnaki()==true){
                return false
            }
        }
        return true
    }
    init(){
        self.shanten=Shanten(hand: pai, naki: naki)
    }
    public func dorichi(junme: Int){
        richi.doRichi(junme: junme)
    }
    public func getrichi()->st_Richi{
        return richi
    }
    public func getnaki()->[Mentu]{
        return naki
    }
    public func getForm()->Int{
        return shanten.getForm()
    }
    
    public func getpai()->[Pai]{
        return pai
    }
    public func getsutehai()->[Pai]{
        return sutehai
    }
    public func addsutehai(sutehai: Pai){
        self.sutehai.append(sutehai)
    }
    
    public func tsumo(pai:Pai){
        self.pai.append(pai);
        
    }
    public func sort(){
        pai.sort{ $0.suit != $1.suit ? $0.suit<$1.suit : $0.rank<$1.rank}
    }
    public func kiru(index:Int){
        sutehai.append(pai[index]);
        pai.remove(at: index);
        sort()
    }
}








