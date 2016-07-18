
##中文说明
####`JHUD` 是一个用于加载数据时全屏显示的HUD，使用Objective-C编写.

##须知
`JHUD` 基于 "Xcode 7.3 , iOS 6+ 和ARC ，请使用最新正式版来编译JHUD,旧版本的Xcode可能有效，但不保证会出现一些兼容性问题。

##CocoaPods

推荐使用 CocoaPods 安装。

1. 在 Podfile 中添加 `pod 'JHUD'`。
2. 执行 `pod install` 或 `pod update`。
3. 导入 `"JHUD.h"`。


##手动安装
1. 通过 Clone or download 下载 JHUD 文件夹内的所有内容。
2. 将 JHUD 内的源文件添加(拖放)到你的工程。
3. 导入 `JHUD.h` 。

##使用

```
hudView = [[JHUD alloc]initWithFrame:self.view.bounds];

hudView.messageLabel.text = @"hello ,this is a circle animation";

//显示
[hudView showAtView:self.view hudType:JHUDLoadingTypeCircle];

//隐藏 
[hudView hide];
```
或者

```
[JHUD showAtView:self.view message:@"Hello, this is a message"];

[JHUD hide];
```


更多的使用用例可以看Demo工程演示以及头文件(JHUD.h)。


##许可

JHUD 使用 MIT 许可证，详情可见 [LICENSE](LICENSE) 文件。