#ifndef __NSSTRING_EXT_H__
#define __NSSTRING_EXT_H__

#include <qglobal.h>
#include <string>
#import  <Foundation/NSString.h>

@interface NSString (wstring_additions)

#ifndef Q_OS_IOS
+(NSString*) stringWithWstring:(const std::wstring&)string;
-(std::wstring) getWstring;
#endif

+(NSString*) stringWithString:(const std::string&)string;
-(std::string)  getString;

@end

#endif // __NSSTRING_EXT_H__
