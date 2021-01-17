# TYZTool

TagView_Demo

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



ReactiveCocoa_demo

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
