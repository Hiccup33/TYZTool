//
//  TagView.m
//  test_tag1
//
//  Created by Hiccup on 2020/8/25.
//  Copyright © 2020 Hiccup. All rights reserved.
//

#import "TagView.h"
#import "Masonry.h"
#import <CoreText/CoreText.h>

@interface TagView()

///文本Label
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) CGFloat labelHeight;
@property (nonatomic, assign) CGFloat labelWidth;

@end

@implementation TagView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.titleLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _labelWidth = _maxWidth-_margin*2;
    float height = [self.titleLabel sizeThatFits:CGSizeMake(_labelWidth, 0)].height;
    
    self.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
    self.titleLabel.frame = CGRectMake(_margin, 0, _labelWidth, height);
    self.titleLabel.textColor = _titleColor;

}

- (CGFloat)initWithTitle:(NSString *)title tagString:(NSString *)tagString {
    
    if (!_titleColor) _titleColor = [UIColor blackColor];///标题字体颜色,默认黑色
    if (!_tagColor) _tagColor = [UIColor whiteColor];///标签字体颜色,默认白色
    if (!_tagBgColor) _tagBgColor = [UIColor blueColor];///标签背景色,默认蓝色
    if (_maxWidth <= 0) _maxWidth = 200;///内容最大宽度,默认200
    if (_tagMaxLength <= 0) _tagMaxLength = 10;///标签最多显示的字符数
    if (_margin < 0) _margin = 5;///内容左右间距,默认5
    if (_tagFontSize <= 0) _tagFontSize = 12;///标签字号,默认12
    if (_fontSize <= 0) _fontSize = 15;///标题字号,默认15
    if (_tagHeight < 0) _tagHeight = 16;///标签高度,默认16
    if (_lineSpacing < 0) _lineSpacing = 0;///行间距,默认0
    if (_firstLineHeadIndent < 0) _firstLineHeadIndent = 0;///首行缩进,默认0
    if (_paragraphSpacingBefore < 0) _paragraphSpacingBefore = 5;///段落间距,默认5
    if (_wordspace <= 0) _wordspace = 0;///字间距,默认0
    
    ///刷新子视图
    [self layoutSubviews];
    
    ///配置
    self.titleLabel.attributedText = [self setStringWithTitle:title tag:tagString];
    
    float height = [self.titleLabel sizeThatFits:CGSizeMake(_labelWidth, 0)].height;
    return height;
}

- (NSMutableAttributedString *)setStringWithTitle:(NSString *)title tag:(NSString *)tagStr {
    
    if (!tagStr || tagStr.length == 0) tagStr = @" ";
    
    if (tagStr.length > _tagMaxLength) {
        tagStr = [tagStr substringToIndex:_tagMaxLength];
        tagStr = [NSString stringWithFormat:@"%@%@",tagStr,@"..."];
    }
    
    ///标签中包含数字/英文/英文符号个数
    int tagMixCount = [self countOfMixstring:tagStr];
    
    NSString *titleString = title;//@"我是标题！我是标题！我是标！我是标题！";
    
    ///配置文字属性
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = _lineSpacing; //设置行间距
    paraStyle.hyphenationFactor = 1.0;//自动断字
    paraStyle.firstLineHeadIndent = _firstLineHeadIndent;//首行缩进
    paraStyle.paragraphSpacingBefore = _paragraphSpacingBefore;//段间距
    paraStyle.headIndent = 0;//首行靠前(即:从第二行开始缩进)
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@(_wordspace)};
    
    ///创建  NSMutableAttributedString 富文本对象
    NSMutableAttributedString *maTitleString = [[NSMutableAttributedString alloc] initWithString:titleString attributes:dic];
    
    ///创建一个小标签的Label
    CGFloat tagW = _tagFontSize * (tagStr.length - tagMixCount) + (_tagFontSize * 0.6)*tagMixCount + 10;
    UILabel *tagLabel = [UILabel new];
    tagLabel.frame = CGRectMake(0, 0, tagW * 3, _tagHeight*3);///设置3倍宽度, 3倍高度
    tagLabel.text = tagStr;
    tagLabel.font = [UIFont boldSystemFontOfSize:_tagFontSize * 3];///设置3倍字体大小
    tagLabel.textColor = _tagColor;
    tagLabel.backgroundColor = _tagBgColor;
    tagLabel.clipsToBounds = YES;
    tagLabel.layer.cornerRadius = 3*3;///设置3倍圆角
    tagLabel.textAlignment = NSTextAlignmentCenter;
    ///调用方法，转化成Image
    UIImage *image = [self imageWithUIView:tagLabel];
    ///创建Image的富文本格式
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.bounds = CGRectMake(0, -2.5, tagW, _tagHeight); //这个-2.5是为了调整下标签跟文字的位置
    attach.image = image;
    ///添加到富文本对象里
    NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
    if (_tagType == TagType_Frant) {
        [maTitleString insertAttributedString:[[NSAttributedString alloc] initWithString:@"  "] atIndex:0];
        [maTitleString insertAttributedString:imageStr atIndex:0];//加入文字前面
        //[maTitleString insertAttributedString:imageStr atIndex:4];//加入文字第4的位置
    }else {
        [maTitleString appendAttributedString:[[NSAttributedString alloc] initWithString:@"  "]];
        [maTitleString appendAttributedString:imageStr];//加入文字后面
    }
    
    return maTitleString;
}

#pragma warning 注意:创建这个Label的时候，frame，font，cornerRadius要设置成所生成的图片的3倍，也就是说要生成一个三倍图，否则生成的图片会虚。

//view转成image
- (UIImage*) imageWithUIView:(UIView*) view{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}

///统计数字/英文/英文符号   个数
- (int)countOfMixstring:(NSString *)string{

    int remarkCount = 0;
    int numberCount = 0;
    int englishCount = 0;

    if (string.length == 0) return 0;

    for (int i = 0; i<string.length; i++) {

        NSString *c = [string substringWithRange:NSMakeRange(i,1)];
        
        ///数字
        NSString *numberRegex = @"^[0-9]+([.]{0,1}[0-9]+){0,1}$";
        NSPredicate *numberPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberRegex];
        BOOL isNumber = [numberPred evaluateWithObject:c];
        
        ///英文字符
        NSString *englishRegex = @"^[a-zA-Z]$";
        NSPredicate *englishPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",englishRegex];
        BOOL isEnglish = [englishPred evaluateWithObject:c];
        
        ///英文标点符号
        NSString*remarkRegex =@"^[\\`\\~\\!\\@\\#\\$\\%\\^\\&\\*\\(\\)\\_\\+\\-\\=\\[\\]\\{\\}\\\\|\\;\\'\\'\\:\\,\\.\\/\\<\\>\?]$";
        NSPredicate *remarkPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",remarkRegex];
        BOOL isRemark = [remarkPred evaluateWithObject:c];
        
        if(isNumber) {
            numberCount++;
        }else if(isEnglish) {
            englishCount++;
        }else if (isRemark) {
            remarkCount++;
        }else {
            
        }
    }

    return numberCount + englishCount + remarkCount;
}

///获取每一行的文字
- (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label {
    NSString *text = [label text];
    UIFont *font = [label font];
    CGRect rect = [label bounds]; CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,MAXFLOAT));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
        
        NSLog(@"lineString =====   %@", lineString);
    }
    
    return (NSArray *)linesArray;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}


@end
