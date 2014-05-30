#import "nsassetmanager_p.h"


@interface NSAssetManagerPrivate() {
    ALAssetsLibrary * _lib;
}

@end


@implementation NSAssetManagerPrivate

- (id) init
{
    _lib = nil;
    self = [super init];
    if ( self ) {
        _lib = [[ALAssetsLibrary alloc] init];
    }
    
    return self;
}

- (void) dealloc
{
#if !__has_feature(objc_arc)
    [_lib release];
    [super dealloc];
#endif
}


- (NSURL*) createAsset:(UIImage*)img
{
    __block NSURL * url = nil;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [_lib writeImageToSavedPhotosAlbum:img.CGImage orientation:(ALAssetOrientation)img.imageOrientation
                        completionBlock:^(NSURL* assetURL, NSError* error) {

                          //error handling
                          if ( error != nil ) {
                              NSLog(@"Can't add asset. Reason: %@", [error localizedDescription]);
                              dispatch_semaphore_signal(sema);
                              return;
                          }
                        #if !__has_feature(objc_arc)
                          url = [assetURL retain];
                        #else
                          url = assetURL;
                        #endif
                          dispatch_semaphore_signal(sema);
                      }];
    //});
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
#if !__has_feature(objc_arc)
    dispatch_release(sema);
#endif

    return url;
}

- (ALAsset*) findAsset:(NSURL*)url
{
    
#if !__has_feature(objc_arc)
    // [_lib retain];
    [url retain];
#endif
    __block ALAsset * assetImage = nil;
    
    dispatch_semaphore_t   sema = dispatch_semaphore_create(0);
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [_lib assetForURL:url resultBlock:^(ALAsset *asset) {

#if !__has_feature(objc_arc)
              assetImage = [asset retain];
#else
              assetImage = asset;
#endif

              NSLog(@"Trying to add asset: \"%@\" ", asset);

              dispatch_semaphore_signal(sema);
          } failureBlock: ^(NSError* error){

              if ( error ) {
                NSLog(@"ERROR %@", [error localizedDescription]);
              };
              dispatch_semaphore_signal(sema);
          }];
    //});
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
#if !__has_feature(objc_arc)
    dispatch_release(sema);

    [url release];
    // [_lib release];
#endif
    
    return assetImage;
}

- (ALAssetsGroup*) findAlbum:(NSString*)album
{
    __block BOOL albumWasFound = NO;
    __block ALAssetsGroup * grp = nil;

    //search all photo albums in the library
    dispatch_semaphore_t   sema = dispatch_semaphore_create(0);
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [_lib enumerateGroupsWithTypes:ALAssetsGroupAlbum
                        usingBlock:^(ALAssetsGroup *group, __unused BOOL *stop) {

                            //compare the names of the albums
                            if ([album compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame) {

                                //target album is found
                                // stop = YES;
                                albumWasFound = YES;
                                
                            #if !__has_feature(objc_arc)
                                grp = [group retain];
                            #else
                                grp = group;
                            #endif

                                //[album release];
                                dispatch_semaphore_signal(sema);
                                return;
                            }

                            if ( group == nil && albumWasFound == NO ) {
                                //photo albums are over, target album does not exist, thus create it

                                // return nil;

                                //should be the last iteration anyway, but just in case
                                //[album release];
                                dispatch_semaphore_signal(sema);
                                return;
                            }

                } failureBlock: ^(NSError* error){

                    if ( error ) {
                      NSLog(@"ERROR %@", [error localizedDescription]);
                    };
                    dispatch_semaphore_signal(sema);
                }];
    //});
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
#if !__has_feature(objc_arc)
    dispatch_release(sema);
#endif

    return grp;
}

- (ALAssetsGroup*) createAlbum:(NSString*)album
{
    __block ALAssetsGroup * grp = nil;
    dispatch_semaphore_t   sema = dispatch_semaphore_create(0);

    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [_lib addAssetsGroupAlbumWithName: [NSString stringWithString:album]
                          resultBlock:^(ALAssetsGroup *group) {

                        #if !__has_feature(objc_arc)
                            grp = [group retain];
                        #else
                            grp = group;
                        #endif

                          dispatch_semaphore_signal(sema);
            } failureBlock: ^(NSError* error){

                if ( error ) {
                  NSLog(@"ERROR %@", [error localizedDescription]);
                };
                dispatch_semaphore_signal(sema);
            }];
    //});
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
#if !__has_feature(objc_arc)
    dispatch_release(sema);
#endif

    return grp;
}

@end

