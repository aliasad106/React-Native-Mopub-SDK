# react-native-mopub-sdk

## Getting started

```shell
yarn add https://github.com/amsdamsgram/React-Native-Mopub-SDK.git
```

### iOS

```shell
    cd ios/ && pod install
```

### Android

1. Add following permissions to your android AndroidManifest.xml
```
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

2. Declare the following activities in your <application> AndroidManifest.xml.
```
<!-- MoPub's consent dialog -->
<activity android:name="com.mopub.common.privacy.ConsentDialogActivity" android:configChanges="keyboardHidden|orientation|screenSize"/>

<!-- All ad formats -->
<activity android:name="com.mopub.common.MoPubBrowser" android:configChanges="keyboardHidden|orientation|screenSize"/>

<!-- Interstitials -->
<activity android:name="com.mopub.mobileads.MoPubActivity" android:configChanges="keyboardHidden|orientation|screenSize"/>
<activity android:name="com.mopub.mobileads.MraidActivity" android:configChanges="keyboardHidden|orientation|screenSize"/>

<!-- Rewarded Video and Rewarded Playables -->
<activity android:name="com.mopub.mobileads.RewardedMraidActivity" android:configChanges="keyboardHidden|orientation|screenSize"/>
<activity android:name="com.mopub.mobileads.MraidVideoPlayerActivity" android:configChanges="keyboardHidden|orientation|screenSize"/>
```

3. [Add a network config security file](https://developers.mopub.com/publishers/android/integrate/#step-4-add-a-network-security-configuration-file)

4. Add the following lines to android/build.gradle 
```java
allprojects {
    repositories {
        // other stuff here
        maven { url "https://maven.google.com" }
        maven { url "https://s3.amazonaws.com/moat-sdk-builds" }
```

## Usage

```javascript
import { AdLidSDK, RNMoPubInterstitial } from 'react-native-mopub-sdk';

function initializeAds(onInitialized: () => {}) {
    AdLibSDK.addEventListener("onSDKInitialized", () => {
        AdLibSDK.removeAllListeners("onSDKInitialized");

        // Initialize ad once Mopub SDK has been initialized
        RNMoPubInterstitial.initializeInterstitialAd(
            INTERSTITIAL_UNIT_ID
        );

        // Do other stuff like show an ad after initialization
        onInitialized();
    });
    
    AdLibSDK.init(INTERSTITIAL_UNIT_ID);
}
```

### Interstitial

```javascript
import { RNMoPubInterstitial } from 'react-native-mopub-sdk';
```
### Interstitial Methods
| Mehod | Description |
| --- | --- |
| initializeInterstitialAd (adUnitId: string) | Initialize Interstitial ad for the the given ad unit. |
| loadAd ()  | Load ad for the unit provided through initialization. |
|  isReady ()  | Return a promise to check whether Interstitial is ready. |
|  show ()  | Show Interstitial if loaded. |
| addEventListener (eventType: string, listener: Function) | Add listener to the events from Interstitial ad, possible event  names are "onLoaded" "onFailed", "onClicked", "onShown", "onDismissed" and "onTrackImpressionData".|
| removeAllListeners (eventType: string)| Remove listeners for added events from Interstitial ad.|

### Banner Ad

```javascript
import { MoPubBanner } from 'react-native-mopub-sdk';
```
### Banner Props
| Prop |Type| Description |
| --- | --- | --- |
|adUnitId| String |Banner ad unit id for which you want to show banner ad.|
|autoRefresh| Bool | Toggle auto-refresh enable or disable.|
|keywords| String |Pass the keywords from your app to MoPub as a comma-separated list in the ad view. Each keyword should be formatted as a key/value pair (e.g. m_age:24). Any characters can be used except & and =.|
|onLoaded|Function|Calls when the banner has successfully retrieved an ad.|
|onFailed|Function|Calls  when the banner has failed to retrieve an ad. You can get error message from the event object.|
|onClicked|Function|Calls when the user has tapped on the banner.|
|onExpanded|Function|Calls when the banner has just taken over the screen.|
|onCollapsed|Function|Calls when an expanded banner has collapsed back to its original size.|

