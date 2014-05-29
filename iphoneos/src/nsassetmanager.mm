#import "nsassetmanager.h"
#import "nsassetmanager_p.h"
#import "nsstringext.h"

// typedef void(^SaveImageCompletion)(NSError* error);

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


static void qt_mac_deleteImage( void *image, const void *, size_t )
{
    delete static_cast<QImage *>(image);
}


NSAssetManager::NSAssetManager( QObject* parent ) :
    QObject( parent ),
    m_d( [[NSAssetManagerPrivate alloc] init] )
{ }

NSAssetManager::~NSAssetManager()
{
    m_d = nil;
    // [m_d release];
}

void NSAssetManager::saveImage( const QImage& img, const QString& album  )
{
    NSAssetManagerPrivate * alsa = m_d; // [[NSAssetManagerPrivate alloc] init];
    
    UIImage  * uimg    = NSAssetManager::uiimage( img );
    NSString * nsalbum = [NSString stringWithString:album.toStdString()];

    // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    NSURL * url = [alsa createAsset:uimg];
    if ( url == nil ) {
        // emit done();
        return;
    }

    NSLog( @"Asset image created at \"%@\"", url );

    ALAsset *       asset = [alsa findAsset:url];
    ALAssetsGroup * group = [alsa findAlbum:nsalbum];
    if ( group == nil ) {
        group = [m_d createAlbum:nsalbum];
    }

    if ( asset != nil && group != nil ) {
        [group addAsset:asset];
    }

    // if ( asset ) [asset release];
    // if ( group ) [group release];
    // if ( url ) [url release];
        
    // [alsa release];
    // });

    // emit done();
}

/* static void NSAssetManager::saveImage(...)
void NSAssetManager::saveImage1( const QImage& img, const QString& album )
{
    SaveImageCompletion completionBlock = ^( NSError* error ) {
        NSLog(@"Can't complete action. Reason: %@", [error localizedDescription]);
    };
    
    __block ALAssetsLibrary * alsa = [[ALAssetsLibrary alloc] init];
    UIImage  * uimg = NSAssetManager::uiimage( img );
    NSString * albumName = [NSString stringWithString:album.toStdString()];
    
    //write the image data to the assets library (camera roll)
    [alsa writeImageToSavedPhotosAlbum:uimg.CGImage orientation:(ALAssetOrientation)uimg.imageOrientation
    completionBlock:^(NSURL* assetURL, NSError* error) {

    //error handling
    if ( error != nil ) {
        NSLog(@"Can't add asset. Reason: %@", [error localizedDescription]);
        completionBlock(error);
        return;
    }

    // -(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock

    __block BOOL albumWasFound = NO;

    //search all photo albums in the library
    [alsa enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {

    //compare the names of the albums
    if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame) {

        //target album is found
        albumWasFound = YES;
        // stop = YES;
        NSLog(@"Trying to add asset: \"%@\" ", assetURL);
        //get a hold of the photo's asset instance
        [alsa assetForURL: assetURL resultBlock:^(ALAsset *asset) {

            NSLog(@"Trying to add asset: \"%@\" ", asset); //[url absoluteURL]);

            //add photo to the target album
            [group addAsset: asset ];

            //run the completion block
            completionBlock(nil);

        } failureBlock: completionBlock];

        //album was found, bail out of the method
        // [group release];
        return;
        
    } // end if

    if (group==nil && albumWasFound==NO) {

        //create new assets album
        [alsa addAssetsGroupAlbumWithName: albumName resultBlock:^(ALAssetsGroup *group) {

            //get the photo's instance
            [alsa assetForURL: assetURL resultBlock:^(ALAsset *asset) {

                //add photo to the newly created album
                [group addAsset: asset ];
                //call the completion block
                completionBlock(nil);

            } failureBlock: completionBlock];

        } failureBlock: completionBlock];

        //should be the last iteration anyway, but just in case
        return;
        
    } // end if

    } failureBlock: completionBlock]; // end [ using ... block ... ]


    }]; // end [ using ... block ... ]

}
*/

UIImage* NSAssetManager::uiimage( const QImage& inImage )
{
    if (inImage.isNull())
        return 0;
    QImage image = (inImage.depth() == 32) ? inImage : inImage.convertToFormat(QImage::Format_ARGB32_Premultiplied);
    uint cgflags = kCGImageAlphaNone;

    switch (image.format()) {
        case QImage::Format_ARGB32_Premultiplied:
            cgflags = kCGImageAlphaPremultipliedFirst;
            break;
        case QImage::Format_ARGB32:
            cgflags = kCGImageAlphaFirst;
            break;
        case QImage::Format_RGB32:
            cgflags = kCGImageAlphaNoneSkipFirst;
            break;
        case QImage::Format_RGB888:
            cgflags |= kCGImageAlphaNone;
            break;
        default:
            break;
    }

    cgflags |= kCGBitmapByteOrder32Host;

    // QCFType<CGDataProviderRef>
    CGDataProviderRef dataProvider = NSAssetManager::CGDataProvider( image );
    CGColorSpaceRef   colSpace     = CGColorSpaceCreateDeviceRGB();

    CGImageRef imgRef = CGImageCreate(image.width(), image.height(), 8, 32,
                            image.bytesPerLine(),
                            colSpace, cgflags,
                            dataProvider, 0, false,
                            kCGRenderingIntentDefault );

    UIImage*    uiimg = [[UIImage alloc] initWithCGImage:imgRef];

    CGImageRelease( imgRef );
    CGColorSpaceRelease( colSpace );
    CGDataProviderRelease( dataProvider );

    return uiimg;
}

CGDataProviderRef NSAssetManager::CGDataProvider( const QImage &img )
{
    return CGDataProviderCreateWithData( new QImage(img), img.bits(), img.byteCount(), qt_mac_deleteImage );
}

