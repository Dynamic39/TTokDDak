//
//  DataModel.swift
//  TTokddak
//
//  Created by Samuel K on 2018. 3. 22..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import Foundation

//필터 종류 정리
let filters = ["CIColorCrossPolynomial", "CIPhotoEffectInstant", "CIPhotoEffectMono", "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CISepiaTone"]

let filtersName = ["Normal", "Instant", "Mono", "Noir", "Process", "Sepia"]

class FilterIndex {
  
  func filterFromIndexPath(indexPath: IndexPath) -> String {
    
    let filterIndexString = filters[indexPath.item]
    
    return filterIndexString
    
  }
  
  
}
