[![Build Status](https://travis-ci.org/heremaps/mobility-on-demand-use-cases-ios.svg?branch=master)](https://travis-ci.org/heremaps/mobility-on-demand-use-cases-ios)

# Mobility On Demand Use Cases (iOS)

This repository hosts a demo application developed in `Objective-C` exposing the usage of the **HERE iOS SDK** and **HERE REST APIs**.

The application shows how to do a basic sdk integration, use Places API and display venue map tiles.

Visit the **HERE Developer Portal** for more information on the [HERE Mobile SDKs – Android & iOS](https://developer.here.com/develop/mobile-sdks) and the [HERE REST APIs & Platform Extensions](https://developer.here.com/develop/rest-apis).

> **Note:** In order to get the sample code to work, you **must** replace all instances of `YOUR_APP_ID` and `YOUR_APP_CODE` within the code and use your own **HERE** credentials.

> You can obtain a set of credentials from the [Plans](https://developer.here.com/plans) page on developer.here.com.

For more details about Mobility On Demand, visit the [HERE Mobility On Demand Toolkit](https://developer.here.com/mobility-on-demand-toolkit/documentation/topics/overview.html) page.

## License

Unless otherwise noted in `LICENSE` files for specific files or directories, the [LICENSE](LICENSE) in the root applies to all content in this repository.

## Setting up the application

* Replace `YOUR_APP_ID` and `YOUR_APP_CODE` placeholder values in `OnDemandPassenger/Constants.m` with your own HERE credentials.
* Download the HERE iOS Starter SDK (you can do that from your project). The example uses *version 3.3* of the SDK.
* Configure this project to use the HERE SDK. See [Creating a Simple Application Using the HERE SDK](https://developer.here.com/mobile-sdks/documentation/ios/topics/app-simple.html), in particular the `Configure the Application` section.

## Notes

The examples use the Custom Integration Test (CIT) environment.
Please refer to our API Documentation on how to change from our CIT environment to our Production environment.
