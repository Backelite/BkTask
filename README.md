![Parallel Flow](https://github.com/Backelite/BkTask/raw/master/Images/parallel.png "Parallel Flow") 

# BkTask
BkTask is a library inspired by the [Proactor](http://en.wikipedia.org/wiki/Proactor_pattern "Proactor pattern on Wikipedia") and [Reactor](http://en.wikipedia.org/wiki/Reactor_pattern "Reactor pattern on Wikipedia") design patterns. It is designed with two concepts in mind, asynchronous and modular.  
Doing work asynchronously allows to keep your application responsive. But parallel programming is hard. On iOS, tools like GCD and NSOperation makes it much simpler but, for complex workflows it still takes time and resources to achieve. BkTask allows you to simply run workflows in background and be notified once it is done.  

What about modularity then ? One way to simply a complex task is to breaking it into multiple simple steps. That is how you build a task with BkTask, by adding the steps you need to complete your workflow. If your workflow changes, add or remove steps to update it. You can even create your own steps and reuse them in different workflows. The modular aspect of BkTask helps you to stay agile.

On the technical side, it is built using technologies like NSOperation and key-value observing.  
This library is already used in AppStore applications used by millions of people. 

## Changes

v 0.9.1

* Adapted demo project to iPhone 6 and 6 plus screens
* Fixed a potential deadlock

v 0.9

* Xcode 5 with iOS SDK 7.0 is now required (see [Requirements](#requirements) for more info)
* Created a new step to download data using NSURLSession
* In a JSON parsing step, an empty JSON file is now considered as valid
* Removed warnings when compiling with Xcode 5
* Code cleaning

v 0.8  

* ARC Conversion
* Added Weather sample project
* Code documentation in appledoc format

## Getting started
### The Pod way
Just add the following line in your podfile

	pod 'BkTask'

### The old school way
The simplest way to use BkTask with your project is with Xcode 4 workspaces. Just drag and drop `BkTask.xcodeproj` below your other projects in the workspace.  
![Drop BkTask xcodeproj into your workspace](https://github.com/Backelite/BkTask/raw/master/Images/BkTask_1.jpg "Drop BkTask xcodeproj into your workspace")  

Then, select your project's target and click on the `Build Phases` tab. Unfold the `Link Binary With Libraries` section and click on the + button to add a new library.
Select `libBkTask.a` and click `Add`.  
![Add libBkTask.a to your target](https://github.com/Backelite/BkTask/raw/master/Images/BkTask_2.jpg "Add libBkTask.a to your target")  

As it is a static library, you will need to indicate the path to BkTask headers. To do so, select your project's target and click on the `Build Settings` tab. Find the `Header Search Paths` and set the path to the `Classes` directory of BkTask.
For instance, let's assume that you have a `Libraries` directory at the same level of your `.xcodeproj` where you store all your external libraries. In that case, the header to indicate would be `$(SRCROOT)/Librairies/BkTask/Classes`.  
![Add BkTask headers to your Header Search Paths](https://github.com/Backelite/BkTask/raw/master/Images/BkTask_3.jpg "Add BkTask headers to your Header Search Paths")  

-------

### Using BkTask

#### Anatomy of a task
A _task_ is made of multiple _steps_ sharing a _content_ between them. A _task_ monitor _step_ execution and ensure that _content_ is passed through steps. When all the _steps_ are finished, the _task_ notify every observer registered by calling a success block. If one _step_ fails to execute, the _task_ notify observers by calling a failure block. Note that observers for success and failure may be different.  
A _step_ takes data from its input, process them and return the result through its output. The _content_ is processed by each _step_ and is returned when each step has completed.  
A few things to know : 

* Observers are not retained by a task
* If all observers are removed, the task will stop executing automatically
* A task doesn't retain itself. This means you have to keep ownership a the task until its execution finished or is canceled.

#### Let's code now
##### The most basic task ever

First, add BkTask import

	#import "BkTask.h"

Now we can create a simple task to load a file from disk

```Objective-C

	//Create a task
	BKTTask *aTask = [[BKTTask alloc] init];

	//Create a file load step
	BKTFileLoadingOperation *fileLoadOperation = [BKTFileLoadingOperation loadOperationWithFile:FILE_TO_OPEN_URL];

	//Add the step to the task
	[aTask addStep:fileLoadOperation];

	//Set completion and failure blocks
	[aTask addTarget:self completion:^(BKTTask *task, id output) {
    NSLog(@"Task completed with success");
	}];
	[aTask addTarget:self failure:^(BKTTask *task, NSError *error) {
    NSLog(@"Task failed");
	}];

	//Start the task
	self.myTask = aTask; //To retain the task
	[self.myTask start];
```

Of course, a task with one step is not very usefull and GCD is better at that. However, when you have a workflow with multiple steps, it becomes a mess of nested blocks with GCD while BkTask takes care of chaining steps and passing data through them.

##### Quick tasks

For frequent use cases, there are helper methods to build preconfigured tasks.  
```Objective-C

	// To create a task with a download URL step
	+ (id) taskWithRequest:(NSURLRequest *)aRequest;

	// To create a task with a download URL step and a JSON parsing step
	+ (id) taskWithJSONRequest:(NSURLRequest *)aRequest;
```

##### Making your own steps
Sometimes, you may have application specific work to execute in background. Or you may want to replace the default JSON parsing step with a step using your favorite JSON parsing library. Or simply, there is no existing step to do what you want.  
BkTask offers multiple ways for creating custom steps. If your step is quite simple and meant to be use only once, you can use `BkBlockStepOperation` with a block describing how to process the data in your step.

```Objective-C

	+ (id) blockOperationWithInputKey:(NSString *)inKey outputKey:(NSString *)outKey block:(BKTBlockStepOperationBlock)workBlock;
	
	+ (id) blockOperationWithQueue:(NSOperationQueue *)queue block:(BKTBlockStepOperationBlock)workBlock;
	
	+ (id) blockOperationWithBlock:(BKTBlockStepOperationBlock)workBlock;
```

The `inKey` and `outKey` parameters can take two values :

* `BkTaskContentBodyData` means your input (or output respectively) is binary data in a NSData object
* `BkTaskContentBodyObject` means your input (or output respectively) is NSObject subclass

The ouput type of one step have to be identical to the input of the next step. Otherwise, the task would fail to complete.    

To deeply customize a step, or if you need a reusable step, you can subclass `BKTBasicStepOperation`. A step is an `NSOperation` subclass implementing the `BKTTaskStep` protocol. `BKTBasicStepOperation` is an abstract class implementing the boilerplate parts to provide a much simpler API to create a class. All you need to do is to override the following methods :

```Objective-C

	- (NSString *) inputKey;
	
	- (NSString *) outputKey;
	
	- (id) processInput:(id)theInput error:(NSError **)error;
```

The implementation of `inputKey` and `outputKey` should return `BkTaskContentBodyData` or `BkTaskContentBodyObject` depending on what kind of input your step will process. Then, the `processInput: error:` method is where the input processing is done, returning the output. Of course, subclassing `BKTBasicStepOperation` allows you to add any property or method you need to configure and process the input.    

If you create a generic step and think it could be useful to other people, feel free to send a pull request. We would be glad to consider and add it to BkTask.

-------

### Sample project
The sample project is a little weather application. You can search for a city and see related forecasts. It demonstrates how to create a task that will download and parse JSON. It also shows how to add a simple custom step to a task using the block method. To see a sample of `BKTBasicStepOperation` subclassing, you can read the source of `BKTJSONParsingOperation`.  
Is is intented to run on iOS 6.1 an above. We recommend using Xcode 6.0 or above to build it.

## <a name="requirements"></a> Requirements
BkTask requires iOS 5.0 and above. If you need iOS 4.3 compatibility, you can exclude the `BKTJSONParsingOperation` class of the BkTask target and it should be okay. 
However this tip is not guaranteed to stay true in future releases.  
Xcode 5.0 is required to build the BkTask project. The `BKTURLSessionLoadingOperation` cannot be used before iOS 7.0.

### ARC
BkTask uses ARC.  
If you are using BkTask in your non-arc project, you will need to set a `-fobjc-arc` compiler flag on all of the BkTask source files.  
To set a compiler flag in Xcode, go to your active target and select the "Build Phases" tab. Now select all BkTask source files, press Enter, insert -fobjc-arc and then "Done" to enable ARC for BkTask.     

If you use Xcode 4 workspaces with BkTask included as a project into your workspace then you don't need any specific configuration related to ARC.

## Licence
BkTask is available under the MIT license. See the LICENSE file for more info.

[![Analytics](https://ga-beacon.appspot.com/UA-44164731-1/bktask/readme)](https://github.com/igrigorik/ga-beacon?pixel)
