//: Playground - noun: a place where people can play

import UIKit
import ObjectiveC
import ObjectiveC.runtime
import ObjectiveC.message

let rootKey = "root"

//final class NSCoderKeysExtracingArchiver: NSKeyedArchiver {
//    override var outputFormat: PropertyListSerialization.PropertyListFormat {
//        return .xml
//    }
//}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

var plistPath: URL {
    let path = getDocumentsDirectory().appendingPathComponent("DeleteThisByDeveloperAlexCyon.plist")
    print(path)
    return path
}

extension NSObject {
    var propertyKeys: [String] {
        
        /*
         let randomFilename = UUID().uuidString
         let data = NSKeyedArchiver.archivedData(withRootObject: somethingToSave)
         let fullPath = getDocumentsDirectory().appendingPathComponent(randomFilename)

         */
//        let plistpath = getDocumentsDirectory().stringByAppendingPathComponent("AlexCyonNSCoderKeyedArchivedPlaygroundList.plist")
        let archivedData = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: archivedData)
        archiver.outputFormat = .xml
//        archiver.encode(self, forKey: rootKey)
        archiver.encode(self)
        archiver.finishEncoding()
        
        archivedData.write(to: plistPath, atomically: false)
        
//        archivedData.dictionaryWithValues(forKeys: <#T##[String]#>)
        
//        let archive = archiver.
        
        var keys = [String]()
        return keys
    }
}

let label = UILabel()
label.text = "Qwertyuip"
label.textAlignment = .center
label.textColor = .cyan
label.layer.cornerRadius = 129
let keys = label.propertyKeys
for key in keys {

}
