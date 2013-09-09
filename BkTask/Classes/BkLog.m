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


#import "BkLog.h"
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
#import <UIKit/UIKit.h>
#endif


static BOOL __MLogOn = NO;
static BOOL shouldWriteToFile = NO;
static NSDictionary *classesConfiguration = nil;
static NSDictionary *levelsConfiguration = nil;
static NSDictionary *prefixDictionary = nil;
static NSFileHandle *logFileHandle = nil;

@implementation BkLog

+ (NSString *) logFilePath
{
	NSString *result = nil;
	
	NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if (dirs.count > 0) {
		result = [NSString stringWithFormat:@"%@/%@", [dirs objectAtIndex:0], @"BkLog.txt"];
	}
	
	return result;
}

+ (void) synchronizeLogFile
{
	[logFileHandle synchronizeFile];	
}

+ (void) closeLogFile
{
	logFileHandle = nil;
}

+ (void) initialize
{
	char *env = getenv("BKLog");
	// Logs disabled by default
	if (env != NULL && strcmp(env, "YES") == 0)
		__MLogOn = YES;
	
	classesConfiguration = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bklogconfiguration" 
																										ofType:@"plist"]];
	NSNumber *writeToFile = [classesConfiguration objectForKey:@"WriteToFile"];
	if (writeToFile) {
		shouldWriteToFile = [writeToFile boolValue];
	}
	
	NSNumber *activateBkLog = [classesConfiguration objectForKey:@"EnableBkLog"];
	if (activateBkLog) {
		__MLogOn = [activateBkLog boolValue];
	}
	
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithCapacity:3];
    [tmp setValue:[classesConfiguration valueForKey:BKLogLevelError"Default"]   forKey:BKLogLevelError];
    [tmp setValue:[classesConfiguration valueForKey:BKLogLevelWarning"Default"] forKey:BKLogLevelWarning];
    [tmp setValue:[classesConfiguration valueForKey:BKLogLevelDebug"Default"]   forKey:BKLogLevelDebug];
    levelsConfiguration = [tmp copy];
    
	prefixDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
						@"!! ", BKLogLevelError,
						@"WW ", BKLogLevelWarning,
						@"", BKLogLevelDebug,
						nil];
	
	if (shouldWriteToFile) {
		NSString *logFileName = [self logFilePath];
		if (![[NSFileManager defaultManager] fileExistsAtPath:logFileName]) {
			[[NSFileManager defaultManager] createFileAtPath:logFileName contents:nil attributes:nil];
		} else {
			NSError *error = nil;
			NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:logFileName error:&error];
			if (error) {
				NSLog(@"EE cannot access log file attributes: %@", error);
			} else {
				NSTimeInterval timeIntervalSinceCreation = [[fileAttributes objectForKey:NSFileCreationDate] timeIntervalSinceNow];
				if (timeIntervalSinceCreation <= -60 * 60 * 24 * 7) {
					[[NSFileManager defaultManager] removeItemAtPath:logFileName error:&error];
					[[NSFileManager defaultManager] createFileAtPath:logFileName contents:nil attributes:nil];
				}
			}
		}
		
		logFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:logFileName];
		[logFileHandle seekToEndOfFile];
		
		NSMutableString *header = [[NSMutableString alloc] init];
		[header appendString:@"\n\n==============================\n"];
		[header appendFormat:@"= New session - Start date: %@\n", [NSDate date]];
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
		[header appendFormat:@"= Device: MODEL %@ - iOS %@\n",
		 [[UIDevice currentDevice] model],
		 [[UIDevice currentDevice] systemVersion]];
#endif
		[header appendFormat:@"= Application: DISPLAY NAME %@ - ID %@ - VERSION %@\n",
		 [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
		 [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"], 
		 [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
		[header appendString:@"==============================\n\n"];

		[logFileHandle writeData:[header dataUsingEncoding:NSUTF8StringEncoding]];
		
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(closeLogFile)
													 name:UIApplicationWillTerminateNotification
												   object:nil];
#endif
	}
}

+ (void) logLevel:(NSString *)level file:(char*)sourceFile lineNumber:(int)lineNumber format:(NSString*)format, ...
{
	// First: check if log is activated
	if (__MLogOn == NO) {
		return;
	}
	
    @autoreleasepool {
        va_list ap;
        NSString *print = nil;
        
        
        NSString *file = [[NSString alloc] initWithCString:sourceFile encoding:NSUTF8StringEncoding];
        NSString *filename = [file lastPathComponent];
        
        // Check if log is configured
        BOOL shouldShowLog = YES;
        if ([classesConfiguration count] > 0) {
            shouldShowLog = NO;
            id value = [[classesConfiguration objectForKey:level] objectForKey:filename];
            if (value) {
                shouldShowLog = [value boolValue];
            }
            else if ((value = [classesConfiguration objectForKey:[level stringByAppendingString:@"Default"]]) != nil) {
                shouldShowLog = [value boolValue];
            }
        }
        if (!shouldShowLog) {
            return;
        }
        
        va_start(ap, format);
        print = [[NSString alloc] initWithFormat:format arguments:ap];
        va_end(ap);
        
        //NSLog handles synchronization issues
        NSString *logString = [NSString stringWithFormat:@"%@:%d %@%@",
                               filename, lineNumber, [prefixDictionary objectForKey:level], print];
        NSLog(@"%@", logString);
        if (shouldWriteToFile) {
            [logFileHandle writeData:[[NSString stringWithFormat:@"%@\n", logString] dataUsingEncoding:NSUTF8StringEncoding]];		
        }
        
    }

	return;
}

+ (void) setLogOn:(BOOL)logOn
{
	__MLogOn=logOn;
}

@end
