//
//  LYZTool.m
//  LYZTools
//
//  Created by liyz on 2023/7/3.
//

#import "LYZTool.h"

#import <CoreLocation/CoreLocation.h>

@interface LYZTool()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *locationGeocoder;

@property (nonatomic, copy) LocationBlock locationBlock;
@property (nonatomic, assign) BOOL getAddress; // 是否获取位置


@end

@implementation LYZTool

+ (LYZTool *)sharedInstance {
    static LYZTool *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[LYZTool alloc] init];
    });
    return instance;
}

/// 获取定位
-(void)getLocationWithCallback:(LocationBlock)locationBlock{
    
    self.locationBlock = locationBlock;
    self.getAddress = NO;
    
    if(![CLLocationManager locationServicesEnabled]){
        self.locationBlock(@{@"code":@"404",@"msg":@"定位功能不可用"});
        return;
    }
    
    if([CLLocationManager authorizationStatus] ==  kCLAuthorizationStatusDenied){
        self.locationBlock(@{@"code":@"404",@"msg":@"请到设置中允许此应用使用定位"});
        return;
    }
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        [self.locationManager requestWhenInUseAuthorization];
    }else{
        [self.locationManager startUpdatingLocation];
    }
        
}

/// 定位回调代理
-(void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager{
    
    if(!self.locationBlock){
        return;
    }
    
    if([CLLocationManager authorizationStatus] ==  kCLAuthorizationStatusDenied){
        self.locationBlock(@{@"code":@"404",@"msg":@"请到设置中允许此应用使用定位"});
        return;
    }
    
    if([CLLocationManager authorizationStatus] ==  kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] ==  kCLAuthorizationStatusAuthorizedAlways){
        [self.locationManager startUpdatingLocation];
    }

    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    if(!self.locationBlock){
        return;
    }
    
    if(!locations.count){
        self.locationBlock(@{@"code":@"404",@"msg":@"定位失败"});
        return;
    }
        
    CLLocation *location = locations.firstObject;
        
    // 如果是获取位置 拦截处理
    if(self.getAddress){
        
        __weak typeof(self)weakSelf = self;

        [self.locationGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                    
            if(placemarks.count){
                
                CLPlacemark *placemark = placemarks.firstObject;
                NSDictionary *dic = @{@"code":@"200",
                                      @"country":placemark.country,
                                      @"city":placemark.locality,
                                      @"subLocality":placemark.subLocality,
                                      @"street":placemark.thoroughfare,
                                      @"name":placemark.name,
                };
                weakSelf.locationBlock(dic);
                weakSelf.locationBlock = nil;
            }
            
        }];
        
    }else{
        NSDictionary *dic = @{@"code":@"200",
                              @"longitude":[NSString stringWithFormat:@"%f",location.coordinate.longitude],
                              @"latitude":[NSString stringWithFormat:@"%f",location.coordinate.latitude]};
        self.locationBlock(dic);
        self.locationBlock = nil;
    }
    
    // 停止定位
    [self.locationManager stopUpdatingLocation];
    
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if(self.locationBlock){
        self.locationBlock(@{@"code":@"404",@"msg":error.localizedDescription});
    }
}

/// 获取位置
-(void)getAddressWithCallback:(LocationBlock)locationBlock{
    
    self.locationBlock = locationBlock;
    self.getAddress = YES;
    
    if(![CLLocationManager locationServicesEnabled]){
        self.locationBlock(@{@"code":@"404",@"msg":@"定位功能不可用"});
        return;
    }
    
    if([CLLocationManager authorizationStatus] ==  kCLAuthorizationStatusDenied){
        self.locationBlock(@{@"code":@"404",@"msg":@"请到设置中允许此应用使用定位"});
        return;
    }
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        [self.locationManager requestWhenInUseAuthorization];
    }else{
        [self.locationManager startUpdatingLocation];
    }

}

/// 懒加载
-(CLLocationManager *)locationManager{
    if(!_locationManager){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}
-(CLGeocoder *)locationGeocoder{
    if(!_locationGeocoder){
        _locationGeocoder = [[CLGeocoder alloc] init];
    }
    return _locationGeocoder;
}

@end
