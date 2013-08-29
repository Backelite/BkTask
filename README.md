# BkTask


## Changes
v 0.6  

* ARC Conversion
* Code documentation in appledoc format

## Getting started
### Xcode configuration

### Using BkTask

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
