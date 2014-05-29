#include "nsstringext.h"

@implementation NSString (wstring_additions)

#ifndef Q_OS_IOS

#import <Cocoa/Cocoa.h>

#if TARGET_RT_BIG_ENDIAN
const NSStringEncoding kEncoding_wchar_t = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF32BE);
#else
const NSStringEncoding kEncoding_wchar_t = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF32LE);
#endif

+(NSString*) stringWithWstring:(const std::wstring&)ws
{
    char* data = (char*)ws.data();
    unsigned size = ws.size() * sizeof(wchar_t);

    NSString* result = [[[NSString alloc] initWithBytes:data length:size encoding:kEncoding_wchar_t] autorelease];
    return result;
}

-(std::wstring) getWstring
{
    NSData* asData = [self dataUsingEncoding:kEncoding_wchar_t];
    return std::wstring((wchar_t*)[asData bytes], [asData length] / sizeof(wchar_t));
}

#endif

+(NSString*) stringWithString:(const std::string&)s
{
    NSString* result = [[NSString alloc] initWithUTF8String:s.c_str()];
    return result;
}

-(std::string) getString
{
    return [self UTF8String];
}

@end

