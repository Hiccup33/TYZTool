//
//  ViewController.m
//  ReactiveCocoa_demo
//
//  Created by Hiccup on 2021/1/17.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>

/*
 弱引用/强引用  可配对引用在外面用WeakSelf(self)，block用StrongSelf(self)
 */
#define Weakify(type)  __weak typeof(type) weak##type = type;
#define Strongify(type)  __strong typeof(type) type = weak##type;

#define WeakSelf  Weakify(self);
#define StrongSelf  Strongify(self);

@interface ViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *tF;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *value2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tF];
    self.tF.delegate = self;
    [self.tF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(100);
        make.centerX.offset(0);
        make.height.offset(50);
        make.width.offset(100);
    }];
    
    // 键值观察 -- 监听UITextField的值发生变化
    //[self demo1];
    
    // map 的使用
    //[self demo2];
    
    // filter 使用,实现:"你向西,他就向东,你向左,他就向右"
    //[self demo3];
    
    // 使用RAC代替代理
    //必须将代理最后设置,否则信号是无法订阅到的
    //雷纯峰大大是这样子解释的:在设置代理的时候，系统会缓存这个代理对象实现了哪些代码方法
    //如果将代理放在订阅信号前设置,那么当控制器成为代理时是无法缓存这个代理对象实现了哪些代码方法的
    //[self demo4];
    
    // 实现广播
    //[self demo5];
    
    // 两个信号串联,两个管串联,一个管处理好自己的东西,下一个管才开始处理自己的东西
    //[self demo6];
    
    // 关联,只要有一个管有东西,就可以打印
    //[self demo7];
    
    // 组合,只有两个信号都有值,才可以组合
    //[self demo8];
}


- (void)demo1 {
    WeakSelf
    [weakself.tF.rac_textSignal subscribeNext:^(NSString *value) {
        StrongSelf
        self.value = value;
    }];
    
    // 当self.value值变化时,调用block,这是用KVO的机制,RAC封装了KVO
    [RACObserve(self, value) subscribeNext:^(NSString *value) {
        NSLog(@"%@", value);
    }];
    
}

- (void)demo2 {
    
    // 创建一个信号
    RACSignal *singalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //这个信号里面有一个Next事件的玻璃球和一个complete事件的玻璃球
        // 可以理解为网络请求成功之后,将结果传过去 sendNext:response
        [subscriber sendNext:@"唱歌"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    // 对信号进行改进,当信号里面流的是唱歌,就改进为"跳舞"返还给self.value
    RAC(self,tF.text) = [singalA map:^id _Nullable(NSString * value) {
        if ([value isEqualToString:@"唱歌"]) {
            return @"跳舞";
        }
        return @"";
    }];
}

- (void)demo3 {
    // 创建2个通道,一个从A流出的通道A,和一个从B流出的通道B
    RACChannelTerminal *channelA = RACChannelTo(self,value);
    RACChannelTerminal *channelB = RACChannelTo(self,value2);
    
    // 改造通道A,使通过通道A的值,如果等于"西",就改成"东"
    [[channelA map:^id _Nullable(NSString *value) {
            if ([value isEqualToString:@"西"]) {
                NSLog(@"东");
                return @"东";
            }
            NSLog(@"===== %@", value);
            return value;
        }] subscribe:channelB]; // 通道A流向B
    
    // 改造通道B,使通过通道B的值,如果等于"左",就改成"右"传出去
    [[channelB map:^id _Nullable(NSString *value) {
            if ([value isEqualToString:@"左"]) {
                NSLog(@"右");
                return @"右";
            }
            NSLog(@"==== %@", value);
            return value;
        }] subscribe:channelA];
    
    // KVO 监听valueA的值得变化,过滤valueA的值,返回YES表示通过
    // 只有value有值,才可通过
    [[RACObserve(self, value) filter:^BOOL(id value) {
            return value?YES:NO;
    }] subscribeNext:^(id x) {
        NSLog(@"你向%@",x);
    }];
    
    // KVO监听value2的变化
    [[RACObserve(self, value2) filter:^BOOL(id value) {
            return value?YES:NO;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"他向%@",x);
    }];
    
    // 下面使value的值和value2的值发生改变
    self.value = @"西";
    self.value2 = @"左";
}

- (void)demo4 {
    //为self添加一个信号,表示代理ProgrammerDelegate的makeAnApp;
    //RACTuple 相当于swift中的元祖
    /*
    [[self rac_signalForSelector:@selector(makeAnApp:String:) fromProtocol:@protocol(ProgrammerDelegate)] subscribeNext:^(RACTuple *x) {
        //这里可以立即为makeAnApp的方法要执行的代码
        NSLog(@"%@ ",x.first);
        NSLog(@"%@",x.second);
    }];
     
    // 方式二 :  使用RACSubject替代代理
     RacSubjectController *racsub = [[RacSubjectController alloc] init];
     racsub.subject = [RACSubject subject];
     [racsub.subject subscribeNext:^(id x) {
     NSLog(@"被通知了%@",x);
     }];
     // base.delegate = self;
     [self.navigationController pushViewController:racsub animated:YES];
     */
}

- (void)demo5 {
    
    //发送广播通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WWW" object:nil userInfo:@{@"技巧":@"用心听"}];
    
    // 接收通知
    //RAC的通知不需要我们手动移除
    //注册广播通知
    RACSignal *signal = [[NSNotificationCenter defaultCenter] rac_addObserverForName:@"WWW" object:nil];
    [signal subscribeNext:^(NSNotification *x) {
        NSLog(@"技巧:%@", x.userInfo[@"技巧"]);
    }];
  
}

- (void)demo6 {
    //创建一个信号管A
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"吃饭"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    //创建一个信号管B
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"吃的饱饱的,才可以睡觉的"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    // 串联管A和管B
    RACSignal *concatSignal = [signalA concat:signalB];
    // 串联后的接收端处理,两个事件,走两次,第一个打印signalA的结果,第二个打印signalB的结果
    [concatSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

- (void)demo7 {
    //创建信号A
    RACSignal *siganlA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"纸厂污水"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    //创建信号B
    RACSignal *siganlB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"电镀厂污水"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    //并联两个信号,根上面一样,分两次打印
    RACSignal *mergeSiganl = [RACSignal merge:@[siganlA,siganlB]];
    [mergeSiganl subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
}

- (void)demo8 {
    //定义2个自定义信号
    RACSubject *letters = [RACSubject subject];
    RACSubject *numbers = [RACSubject subject];
    
    //组合信号
    [[RACSignal combineLatest:@[letters,numbers] reduce:^(NSString *letter, NSString *number){
        
        return [letter stringByAppendingString:number];
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
        
    }];
    
    
    //自己控制发生信号值
    [letters sendNext:@"A"];
    [letters sendNext:@"B"];
    [numbers sendNext:@"1"]; //打印B1
    [letters sendNext:@"C"];//打印C1
    [numbers sendNext:@"2"];//打印C2
}

- (UITextField *)tF {
    if (!_tF) {
        _tF = [[UITextField alloc] init];
        _tF.backgroundColor = UIColor.grayColor;
    }
    return _tF;
}

@end
