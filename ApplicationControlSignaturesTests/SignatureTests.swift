//
//  SignatureTests.swift
//  ApplicationControlSignaturesTests
//
//  Created by Hyuk Hur on 2018-11-12.
//  Copyright © 2018 Hyuk Hur. All rights reserved.
//

import XCTest
@testable import ApplicationControlSignatures

class SignatureTests: XCTestCase {
    // http://www.fortiguard.com/appcontrol/32443
    /*
     ID    32443
     Released    Jul 20, 2012
     Description Updated    Aug 09, 2016
     Category    Network.Service
     Vendor
     Risk        2
     Popularity  1
     Deep App Ctrl    No
     Language    N/A
     Deprecated    No
     Technology    Network-Protocol
     Behavior    Reasonable
----
     Description
     This indicates an attempt to use the S1AP protocol.
     S1 Application Protocol (S1AP) provides signalling service between E-UTRAN and the evolved packet core (EPC).
----
     References
     http://lteworld.org/specification/s1-application-protocol-s1ap
 */
    static let jsonString = """
["S1AP","Network.Service",1,1,1,"2012-07-03","","","Unexpected network communication.","This indicates detection of the S1 Application Protocol (S1AP).<br/><br/>S1AP provides the signalling service between E-UTRAN and the evolved packet core (EPC).",17,"S1 Application Protocol","If required, this signature's action can be set to \\"Block\\" to block this application.","<a href=\\"http://lteworld.org/specification/s1-application-protocol-s1ap\\">http://lteworld.org/specification/s1-application-protocol-s1ap</a>",32443,0,""]
"""
    /*
     ["Windows.File.Sharing/SMB_Read.File", "Storage.Backup", 3, 1, 1, "2012-07-26", "","","Unexpected network communication<br\/>","This indicates the detection of an attempt to read bytes from a file via SMB. <br\/><br\/>The Server Message Block (SMB) Protocol is a network file and printer sharing protocol available on most computer Operating Systems.<br\/>",516,"SMB Read<br\/>","If required, this signature's action can be set to \"Block\" to block this kind of traffic.","",31834,1, "3.215"],

     ID    31834
     Released    May 15, 2012
     Description Updated    Aug 08, 2016
     Category    Network.Service
     Vendor
     Risk       2
     Popularity 5
     Deep App Ctrl    No
     Language    N/A
     Deprecated    No
     Technology    Client-Server
     Behavior    Reasonable

 */
    let json = try! JSONSerialization.jsonObject(with: jsonString.data(using: String.Encoding.utf8)!, options: [])

    func testParse() {
        do {
            let signature = try Signature(any: json as! [Any])
            XCTAssertNotNil(signature)
            XCTAssertEqual("S1AP", signature.name)
            XCTAssertNotNil(signature.referenceURLs)
            XCTAssertEqual("http://lteworld.org/specification/s1-application-protocol-s1ap", signature.referenceURLs.first?.absoluteString)
            XCTAssertFalse(signature.description?.contains("<br") ?? true)
        } catch {
            XCTFail()
        }
    }

}
