//: Playground - noun: a place where people can play

import UIKit
//: Playground - noun: a place where people can play

import UIKit


public protocol PublicPlayer {
    func pause()
}

internal protocol InternalPlayer {
    func pauseSecret()
}

class Player: PublicPlayer {
    func pause() {
        print("public")
    }
}

extension Player: InternalPlayer {
    func pauseSecret() {
        print("secret")
    }
}


//func ip<IP>(_ ip: IP.Type, casted: Casted<IP, PublicPlayer>) {
//        if let internalProtocol = self as? IP {
//            casted(internalProtocol, nil)
//        } else {
//            casted(nil, self)
//        }
//}

let player: PublicPlayer = Player()
let anInternalPlayer: InternalPlayer = Player()

precedencegroup PG1 {
    associativity: left
    higherThan: PG2
}

precedencegroup PG2 {
    associativity: left
    higherThan: PG3
}

precedencegroup PG3 {
    associativity: left
}


infix operator ^^ : PG1
infix operator >> : PG2
infix operator && : PG3

typealias Casted<IP: Protocol, P: PublicPlayer> = (IP?, P?) -> Void
struct ProtocolProxy<IP> {
    let externalProtocol: PublicPlayer
    let internalProtocol: IP.Type
}
//func >><IP>(externalProtocol: PublicPlayer, internalProtocol: IP.Type) -> ProtocolProxy<IP> {
//    return ProtocolProxy(externalProtocol: externalProtocol, internalProtocol: internalProtocol)
//}
//func **<IP>(proxy: ProtocolProxy<IP>, casted: Casted<IP, PublicPlayer>) {
//    if let internalProtocol = proxy.externalProtocol as? IP {
//        casted(internalProtocol, nil)
//    } else {
//        casted(nil, proxy.externalProtocol)
//    }
//}
typealias AnyFunc = (Void) -> Void
struct PP<P, IP> {
    let p: P
    let ip: IP.Type
    init(p: P, ip: IP.Type) {
        self.p = p
        self.ip = ip
    }
}

struct WithFunc<P, IP> {
    let pp: PP<P, IP>
    let anyFunc: AnyFunc
}

struct IP<I> {
    let i: I
    init(_ i: I) {
        self.i = i
    }
}


func ^^<P, IP>(p: P, ip: IP.Type) -> PP<P, IP> {
    return PP(p: p, ip: ip)
}

func >><P, IP>(pp: PP<P, IP>, anyFunc: @escaping AnyFunc) -> WithFunc<P, IP> {
    return WithFunc(pp: pp, anyFunc: anyFunc)
}

func &&<P, IP>(withFunc: WithFunc<P, IP>, anyFunc: @escaping AnyFunc) {
    if let internalProtocol = withFunc.pp.p as? IP {
        anyFunc()
    } else {
        withFunc.anyFunc()
    }
}

//(player as? InternalPlayer)?.pauseSecret() ?? player.pause()
//player >> InternalPlayer.self ** { i, p in i?.pauseSecret(); p?.pause() }
//player^.p.pause()
//    ( (player^InternalPlayer.self).pause() )&.pauseSecret()
// player^^InternalPlayer.self>>pauseSecret()&&.pauseSecret()
(player^^InternalPlayer.self)>>player.pause&&anInternalPlayer.pauseSecret

//func **(lfh: )
//
//player.pause() ~? (InternalPlayer.self) { casted in casted.pauseSecret }
//player.pause() ~? (InternalPlayer.self, #selector(InternalPlayer.pauseSecret)


//

//
//func >><IP: Protocol>(externalProtocol: Protocol, internalProtocol: IP.Type) -> ProtocolProxy<IP> {
//    return ProtocolProxy(externalProtocol: externalProtocol, internalProtocol: internalProtocol)
//}
//
//infix operator ?>
//func ?><IP: Protocol>(protocolProxy: ProtocolProxy<IP>, functionProxy: FunctionProxy) {
//    if let indeed = protocolProxy.externalProtocol as? IP {
//        let func1 = functionProxy.func1
//        indeed.func1()
//    }
//}
//
//infix operator =>
//typealias Function = () -> Void
//struct FunctionProxy {
//    let func1: Function
//    let func2: Function
//}
//func =>(func1: @escaping Function, func2: @escaping Function) -> FunctionProxy {
//    return FunctionProxy(func1: func1, func2: func2)
//}
//
