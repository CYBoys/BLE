//
//  ViewController.m
//  peripheralDeviceTest
//
//  Created by chairman on 16/5/7.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

/**
 1. 打开peripheralManager，设置peripheralManager的委托
 2. 创建characteristics，characteristics的description 创建service，把characteristics添加到service中，再把service添加到peripheralManager中
 3. 开启广播advertising
 4. 对central的操作进行响应
 - 4.1 读characteristics请求
 - 4.2 写characteristics请求
 - 4.4 订阅和取消订阅characteristics
 */

#import "ViewController.h"
#import "AppDelegate.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "Const.h"

@interface ViewController ()
<
CBPeripheralManagerDelegate
>
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, strong) CBPeripheralManager *manager;
@property (strong, nonatomic) CBMutableCharacteristic *characteristic; //特征
@property (strong, nonatomic) CBMutableService *service;               //服务

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];

}
#pragma mark - CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    switch (peripheral.state) {
        case CBPeripheralManagerStatePoweredOn:
            NSLog(@"外围设备BLE已打开");
            [self setupService];
            break;
            
        default:
            NSLog(@"此设备不支持BLE或未打开蓝牙功能，无法作为外围设备");
            break;
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(nullable NSError *)error{
    
    NSDictionary *dict = @{CBAdvertisementDataLocalNameKey:kPeripheralName};
    [self.manager startAdvertising:dict];
}
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(nullable NSError *)error{
    NSLog(@"启动广播");
}
//* 接受读请求 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request{
    NSLog(@"_______________我是didReceiveReadRequest分隔符号______________");
    NSLog(@"%@",[[NSString alloc] initWithData:request.value encoding:NSUTF8StringEncoding]);
}
//* 接受写请求 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests{
    NSLog(@"_______________收到中心写来的数据______________");
    CBATTRequest *request = requests.lastObject;
    NSLog(@"%@",[[NSString alloc] initWithData:request.value encoding:NSUTF8StringEncoding]);
    NSString *string = [[NSString alloc] initWithData:request.value encoding:NSUTF8StringEncoding];
    self.label.text = string;
    //* ------------------LocalNotification-------------------------------- */
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    //触发通知时间
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    //重复间隔
    //    localNotification.repeatInterval = kCFCalendarUnitMinute;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    //通知内容
    localNotification.alertBody = string;
    localNotification.applicationIconBadgeNumber = 1;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    //通知参数
    localNotification.userInfo = @{kLocalNotificationKey: @"LaiYoung"};
    
    localNotification.category = kNotificationCategoryIdentifile;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    [peripheral respondToRequest:request withResult:CBATTErrorSuccess];
    
}
#pragma mark - private method

//创建服务,特征并添加服务到外围设备
- (void)setupService{
    //可读写的特征
    CBUUID *UUID2 = [CBUUID UUIDWithString:kWriteUUID];
    self.characteristic = [[CBMutableCharacteristic alloc] initWithType:UUID2 properties:CBCharacteristicPropertyWrite|CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsWriteEncryptionRequired];
    
    CBUUID *serviceUUID = [CBUUID UUIDWithString:kServiceUUID];
    self.service = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
    [self.service setCharacteristics:@[self.characteristic]];
    
    [self.manager addService:self.service];
}

#pragma mark - 
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.label.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
