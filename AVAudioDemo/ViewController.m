//
//  ViewController.m
//  AVAudioDemo
//
//  Created by Y杨定甲 on 16/2/25.
//  Copyright © 2016年 damai. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()<AVAudioRecorderDelegate>
{
    
    NSURL *recordFile;
    AVAudioRecorder *recorder;
    BOOL recording;
    AVAudioPlayer *audioPlayer;
    
}
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //保存录音文件和格式
    NSString *fileStr = [NSString stringWithFormat:@"YYDJ_record.caf"];
    recordFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileStr]];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)record:(id)sender {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (!recording) {
        recording = YES;
//        在获得一个AVAudioSession类的实例后，你就能通过调用音频会话对象的setCategory:error:实例方法，来从IOS应用可用的不同类别中作出选择。record会停止其他声音，只开启录音
        [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
        //该方法则是设置AVAudioSession是否处于活动状态的方法
        [audioSession setActive:YES error:nil];
        [self.recordBtn setTitle:@"停止录音" forState:UIControlStateNormal];
        
        /*
         AVSampleRateKey：音频质量采样率
         AVFormatIDKey：录制音频的格式  lpcm
         AVLinearPCMBitDepthKey: 采样位数 默认16
         AVNumberOfChannelsKey: 通道的数目
         AVLinearPCMIsBigEndianKey： 大端还是小端，是内存的组织方式
         AVLinearPCMIsFloatKey： 采样信号是整数还是浮点
        */
        NSDictionary *setting = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithFloat: 44100.0],AVSampleRateKey, [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey, [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey, [NSNumber numberWithInt: 2], AVNumberOfChannelsKey, [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey, [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey, nil];
        
        recorder = [[AVAudioRecorder alloc]initWithURL:recordFile settings:setting error:nil];
        recorder.delegate = self;
        //开始录音
        [recorder stop];
        [recorder prepareToRecord];
        [recorder record];
    }else{
        recording = NO;
        [audioSession setActive:NO error:nil];
        [recorder stop];
        [self.recordBtn setTitle:@"录音" forState:UIControlStateNormal];
    }
    
    
    
    
    
}
- (IBAction)playing:(id)sender {
    NSError *error;
    audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:recordFile
                                                      error:&error];
    
    audioPlayer.volume=1;//设置音量
    if (error) {
        NSLog(@"error:%@",[error description]);
        return;
    }
    [recorder stop];
    //准备播放
    [audioPlayer prepareToPlay];
    //播放
    [audioPlayer play];
}

@end
