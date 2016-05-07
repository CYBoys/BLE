//
//  ViewController.m
//  CoreBloothTest
//
//  Created by chairman on 16/5/7.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//
/**
 1. 建立中心角色
 2. 扫描外设（discover）
 3. 连接外设(connect)
 4. 扫描外设中的服务和特征(discover)
 - 4.1 获取外设的services
 - 4.2 获取外设的Characteristics,获取Characteristics的值，获取 Characteristics的Descriptor和Descriptor的值
 5. 与外设做数据交互(explore and interact)
 6. 订阅Characteristic的通知
 7. 断开连接(disconnect)
 */
#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "Const.h"

@interface ViewController ()
<
CBCentralManagerDelegate,
UITableViewDataSource,
UITableViewDelegate,
CBPeripheralDelegate
>
@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) NSMutableArray *peripherals;
@property (nonatomic, strong) UITableView *tableView;

@end
static NSString * cellIdentifier = @"Cell";
@implementation ViewController
#pragma mark - Lazy loading
- (CBCentralManager *)manager {
    if (!_manager) {
        _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return _manager;
}
- (NSMutableArray *)peripherals {
    if (!_peripherals) {
        _peripherals = [NSMutableArray array];
    }
    return _peripherals;
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    //* 扫描所有外设 */
    // serviceUUIDs:可以将你想要扫描的服务的外围设备传入(传nil,扫描所有的外围设备)
    [self.manager scanForPeripheralsWithServices:nil options:nil];
}
#pragma mark - CBCentralManagerDelegate
//* 状态发生改变的时候会执行该方法(蓝牙4.0没有打开变成打开状态就会调用该方法) */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state==CBCentralManagerStatePoweredOn) {
        //* 扫描所有外围设备 */
        // serviceUUIDs:可以将你想要扫描的服务的外围设备传入(传nil,扫描所有的外围设备)
        [self.manager scanForPeripheralsWithServices:nil options:nil];
    }
}
/**
 *  当发现外围设备的时候会调用该方法
 *
 *  @param peripheral        发现的外围设备
 *  @param advertisementData 外围设备发出信号
 *  @param RSSI              信号强度
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (![self.peripherals containsObject:peripheral]) {
        [self.peripherals addObject:peripheral];
        [self.tableView reloadData];
    }
}
/**
  *  连接上外围设备的时候会调用该方法
  *
  *  @param peripheral 连接上的外围设备
  */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //* 停止扫描 */
    [self.manager stopScan];
    NSLog(@"连接成功");
    // 1.扫描所有的服务
    // serviceUUIDs:指定要扫描该外围设备的哪些服务(传nil,扫描所有的服务)
    [peripheral discoverServices:nil];
    
    // 2.设置代理
    peripheral.delegate = self;
}

#pragma mark - CBPeripheralDelegate
/**
 *  发现外围设备的服务会来到该方法(扫描到服务之后直接添加peripheral的services)
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services) {
        NSLog(@"service = %@",service);
        // characteristicUUIDs : 可以指定想要扫描的特征(传nil,扫描所有的特征)
        [peripheral discoverCharacteristics:nil forService:service];
    }
}
/**
 *  当扫描到某一个服务的特征的时候会调用该方法
 *
 *  @param service    在哪一个服务里面的特征
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"%@",service.characteristics);
    for (CBCharacteristic *characteristic in service.characteristics) {
        if (characteristic.properties & CBCharacteristicPropertyWrite) {
            if ([characteristic.UUID.UUIDString isEqualToString:kWriteUUID]) {
                [peripheral writeValue:[@"hello,外设" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
            NSLog(@"写数据给外设");

            }
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.peripherals.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    CBPeripheral *peripheral = self.peripherals[indexPath.row];
    cell.textLabel.text = peripheral.name;
    return cell;
}

#pragma mark - UITableViewDelegate
//* 连接外围设备 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CBPeripheral *peripheral = self.peripherals[indexPath.row];
//    if ([peripheral.name hasSuffix:@"iPhone"]) {
        [self.manager connectPeripheral:peripheral options:nil];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
