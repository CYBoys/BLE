//
//  Const.h
//  peripheralDeviceTest
//
//  Created by chairman on 16/5/7.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#ifndef Const_h
#define Const_h

//* 外围设备名称 */
static NSString * kPeripheralName = @"HiSchool";
//* 服务的UUID */
static NSString * kServiceUUID = @"D5DC3450-27EF-4C3F-94D3-1F4AB15631FF";
//* 特征的UUID 通知 */
static NSString * kNotifyUUID = @"6A3D4B29-123D-4F2A-12A8-D5E211411400";
//* 特征的UUID 只读 */
static NSString * kReadUUID = @"6A3D4B29-123D-4F2A-12A8-D5E211411401";
//* 特征的UUID 读写 */
static NSString * kWriteUUID = @"6A3D4B29-123D-4F2A-12A8-D5E211411402";

#define kLocalNotificationKey @"kLocalNotificationKey"

#endif /* Const_h */
