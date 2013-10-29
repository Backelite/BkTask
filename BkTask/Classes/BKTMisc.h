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
