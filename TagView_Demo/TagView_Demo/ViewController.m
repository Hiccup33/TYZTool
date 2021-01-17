//
//  ViewController.m
//  TagView_Demo
//
//  Created by Hiccup on 2021/1/17.
//

#import "ViewController.h"
#import "TagView.h"
#import "Masonry.h"

@interface ViewController ()

@property (nonatomic, strong) TagView *testView1;
@property (nonatomic, strong) TagView *testView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    // 后置标签
    [self.view addSubview:self.testView1];
    float h2 = [self.testView1 initWithTitle:@"我是标题我是我是标题我是我是标题我是我是标标我是标题题标题" tagString:@"后置标签666"];
    NSLog(@"height : %.2f", h2);
    
    [self.testView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(200);
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(h2);
    }];
    
    
    
    // 前置标签
    [self.view addSubview:self.testView2];
    float h3 = [self.testView2 initWithTitle:@"我是标题我是我是标题我是我是标题我是我是标标我是标题题标题我是标题我是我是标题我是我是标我是标题我是我是标题我是我是标我是标题我是我是标题我是我是标我是标题我是我是标题我是我是标" tagString:@"我是前置标签666"];
    NSLog(@"height : %.2f", h3);
    
    [self.testView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.testView1.mas_bottom).offset(50);
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(h3);
    }];
}

- (TagView *)testView1 {
    
    if (!_testView1) {
        
        float width = self.view.frame.size.width-20;
        _testView1 = [[TagView alloc] init];
        _testView1.backgroundColor = [UIColor whiteColor];
        
        _testView1.titleColor = [UIColor blackColor];///标题字体颜色
        _testView1.tagColor = [UIColor whiteColor];///标签字体颜色
        _testView1.tagBgColor = [UIColor blueColor];///标签背景色
        _testView1.maxWidth = width;///视图最大宽度
        _testView1.tagMaxLength = 10;///标签最多显示的字符数
        _testView1.margin = 5;///内容左右间距
        _testView1.fontSize = 15;///标题字体大小
        _testView1.tagFontSize = 12;///标签字体大小
        _testView1.tagHeight = 16;///标签高度
        _testView1.tagType = TagType_Forward;///标签前置/后置
        _testView1.lineSpacing = 2;///行间距
        _testView1.firstLineHeadIndent = 20;///首行缩进
        _testView1.paragraphSpacingBefore = 30;///段间距
        _testView1.wordspace = 2;///字间距
        
    }
    return _testView1;
}

- (TagView *)testView2 {
    
    if (!_testView2) {
        
        float width = self.view.frame.size.width-20;
        _testView2 = [[TagView alloc] init];
        _testView2.backgroundColor = [UIColor whiteColor];
        
        _testView2.titleColor = [UIColor blackColor];///标题字体颜色
        _testView2.tagColor = [UIColor whiteColor];///标签字体颜色
        _testView2.tagBgColor = [UIColor blueColor];///标签背景色
        _testView2.maxWidth = width;///视图最大宽度
        _testView2.tagMaxLength = 10;///标签最多显示的字符数
        _testView2.margin = 5;///内容左右间距
        _testView2.fontSize = 20;///标题字体大小
        _testView2.tagFontSize = 15;///标签字体大小
        _testView2.tagHeight = 16;///标签高度
        _testView2.tagType = TagType_Frant;///标签前置/后置
        _testView2.lineSpacing = 2;///行间距
        _testView2.firstLineHeadIndent = 0;///首行缩进
        _testView2.paragraphSpacingBefore = 30;///段间距
        _testView2.wordspace = 2;///字间距
        
    }
    return _testView2;
}

@end
