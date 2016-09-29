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


precedencegroup ClosurePG {
    associativity: left
}
precedencegroup ProtocolProxyPG {
    associativity: left
    higherThan: ClosurePG
}

infix operator >> : ProtocolProxyPG
infix operator ** : ClosurePG


typealias Casted<IP: Protocol, P: PublicPlayer> = (IP?, P?) -> Void
struct ProtocolProxy<IP> {
    let externalProtocol: PublicPlayer
    let internalProtocol: IP.Type
}
func >><IP>(externalProtocol: PublicPlayer, internalProtocol: IP.Type) -> ProtocolProxy<IP> {
    return ProtocolProxy(externalProtocol: externalProtocol, internalProtocol: internalProtocol)
}
func **<IP>(proxy: ProtocolProxy<IP>, casted: Casted<IP, PublicPlayer>) {
    if let internalProtocol = proxy.externalProtocol as? IP {
        casted(internalProtocol, nil)
    } else {
        casted(nil, proxy.externalProtocol)
    }
}



//(player as? InternalPlayer)?.pauseSecret() ?? player.pause()
player >> InternalPlayer.self ** { i, p in i?.pauseSecret(); p?.pause() }

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
