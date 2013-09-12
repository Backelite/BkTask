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

@class BKTTask;
@protocol BKTTaskObserverDelegate;

/**
 *  The BKTTaskObserver is an object defined to monitor the progress of a task as KVO monitor can changes in properties. 
 *  Currently it is only allowed to be notified when a task complete is this class is intented to be improved in the future.
 */
@interface BKTTaskObserver : NSObject

/**
 *  The object to notify when task state changes.
 */
@property (unsafe_unretained, nonatomic) id <BKTTaskObserverDelegate> delegate;

/**
 *  Add an observer for a task.
 *
 *  @param aTask The task to observe.
 */
- (void) observeTask:(BKTTask *)aTask;

/**
 *  Stopping task observation. Note that BKTTaskObserver will automatically stop observing finished tasks.
 *
 *  @param aTask The task to stop observing.
 */
- (void) stopObservingTask:(BKTTask *)aTask;

/**
 *  Getter for observed tasks.
 *
 *  @return The list of observed tasks.
 */
- (id <NSFastEnumeration, NSCopying>) tasks;

@end


@protocol BKTTaskObserverDelegate <NSObject>

@required

/**
 *  Sent to indicate that a task finished.
 *
 *  @param observer The object set as an observer.
 *  @param task     The observed task.
 */
- (void) observer:(BKTTaskObserver *)observer taskDidFinish:(BKTTask *)task;

@end
