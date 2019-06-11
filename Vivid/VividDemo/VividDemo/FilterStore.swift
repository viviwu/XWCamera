//
//  FilterStore.swift
//  VividDemo
//
//  Created by YuAo on 1/30/16.
//  Copyright © 2016 YuAo. All rights reserved.
//

import CoreImage

class FilterStore {
    static let filters: [CIFilter?] = {
        var filters = [CIFilter?]()
        
        filters.append(nil)
        
        filters.append(CIFilter(
            name: "YUCIColorLookup",
            parameters:[
                "inputColorLookupTable": CIImage(contentsOf: Bundle.main.url(forResource: "color_lookup_miss_etikate", withExtension: "png")!)!
            ])
        )
        
        filters.append(CIFilter(
            name: "YUCIRGBToneCurve",
            parameters:[
                "inputRGBCompositeControlPoints": [CIVector(x: 0, y: 0),CIVector(x: 0.5, y: 0.7), CIVector(x: 1, y: 1)]
            ])
        )
        
        filters.append(CIFilter(name: "YUCISurfaceBlur"))
        
        filters.append(CIFilter(name: "YUCICrossZoomTransition"))
        
        filters.append(CIFilter(name: "YUCIFilmBurnTransition"))
        
        filters.append(CIFilter(name: "YUCIFlashTransition"))
        
        filters.append(CIFilter(
            name: "YUCIStarfieldGenerator",
            parameters:[
                "inputExtent": CIVector(cgRect: CGRect(x: 0, y: 0, width: 1200, height: 800)),
                "inputTime": 0
            ])
        )
        
        filters.append(CIFilter(
            name: "YUCIBlobsGenerator",
            parameters:[
                "inputExtent": CIVector(cgRect: CGRect(x: 0, y: 0, width: 1200, height: 800)),
                "inputTime": 6.0
            ])
        )
        
        filters.append(CIFilter(name: "YUCITriangularPixellate"))
        
        filters.append(CIFilter(name: "YUCIFXAA"))
        
        filters.append(CIFilter(name: "YUCIHistogramEqualization"))
        
        filters.append(CIFilter(name: "YUCICLAHE"))
        
        filters.append(CIFilter(name: "YUCISkyGenerator", parameters: [
            "inputExtent": CIVector(cgRect: CGRect(x: 0, y: 0, width: 1200, height: 800))
        ]))
        
        return filters
    }()
}
