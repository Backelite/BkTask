//
//  BkMisc.h
//  BkCore
//
//  Created by Pierre Monod-Broca on 23/10/12.
//  Copyright (c) 2012 Backelite. All rights reserved.
//

/**
 *  An easy way to declare a copy of anything as a weak reference
 */
#if __has_feature(objc_arc_weak)
#  define BkWeakTypeof(obj) __weak __typeof__(obj)
#elif __has_feature(objc_arc)
#  define BkWeakTypeof(obj) __unsafe_unretained __typeof__(obj)
#else
#  define BkWeakTypeof(obj) __block __typeof__(obj)
#endif

/// an easy way to declare a copy of self as a weak reference
#define BkWeakSelf BkWeakTypeof(self)
#define BkDeclareWeakSelf BkWeakSelf weakSelf = self
#define BkDeclareWeak(obj) BkWeakTypeof(obj) weak##obj = obj


#if __has_feature(objc_arc)
///an alternative to Block_copy that works with ARC (Block_copy forgets the bridge)
#define BkBlock_copy(...) ((__bridge __typeof(__VA_ARGS__))_Block_copy((__bridge const void *)(__VA_ARGS__)))
#else
#define BkBlock_copy Block_copy
#endif

/**
 * Like dispatch_sync but without dead lock if 'queue' is the current queue.
 * Deadlocks are still possible in other circumpstances
 */
static inline void bk_dispatch_sync(dispatch_queue_t queue, dispatch_block_t block)
{
    if (queue == dispatch_get_current_queue()) {
        block();
    } else {
        dispatch_sync(queue, block);
    }
}
