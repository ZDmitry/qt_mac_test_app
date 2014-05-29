#ifndef NSASSETMANAGER_P_H
#define NSASSETMANAGER_P_H

#import  <UIKit/UIImage.h>
#import  <Foundation/Foundation.h>
#import  <AssetsLibrary/AssetsLibrary.h>


@interface NSAssetManagerPrivate : NSObject

- (NSURL*) createAsset:(UIImage*)img;
- (ALAsset*) findAsset:(NSURL*)url;

- (ALAssetsGroup*) findAlbum:(NSString*)album;
- (ALAssetsGroup*) createAlbum:(NSString*)album;

@end

#endif // NSASSETMANAGER_P_H
