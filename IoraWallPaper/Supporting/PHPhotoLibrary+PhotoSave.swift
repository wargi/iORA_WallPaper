//
//  PhotoSave.swift
//  IoraWallPaper
//
//  Created by 박상욱 on 2020/06/15.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import Photos

extension PHPhotoLibrary {
   func savePhoto(image: UIImage, albumName: String, completion:((PHAsset?) -> ())? = nil) -> UIAlertController {
      func save() {
         if let album = PHPhotoLibrary.shared().findAlbum(albumName: albumName) {
            PHPhotoLibrary.shared().saveImage(image: image, album: album, completion: completion)
         } else {
            PHPhotoLibrary.shared().createAlbum(albumName: albumName) { (collection) in
               if let collection = collection {
                  PHPhotoLibrary.shared().saveImage(image: image, album: collection, completion: completion)
               } else {
                  completion?(nil)
               }
            }
         }
      }
      
      let alert = UIAlertController(title: "Save Success :)", message: nil, preferredStyle: .alert)

      if PHPhotoLibrary.authorizationStatus() == .authorized {
         save()
         return alert
      } else {
         PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
               save()
            }
         }
      }
      
      alert.title = "Save Fail"
      alert.message = "IORA needs access to your photos to save photos"
      let toSetting = UIAlertAction(title: "Go Setting", style: .default) { _ in
         if let appSetting = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSetting, options: [:], completionHandler: nil)
         }
      }
      
      alert.addAction(toSetting)
      return alert
   }
   
   
   fileprivate func findAlbum(albumName: String) -> PHAssetCollection? {
      let fetchOptions = PHFetchOptions()
      fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
      let fetchResult: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album,
                                                                               subtype: .any,
                                                                               options: fetchOptions)
      guard let photoAlbum = fetchResult.firstObject else { return nil }
      return photoAlbum
   }
   
   fileprivate func createAlbum(albumName: String, completion: @escaping (PHAssetCollection?) -> ()) {
      var albumPlaceHolder: PHObjectPlaceholder?
      PHPhotoLibrary.shared().performChanges({
         let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
         albumPlaceHolder = createAlbumRequest.placeholderForCreatedAssetCollection
      }) { (success, error) in
         if success {
            guard let placeholder = albumPlaceHolder else {
               completion(nil)
               return
            }
            let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier],
                                                                      options: nil)
            guard let album = fetchResult.firstObject else {
               completion(nil)
               return
            }
            completion(album)
         } else {
            completion(nil)
         }
      }
   }
   
   fileprivate func saveImage(image: UIImage, album: PHAssetCollection, completion: ((PHAsset?)->())? = nil) {
      var placeHolder: PHObjectPlaceholder?
      PHPhotoLibrary.shared().performChanges({
         let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
         guard let albumCangeRequest = PHAssetCollectionChangeRequest(for: album),
            let photoPlaceholder = createAssetRequest.placeholderForCreatedAsset else { return }
         placeHolder = photoPlaceholder
         let fastEnumeration = NSArray(array: [photoPlaceholder] as [PHObjectPlaceholder])
         albumCangeRequest.addAssets(fastEnumeration)
      }) { (success, error) in
         guard let placeholder = placeHolder else {
            completion?(nil)
            return
         }
         if success {
            let assets: PHFetchResult<PHAsset> = PHAsset.fetchAssets(withBurstIdentifier: placeholder.localIdentifier, options: nil)
            let asset: PHAsset? = assets.firstObject
            completion?(asset)
         } else {
            completion?(nil)
         }
      }
   }
}
