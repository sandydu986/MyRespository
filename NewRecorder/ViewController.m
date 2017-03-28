//
//  ViewController.m
//  NewRecorder
//
//  Created by Tiger on 3/28/17.
//  Copyright © 2017 Tiger. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property UIButton *startBtn; //录音&播放按钮
@property AVAudioRecorder *myrecord;//录音对象
@property NSURL *urlPlay;//保存路径
@property AVAudioPlayer *player;
@property UIProgressView *progress;
@property UILabel *progress_Time_label;

@end


@implementation ViewController

@synthesize startBtn;
@synthesize myrecord;
@synthesize urlPlay;
@synthesize player;
@synthesize progress;
@synthesize progress_Time_label;


- (void)viewDidLoad {
    [super viewDidLoad];
    startBtn = [[UIButton alloc]init];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"photoBtn"] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchUpInside];
    startBtn.tag=1;
    [self.view addSubview:startBtn];
    
    //记得要把autoresizingmask 布局关掉
    startBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    //接着添加约束，先添加边距约束，再添加宽高约束
    /*
     添加约束 公式：item1.attribute = multiplier ⨉ item2.attribute + constant
     自动布局
     */
    NSLayoutConstraint *startBtn_center = [NSLayoutConstraint constraintWithItem:startBtn
                                                                       attribute:NSLayoutAttributeCenterX
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view attribute:NSLayoutAttributeCenterX
                                                                      multiplier:1
                                                                        constant:0];
    
    NSLayoutConstraint *startBtn_bottom = [NSLayoutConstraint constraintWithItem:startBtn
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1
                                                                        constant:-150];
    
    [self.view addConstraints:@[startBtn_center,startBtn_bottom]];
    
    [self.view addSubview:startBtn];
    //
    progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, 300, 80)];
    progress.center = CGPointMake(self.view.center.x, self.view.center.y-100);
    progress.progress =0;
    progress.trackImage = [UIImage imageNamed:@"startBtn"];
    [self.view addSubview:progress];
    
    progress_Time_label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 80)];
    progress_Time_label.center = CGPointMake(self.view.center.x, self.view.center.y-120);
    progress_Time_label.textAlignment = NSTextAlignmentCenter;
    //    progress_Time_label.backgroundColor = [UIColor grayColor];
    progress_Time_label.alpha = 0.8;
    [self.view addSubview:progress_Time_label];
    
    /*初始化录音文件*/
    [self audio];
    /*请求网络*/
//    utils = [[Commont_Utils alloc]init ];
//    utils.delegate = self;
//    [utils httpRequstStart: BasicURL andIndex:1];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)startRecord{
    
    if (startBtn.tag==1) {
        if (player.playing) {
            [player stop];
            [myrecord deleteRecording];
            return;
        }
        progress.progress =0;
        [startBtn setBackgroundImage:[UIImage imageNamed:@"photoBtn"] forState:UIControlStateNormal];
        NSLog(@"start recording?");
        progress_Time_label.text = @"Start Recording";
        //@"%@/Documents/MySound.caf"
        //        [voiceHud startForFilePath:[NSString stringWithFormat:@"%@/byingRecord.aac", NSHomeDirectory()]];
        [myrecord prepareToRecord];
        [myrecord record];
        startBtn.tag=2;
    }else{
        NSLog(@"play recording?");
        [startBtn setBackgroundImage:[UIImage imageNamed:@"startBtn"] forState:UIControlStateNormal];
        [myrecord stop];
        //        slider.maximumValue = myrecord.accessibilityElementCount;
        //        slider.value = myrecord.accessibilityElementCount;
        
        player = [[AVAudioPlayer alloc]initWithContentsOfURL:urlPlay fileTypeHint:nil error:nil];
        AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:urlPlay options:nil];
        CMTime audioDuration = audioAsset.duration;
        float audioDurationSeconds =CMTimeGetSeconds(audioDuration);
        NSLog(@"%f,record-length",audioDurationSeconds);
        progress_Time_label.text = [NSString stringWithFormat:@"%.1fs", audioDurationSeconds];
        [progress setProgress:audioDurationSeconds animated:YES];
        
        [player play];
        startBtn.tag=1;
    };
}


-(void)audio{
    
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/byingRecord.aac", strUrl]];
    NSLog(@"*********url:%@",url);
    urlPlay = url;
    
    NSError *error;
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&setCategoryError];
    /*
     if(setCategoryError){
     NSLog(@"%@", [setCategoryError description]);
     if (_faildBlock) {
     _faildBlock([setCategoryError description]);
     }
     }
     */
    //初始化
    myrecord = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    //开启音量检测
    myrecord.meteringEnabled = YES;
    //    myrecord.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
