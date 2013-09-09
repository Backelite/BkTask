//
// The MIT License (MIT)
//
// Copyright (c) 2013 Backelite
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

#define BKLogLevelError @"Error"
#define BKLogLevelWarning @"Warning"
#define BKLogLevelDebug @"Debug"

/** Logging routines that display filename and line, that can easily be disabled globally.
 *
 * BkLogE, BkLogW and BkLogD are defined conditionally:
 *   - when log is activated call BkLog methods
 *   - when log is not activated these macros are noop
 * Log is activated when the macro *Debug* is defined (Set via "GCC_PREPROCESSOR_DEFINITIONS" build setting to "$(CONFIGURATION)" or explicitly to "Debug")
 * The DEBUG macro is also supported for legacy reasons
 * The BkLogEnable is supported for rare occasion when we want logs to be activated in production. Use with caution!
 */

#if defined(Debug) || defined(DEBUG) || defined(BkLogEnable)
/// Log with *Error* level
	#define BKLogE(s,...) [BkLog logLevel:BKLogLevelError file:__FILE__ lineNumber:__LINE__ format:(s),##__VA_ARGS__]
/// Log with *Warning* level
	#define BKLogW(s,...) [BkLog logLevel:BKLogLevelWarning file:__FILE__ lineNumber:__LINE__ format:(s),##__VA_ARGS__]
/// Log with *Debug* level
	#define BKLogD(s,...) [BkLog logLevel:BKLogLevelDebug file:__FILE__ lineNumber:__LINE__ format:(s),##__VA_ARGS__]
/// Legacy. Log with *Debug* level
	#define BKLog(s,...) [BkLog logLevel:BKLogLevelDebug file:__FILE__ lineNumber:__LINE__ format:(s),##__VA_ARGS__]
#else
	#define BKLogE(s,...)
	#define BKLogW(s,...)
	#define BKLogD(s,...)
	#define BKLog(s,...)
#endif

#define BkLogMethod BKLogD(@" [<%@ %p> %@]", [self class], self, NSStringFromSelector(_cmd))
/**
 * BkLog is used by the BKLog macros to log application information.
 * It works like NSLog but BKLog displays the line number and the name of the file from which
 * the log is from.
 * You should never use the BkLog class directly but only use the BKLog macro.
 *
 * To see logs from BKLog, you need to both define the 'Debug' macro (use GCC_PREPROCESSOR_DEFINITIONS build setting)
 * and set the BKLog environment variable to YES. If the bklogconfiguration.plist exists, you can ommit the BKLog
 * environment variable and add the key EnableBkLog and set it to YES.
 *
 * You can also configure BKLog to decide which log you want to display. For this purpose, create
 * a file called bklogconfiguration.plist in your project and set a dictionary as the root data structure.
 * This dictionary must contains three keys: Error, Warning and Debug. Each being a dictionary whose keys
 * are file names and values are booleans.
 * Additionaly the root dictionary should contain three other keys: ErrorDefault, WarningDefault and
 * DebugDefault. Each being a boolean that is used if a particular file is not present in the keys of the
 * corresponding dictionary (respectively Error, Warning and Debug).
 * This keys are used to check if log must be enabled for these differents levels and files.
 * BKLog macro will use the Debug level.
 *
 * You can also decide to log in a file by adding the WriteToFile key in the plist and set its value as a boolean set to YES.
 * The log will be written in the Documents dir of the application in the file BkLog.txt.
 * Be careful, log is happended to the end of the file. By now, the log file is cleared every two weeks (all content is cleared).
 *
 * When the file exists, all BKLog default to OFF.
 *
 * Use BKLogE, BKLogW and BKLogD macros to log at different levels (Error, Warning, Debug).
 * Error logs will be prefixed by "!! ", Warning logs by "WW ", and Debug logs are displayed as is.
 *
 * @ingroup Utilities
 */
@interface BkLog : NSObject {

}

+ (void) logLevel:(NSString *)level file:(char*)sourceFile lineNumber:(int)lineNumber format:(NSString*)format, ...;
+ (void) setLogOn:(BOOL)logOn;

+ (NSString *) logFilePath;

/**
 * Ensure all logs are written to the disk.
 */
+ (void) synchronizeLogFile;

@end
