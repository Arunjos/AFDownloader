# AFDownloader (Async File Downloader)
### Cocoa Touch Static Library

The AFDownloader library will be helpful for asynchronous file download for your projects. Currently, it supports Image and JSON files. But you can easily extend it for other types.

Examples:
Image Download code:
```
AFDownloader.downloadFileRequest(fileURL: {imageURL}).responseImage(completionHandler: {image, error in     
              // completion handler code goes here
            }).start()
```
JSON Download code:
```
AFDownloader.downloadFileRequest(fileURL: {apiURL}).responseJSON(completionHandler: {jsonObj, error in
          // completion handler code goes here
        }).start()
```
