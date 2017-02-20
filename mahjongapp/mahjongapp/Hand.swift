//
//  Hand.swift
//  mahjongapp
//
//  Created by Takashi Tajimi on 2017/02/13.
//  Copyright © 2017年 Takashi Tajimi. All rights reserved.
//

import Foundation
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
public struct Pai{
    let rank: Int
    let suit: Int //-1:初期化用 0:m 1:p 2:s 3:z
    init(rank:Int, suit:Int){
        self.rank=rank;
        self.suit=suit;
    }
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
    public func judgekazuhai()->Bool{
        return (suit < 3)
    }
    
    public func judgejihai()->Bool{
        return !(judgekazuhai())
    }
    public static func paiEqual(p1:Pai,p2:Pai)->Bool{
        if(p1.rank==p2.rank && p1.suit==p2.suit){
            return true
        }
        return false
    }
    
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
public struct Mentu{
    let kind:Mentukind
    let pai: Pai
    let naki: Pai
    init(kind:Mentukind,pai:Pai){
        self.kind=kind;
        self.pai=pai;
        self.naki=Pai(rank: -1,suit: -1)
    }
    init(kind:Mentukind,pai:Pai,naki:Pai){
        self.kind=kind;
        self.pai=pai;
        self.naki=naki
    }
    
    public func returnnaki()->Bool{
        return kind.naki
    }
    public func judgeKoutu()->Bool{
        if(kind==Mentukind.ANKO || kind==Mentukind.PON || kind==Mentukind.MINKO || kind==Mentukind.ANKAN || kind==Mentukind.MINKAN || kind==Mentukind.KAKAN){
            return true
        }else{
            return false
        }
    }
    
    public func judgeShuntu()->Bool{
        if(kind==Mentukind.SHUNTU || kind==Mentukind.CHII){
            return true
        }else{
            return false
        }
    }
    
    public func judgeKantu()->Bool{
        if(kind==Mentukind.ANKAN || kind==Mentukind.MINKAN || kind==Mentukind.KAKAN){
            return true
        }else{
            return false
        }
    }
}
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
}

public class Hand{
    private var pai = Array(repeating: Pai(rank:-1,suit:-1),count: 13);
    private var naki = Array<Mentu>();
    private var shanten : Shanten
    private var sutehai = Array<Pai>();
    private var richi = st_Richi()
    
    public func returnnaki()->Bool{
        for temp in naki{
            if(temp.returnnaki()==true){
                return true
            }
        }
        return false
    }
    init(){
        self.shanten=Shanten(hand: pai, naki: naki)
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
    
    
    public func tsumo(pai:Pai){
        self.pai.append(pai);
        
    }
    
    public func kiru(index:Int){
        sutehai.append(pai[index]);
        pai.remove(at: index);
    }
}








