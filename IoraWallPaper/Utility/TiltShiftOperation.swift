//
//  TiltShiftOperation.swift
//  IoraWallPaper
//
//  Created by 박소정 on 2020/07/30.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation
import UIKit

protocol ImageDataProvider {
    var image: UIImage? { get }
}

final class TiltShiftOperation: Operation {
    private static let context = CIContext()
    
    // 🎾 작업이 끝났을때 메인쓰레드에서 콜백함수를 실행하기 위한, 콜백함수 저장 변수
    var onImageProcessed: ((UIImage?) -> Void)?
    
    var outputImage: UIImage?
    private let inputImage: UIImage?
    
    init(image: UIImage? = nil) {
        inputImage = image
        super.init()
    }
    
    override func main() {
        var imageToProcess: UIImage
        
        // 이미, 인풋이미지가 있다면 사용
        if let inputImage = inputImage {
            imageToProcess = inputImage
            
        // 인풋이미지가 없으면, 의존하는 오퍼레이션에서 뽑아서 이미지 셋업
        } else {
            let dependencyImage: UIImage? = dependencies
                .compactMap { ($0 as? ImageDataProvider)?.image }
                .first
            
            if let dependencyImage = dependencyImage {
                imageToProcess = dependencyImage
            } else {
                return
            }
        }
        
        guard let filter = TiltShiftFilter(image: imageToProcess, radius: 4),
            let output = filter.outputImage else {
                print("틸트쉬프트된 이미지 생성에 실패했습니다.")
                return
        }
        
        if self.isCancelled { return }
        
        let fromRect = CGRect(origin: .zero, size: imageToProcess.size)
        
        guard
            let cgImage = TiltShiftOperation.context.createCGImage(output, from: fromRect),
            let rendered = cgImage.rendered()
            else { print("이미지가 생성되지 않았습니다.")
                return }
        
        if self.isCancelled { return }
        
        outputImage = UIImage(cgImage: rendered)
        
        // 🎾 콜백함수를 메인쓰레드에서 실행
        if let onImageProcessed = onImageProcessed {
            DispatchQueue.main.async { [weak self] in
                onImageProcessed(self?.outputImage)
            }
        }
    }
}

extension TiltShiftOperation: ImageDataProvider {
    var image: UIImage? { return outputImage }
}
