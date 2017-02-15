//
//  Hand.swift
//  mahjongapp
//
//  Created by Takashi Tajimi on 2017/02/13.
//  Copyright © 2017年 Takashi Tajimi. All rights reserved.
//

import Foundation
public enum Mentukind{
    case ANKO
    case MINKO
    case SHUNTU
    case CHII
    case ANKAN
    case MINKAN
    case KAKAN
    case TOITU
    
    var naki: Bool{
        switch self{
        case .ANKO: return false;
        case .MINKO: return true;
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
struct Mentu{
    let kind:Int
    let pai: Pai
    init(kind:Int,pai:Pai){
        self.kind=kind;
        self.pai=pai;
    }
}

public class Hand{
    private var pai = Array(repeating: Pai(rank:-1,suit:-1),count: 13);
    private var naki = Array<Mentu>();
    private var shanten : Shanten = Shanten();
    private var sutehai = Array<Pai>();
    
    init(){
    }

    public func tsumo(pai:Pai){
        self.pai.append(pai);
        
    }
    
    public func kiru(index:Int){
        sutehai.append(pai[index]);
        pai.remove(at: index);
    }
}








