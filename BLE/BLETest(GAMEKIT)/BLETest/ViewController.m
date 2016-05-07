//
//  ViewController.m
//  TestIWatch
//
//  Created by chairman on 16/5/6.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "ViewController.h"
#import <GameKit/GameKit.h>
@interface ViewController ()
<
GKPeerPickerControllerDelegate
>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) GKSession *session;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"...");
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)senderText:(UIButton *)sender {
    NSData *data = [self.textField.text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *string =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data = %@",string),
//    GKSendDataReliable 可靠传输(数据一定会被传达,如果中间网络发生状况,重新连接,再次传输)－>TCP
//    GKSendDataUnreliable 不可靠传输(数据只会发送一次,没有收到就算了)－>UDP
    [self.session sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];
}
- (IBAction)connectDevice:(UIButton *)sender {
    GKPeerPickerController *ppc = [[GKPeerPickerController alloc] init];
    ppc.delegate = self;
    [ppc show];
}
#pragma mark - GKPeerPickerControllerDelegate
/**
 *  设备连接成功后会调用该方法
 *
 *  @param peerID  设备节点ID
 *  @param session 会话(使用该会话对象来相互传递数据)
 */
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session {
    self.session = session;
    [session setDataReceiveHandler:self withContext:nil];
    [picker dismiss];
}
#pragma mark - 接受数据
/**
 *  当接受收到数据的时候会调用该方法
 *
 *  @param data    接受到的数据
 *  @param peer    从哪一个节点接受到的数据
 *  @param session 会话
 */
- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
    self.textField.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
