//
//  NetworkImageOperation.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/07/30.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation

import Foundation
import UIKit

typealias ImageOperationCompletion = ((Data?, URLResponse?, Error?) -> Void)?

final class NetworkImageOperation: AsyncOperation {
    
    var image: UIImage?
    private let url: URL
    
    // 네트워크작업이 실행되는 동안 저장(취소)하기 위함
    private var task: URLSessionDataTask?
    
    // URL세션타입의 컴플리션 핸들러 저장
    private let completionHandler: ImageOperationCompletion
    
    // URL로 초기화하는 경우
    init(url: URL, completionHandler: ImageOperationCompletion = nil) {
        self.url = url
        self.completionHandler = completionHandler
        
        super.init()
    }
    
    // String으로 초기화하는 경우
    convenience init?(string: String, completionHandler: ImageOperationCompletion = nil) {
        guard let url = URL(string: string) else { return nil }
        self.init(url: url, completionHandler: completionHandler)
    }
    
    override func main() {
        
        task = URLSession.shared.dataTask(with: url) { [weak self]
            data, response, error in
            
            guard let self = self else { return }
            
            if self.isCancelled { return }
            
            // 만약 컴플리션 핸들러 전달했었다면 그것으로 실행(선택권주는 것일뿐)
            if let completionHandler = self.completionHandler {
                completionHandler(data, response, error)
                self.state = .finished
                return
            }
            
            guard error == nil, let data = data else { return }
            
            // 성공하면 이미지 표시
            self.image = UIImage(data: data)
            self.state = .finished
        }
        task?.resume()
    }
    
    override func cancel() {
        super.cancel()
        task?.cancel()
    }
}

// image변수 이미 있음
extension NetworkImageOperation: ImageDataProvider {}
