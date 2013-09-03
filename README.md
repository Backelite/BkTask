# BkTask
Asynchronous and modular.
Asynchronous => keep the UI Thread for UI.
Modular => Easily change a step in a workflow without breaking everything

NSOperation + KVO

Used in AppStore applications.

## Changes
v 0.6  

* ARC Conversion
* Added Weather sample project
* Code documentation in appledoc format

## Getting started
### Xcode configuration
The simplest way to use BkTask with your project is with Xcode 4 workspaces. Just drag and drop `BkTask.xcodeproj` below your other projects in the workspace.
![Drop BkTask xcodeproj into your workspace](http://git.backelite.com/raw/?f=Images/BkTask_1.jpg&r=backelite/BkTask.git "Drop BkTask xcodeproj into your workspace")  

Then, select your project's target and click on the `Build Phases` tab. Unfold the `Link Binary With Libraries` section and click on the + button to add a new library.
Select `libBkTask.a` and click `Add`.  
![Add libBkTask.a to your target](http://git.backelite.com/raw/?f=Images/BkTask_2.jpg&r=backelite/BkTask.git "Add libBkTask.a to your target")  

As it is a static library, you will need to indicate the path to BkTask headers. To do so, select your project's target and click on the `Build Settings` tab. Find the `Header Search Paths` and set the path to the `Classes` directory of BkTask.
For instance, let's assume that you have a `Libraries` directory at the same level of your `.xcodeproj` where you store all your external libraries. In that case, the header to indicate would be `$(SRCROOT)/Librairies/BkTask/Classes`.  
![Add BkTask headers to your Header Search Paths](http://git.backelite.com/raw/?f=Images/BkTask_3.jpg&r=backelite/BkTask.git "Add BkTask headers to your Header Search Paths")  

__To make this step even easier, support for cocoapods is coming soon.__

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

```Objective-C

	//Create a task
	BkTask *aTask = [[BkTask alloc] init];

	//Create a file load step
	BkFileLoadingOperation *fileLoadOperation = [BkFileLoadingOperation loadOperationWithFile:FILE_TO_OPEN_URL];

	//Add the step to the task
	[aTask addStep:fileLoadOperation];

	//Set completion and failure blocks
	[aTask addTarget:self completion:^(BkTask *task, id output) {
    NSLog(@"Task completed with success");
	}];
	[aTask addTarget:self failure:^(BkTask *task, NSError *error) {
    NSLog(@"Task failed");
	}];

	//Start the task
	self.myTask = aTask; //To retain the task
	[self.myTask start];
```

Of course, a task with one step is not very usefull because GCD is better at that. However, when you have a workflow with multiple steps, it becomes a mess of nested blocks with GCD while BkTask takes care of chaining steps and passing data through them.

##### Quick tasks

For frequent use cases, there are helper methods to build preconfigured tasks.  
```Objective-C

	// To create a task with a download URL step
	+ (id) taskWithRequest:(NSURLRequest *)aRequest;

	// To create a task with a download URL step and a JSON parsing step
	+ (id) taskWithJSONRequest:(NSURLRequest *)aRequest;
```

-------

### Sample project
The sample project is a little weather application. You can search for a city and see related forecasts. It demonstrates how to create a task that will download and parse JSON. It also shows how to add a simple custom step to a task for JSON Dictionary to model object conversion.  
Is is intented to run on iOS 6.0 an above. We recommend using Xcode 4.6.2 and above to build it.

## Requirements
BkTask requires iOS 5.0 and above. If you need iOS 4.3 compatibility, you can exclude the `BkJSONParsingOperation` class of the BkTask target and it should be okay. 
However this tip is not guaranteed to stay true in future releases. 

### ARC
BkTask uses ARC.  
If you are using BkTask in your non-arc project, you will need to set a `-fobjc-arc` compiler flag on all of the BkTask source files.  
To set a compiler flag in Xcode, go to your active target and select the "Build Phases" tab. Now select all BkTask source files, press Enter, insert -fobjc-arc and then "Done" to enable ARC for BkTask.     

If you use Xcode 4 workspaces with BkTask included as a project into your workspace then you don't need any specific configuration related to ARC.

## Licence
BkTask is available under the MIT license. See the LICENSE file for more info.
