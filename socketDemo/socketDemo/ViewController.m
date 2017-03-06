//
//  ViewController.m
//  socketDemo
//
//  Created by 梁家伟 on 17/3/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "ViewController.h"
#import <sys/socket.h>
#import <netinet/ip.h>
#import <arpa/inet.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *recieveLabel;
@property (weak, nonatomic) IBOutlet UITextField *ipLabel;
@property (weak, nonatomic) IBOutlet UITextField *portLabel;
@property (weak, nonatomic) IBOutlet UILabel *connectResultLabel;
@property (weak, nonatomic) IBOutlet UITextField *sendTextField;

@end

@implementation ViewController{
    int socketId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
}

- (IBAction)btn_connect:(UIButton *)sender {
    
    BOOL connectResult = [self connect:_ipLabel.text andPort:[_portLabel.text intValue]];
    
    if(!connectResult){
        NSLog(@"失败");
        _connectResultLabel.text = @"连接失败";
    }else{
        _connectResultLabel.text = @"连接成功";
    }
}

- (IBAction)btn_send:(UIButton *)sender {
    [self sendAndReceive];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)connect:(NSString*)ipAddress andPort:(NSUInteger)port{
    
    socketId = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    
    struct sockaddr_in sockadress;
    
    sockadress.sin_family = AF_INET;
    
    sockadress.sin_port = htons(port);
    
    sockadress.sin_addr.s_addr =  inet_addr(ipAddress.UTF8String);
    
    int connectResult = connect(socketId, &sockadress, sizeof(sockadress));
    return connectResult == 0;
}


-(void)sendAndReceive{
 
    ssize_t sendLenth = send(socketId,_sendTextField.text.UTF8String, strlen(_sendTextField.text.UTF8String), 0);
    NSString * resultStr = sendLenth  < 0 ? @"发送失败" : @"发送成功";
    _sendTextField.text = resultStr;
    
    uint8_t buffer[1024];
    ssize_t length = recv(socketId, buffer, sizeof(buffer), 0);
    
    NSData* data = [NSData dataWithBytes:buffer length:length];
    _recieveLabel.text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}


@end
