A simple app to demonstrate generating a data file under an iOS app's Documents folder and accessing it for later use.


https://github.com/azun-c/no-bak/assets/114891397/4ea3b6e7-958d-4f8a-ad4c-8d6638535674

The data file is marked as [isExcludedFromBackup](https://developer.apple.com/documentation/foundation/urlresourcevalues/1780002-isexcludedfrombackup), so that it should not be backed up and restored via iTunes.
![Back up-Restore](https://github.com/azun-c/no-bak/assets/114891397/b9c042d6-0283-4f82-a275-5524645897ac)

However, I'm not able to demonstrate this feature, because `Back up` and `Restore Backup` will only work with apps published on AppStore
This error showed when I tried to restore an app(`no-bak`) from a backup (the app was available on TestFlight only)

![unable-to-install](https://github.com/azun-c/no-bak/assets/114891397/e333cb16-2524-429d-8466-acabb9bfb00f)
