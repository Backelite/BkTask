//
//  BkLog.m
//  BkCommon
//
//  Created by Thomas SARLANDIE on 07/10/08.
//  Copyright 2008 Backelite. All rights reserved.
//
// Deeply inspired by: http://www.borkware.com/rants/agentm/mlog/

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
	[logFileHandle release], logFileHandle = nil;
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
    [tmp release];
    
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
		
		logFileHandle = [[NSFileHandle fileHandleForUpdatingAtPath:logFileName] retain];
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
		[header release];
		
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
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	va_list ap;
	NSString *print = nil;

	
	NSString *file = [[NSString alloc] initWithCString:sourceFile encoding:NSUTF8StringEncoding];
	NSString *filename = [file lastPathComponent];
	[file release];

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
		[pool drain];
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
	
	[print release];
	[pool drain];

	return;
}

+ (void) setLogOn:(BOOL)logOn
{
	__MLogOn=logOn;
}

@end
