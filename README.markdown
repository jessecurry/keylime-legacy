*Please note: keylime is in the early stages of development and may change if you develop anything that depends on the current interfaces it would be a good idea to fork. Once things have settled I'll remove this notice.*

Static Library Installation (XCode4)
====================================

1. Add keylime.xcodeproj to your iOS project (make sure that keylime.xcodeproj is not already opened by XCode).
2. Select your current project, then the target you wish to add keylime to, then select the "Build Phases" tab.
3. Add keylime to the "Target Dependencies".
4. Add libkeylime.a and QuartzCode to "Link Binary With Libraries".
5. Select the "Build Settings" tab.
6. Add the keylime/src directory to your header search paths.
7. If you would like to use keylime's categories add "-all_load" to the "Other Linker Flags".

At this point you should be able to successfully build your project. You can #import "keylime.h", or import the keylime classes independently.

Major Components
================

KLViewController
----------------
This is where most of keylime's functionality lives. KLViewController offers the ability to provide data for multiple UITableViews. Data can be NSFetchedResultsControllers, Arrays, or any object.

For each individual data object keylime will attempt to find a table view cell named <classname>TableViewCell (ie: if keylime sees a 'Person' object it will look for a 'PersonTableViewCell'). If your cell is a derivative of KLTableView cell keylime will automatically call configureWithDataObject: passing the data object. 

KLTableViewCell
---------------
Base class for table view cells, includes a configureWithDataObject: method that should be overriden to implement your configuration behavior. Make sure to call [super configureWithDataObject: dataObject]; to allow the cell to retain your data object.