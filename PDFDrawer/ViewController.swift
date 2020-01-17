//
//  ViewController.swift
//  PDFDrawer
//
//  Created by Crocodic MBP-2 on 3/5/18.
//  Copyright © 2018 Crocodic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let stringUrl = Bundle.main.path(forResource: "Document(1)", ofType: "pdf") {
            if let url = NSURL(string: "file:///" + stringUrl) {
                let image = drawPDFfromURL(url: url)
                imageView.image = image
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func drawPDFfromURL(url: NSURL) -> UIImage? {
        guard let document = CGPDFDocument(url) else { return nil }
        guard let page = document.page(at: 1) else { return nil }
        
        func printPDFKeys(key: UnsafePointer<Int8>, ob: CGPDFObjectRef, info: UnsafeMutableRawPointer?) -> Void{
            
            NSLog("key = %s", key);
            print("Obj \(ob)")
        }
        
        print("Info Document")
        CGPDFDictionaryApplyFunction(document.info!, printPDFKeys, nil)
        print("Catalog Document")
        CGPDFDictionaryApplyFunction(document.catalog!, printPDFKeys, nil)
        print("Dictionary Page")
        CGPDFDictionaryApplyFunction(page.dictionary!, printPDFKeys, nil)
        
        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)
            
            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            
            ctx.cgContext.drawPDFPage(page)
        }
        
        return img
    }

}

