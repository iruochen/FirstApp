## CocoaPods 组件
- 根目录执行 `pod init`
- `Podfile` 文件中platform 版本设置为和工程项目相同
- 引用三方库
```
  pod 'Masonry'
```
- 执行 `pod install`
- 使用pod前点击 `FirstApp.xcodeproj` 启动，使用pod后，点击 `FirstApp.xcworkspace` 启动
- 将项目中Pods build 设置中ios依赖版本修改为项目ios版本
