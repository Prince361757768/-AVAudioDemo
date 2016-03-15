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
    AVAudioPlayer *audioPlayer;
    AVAudioSession *audioSession;
    NSTimeInterval recordTime;
//    NSDate *dateStartRecording;
//    NSDate *dateStopRecording;
}
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pauseBtn.enabled = NO;
    //保存录音文件和格式
    NSString *fileStr = [NSString stringWithFormat:@"YYDJ_record.caf"];
    recordFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileStr]];
    NSLog(@"---%@",recordFile);
    
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
//    recorder.meteringEnabled = YES;//监控声波
    
    
    //设置音频会话
    audioSession = [AVAudioSession sharedInstance];
    //record会停止其他声音，只开启录音
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)record:(id)sender {
   
    if (![recorder isRecording]) {
        
        [self.recordBtn setTitle:@"结束录音" forState:UIControlStateNormal];
        
        //该方法则是设置AVAudioSession是否处于活动状态的方法
        [audioSession setActive:YES error:nil];
        
        //开始录音
        [recorder stop];
        //准备录音，主要用于创建缓冲区，如果不手动调用，在调用record录音时也会自动调用
        [recorder prepareToRecord];
        [recorder record];
        self.pauseBtn.enabled = YES;
    }
    else{
        recordTime = [recorder currentTime];
        [audioSession setActive:NO error:nil];
        [recorder stop];
        [self.recordBtn setTitle:@"录音" forState:UIControlStateNormal];
    }

}

- (IBAction)playing:(id)sender {
    NSError *error;
    audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:recordFile
                                                      error:&error];

    if (error) {
        NSLog(@"error:%@",[error description]);
        return;
    }
    
//    if ([recorder isRecording]) {
        recordTime = [recorder currentTime];
        [recorder stop];
        [self.recordBtn setTitle:@"录音" forState:UIControlStateNormal];
        [self.pauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
        self.recordBtn.enabled = YES;
//    }
    //准备播放
    [audioPlayer prepareToPlay];
    //播放
    [audioPlayer play];

}

- (IBAction)pauseBtn:(id)sender {
    if ([recorder isRecording]) {
        [recorder pause];
        [self.pauseBtn setTitle:@"继续录音" forState:UIControlStateNormal];
        self.recordBtn.enabled = NO;
    }else{
        //恢复录音只需要再次调用record，AVAudioSession会帮助你记录上次录音位置并追加录音
        [recorder record];
        [self.pauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
        self.recordBtn.enabled = YES;
    }


}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    NSLog(@"录音成功---录音时长：%f",recordTime);
    self.pauseBtn.enabled = NO;
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    NSLog(@"------录音失败");
}



@end
