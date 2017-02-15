//
//  Mahjong.swift
//  mahjongapp
//
//  Created by Takashi Tajimi on 2017/02/13.
//  Copyright © 2017年 Takashi Tajimi. All rights reserved.
//

import Foundation

enum Yaku_enum{
    case YAKU_TON
    case YAKU_NAN
    case YAKU_SHA
    case YAKU_PE
    case YAKU_HAKU
    case YAKU_HATSU
    case YAKU_CHUN
    case DORA
    case RICHI
    case IPPATSU
    case TSUMO
    case TANNYAO
    case PINFU
    case IPEKO
    case HAITEITSUMO
    case HAITEIRON
    case RINSHANKAIHO
    case CYANKAN
    case TOITOI
    case SANSHOKUDOJUN
    case CHITOI
    case ITTSU
    case SANANKO
    case CHANTA
    case SANSHOKUDOKO
    case SANKANTSU
    case DABURI
    case HONITSU
    case JUNCHAN
    case RYANPEKO
    case SHOSANGEN
    case HONROTO
    case CHINITSU
    
    var score: Int{
        switch self{
        case .YAKU_TON: return 1;
        case .YAKU_NAN: return 1;
        case .YAKU_SHA: return 1;
        case .YAKU_PE: return 1;
        case .YAKU_HAKU: return 1;
        case .YAKU_HATSU: return 1;
        case .YAKU_CHUN: return 1;
        case .DORA: return 1;
        case .RICHI: return 1;
        case .IPPATSU: return 1;
        case .TSUMO: return 1;
        case .TANNYAO: return 1;
        case .PINFU: return 1;
        case .IPEKO: return 1;
        case .HAITEITSUMO: return 1;
        case .HAITEIRON: return 1;
        case .RINSHANKAIHO: return 1;
        case .CYANKAN: return 1;
        case .TOITOI: return 2;
        case .SANSHOKUDOJUN: return 2;
        case .CHITOI: return 2;
        case .ITTSU: return 2;
        case .SANANKO: return 2;
        case .CHANTA: return 2;
        case .SANSHOKUDOKO: return 2;
        case .SANKANTSU: return 2;
        case .DABURI: return 2;
        case .HONITSU: return 3;
        case .JUNCHAN: return 3;
        case .RYANPEKO: return 3;
        case .SHOSANGEN: return 2;
        case .HONROTO: return 2;
        case .CHINITSU: return 6;
        }
    }

    class Mahjong{
        private var yama = Array(repeating: Pai(rank: -1,suit: -1),count:136);
        private var bahuu = 1;
        private var player = [Player(id: 0),Player(id:1),Player(id:2),Player(id:3)];
        private var countkan=0;
        private var yamanokori:Int;
        private var dora = Array<Pai>();
        
        init(){
            self.yamaInit()
        }
        public func yamaInit(){
            self.yamanokori = 136
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
        }
        
        public func gameMain(){
            var i=0
            yamaInit()
            haipai()
            
            while(agari==true){
                tsumo(id: i)
            }
        }

    }
}
