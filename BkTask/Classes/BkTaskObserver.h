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


@interface BkTaskObserver : NSObject

@property (unsafe_unretained, nonatomic) id <BkTaskObserverDelegate> delegate;

- (void) observeTask:(BkTask *)aTask;
- (void) stopObservingTask:(BkTask *)aTask; //< Tells to stop observing 'aTask'. Note that BkTaskObserver will automatically stop observing finished tasks

- (id <NSFastEnumeration, NSCopying>) tasks; //< returns a list of observed tasks.

@end


@protocol BkTaskObserverDelegate <NSObject>

@required

- (void) observer:(BkTaskObserver *)observer taskDidFinish:(BkTask *)task;

@end
