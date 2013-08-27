//
//  BkTaskObserver.h
//  BkCore
//
//  Created by Pierre Monod-Broca on 05/09/12.
//  Copyright (c) 2012 Backelite. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BkTask;
@protocol BkTaskObserverDelegate;

/**
 *  The BkTaskObserver is an object defined to monitor the progress of a task as KVO monitor can changes in properties. 
 *  Currently it is only allowed to be notified when a task complete is this class is intented to be improved in the future.
 */
@interface BkTaskObserver : NSObject

/**
 *  The object to notify when task state changes.
 */
@property (unsafe_unretained, nonatomic) id <BkTaskObserverDelegate> delegate;

/**
 *  Add an observer for a task.
 *
 *  @param aTask The task to observe.
 */
- (void) observeTask:(BkTask *)aTask;

/**
 *  Stopping task observation. Note that BkTaskObserver will automatically stop observing finished tasks.
 *
 *  @param aTask The task to stop observing.
 */
- (void) stopObservingTask:(BkTask *)aTask;

/**
 *  Getter for observed tasks.
 *
 *  @return The list of observed tasks.
 */
- (id <NSFastEnumeration, NSCopying>) tasks;

@end


@protocol BkTaskObserverDelegate <NSObject>

@required

/**
 *  Sent to indicate that a task finished.
 *
 *  @param observer The object set as an observer.
 *  @param task     The observed task.
 */
- (void) observer:(BkTaskObserver *)observer taskDidFinish:(BkTask *)task;

@end
