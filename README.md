# Mangogo

A light-weight network framework based on service.

## Getting started

### iOS
* integrate to your application
- **[CocoaPods](https://cocoapods.org)**

Add the following line to your Podfile:
```
pod 'Mangogo'
```
run `pod install`


* usage

```objc
//register service mediator
[MGTaskPool registerNetworkMediatorWithName:NSStringFromClass(XXXNetworkServiceMediator.class)];
//add delegate
[[MGTaskPool shareInstance] addDelegate:self];
//and do service
[[MGTaskPool shareInstance] doServiceWithName:SERVICENAME_KYSON_INDEX params:nil];

```
and you can get response by

```
-(void)taskpool:(MGTaskPool *) pool serviceFinished:(id )service response:(MGServiceResponse *) response {}
```


## Detail Useage
see demo

## Discussion
You can add comments here : [高解耦的网络请求框架Mangogo](http://kyson.cn/index.php/archives/28/)

