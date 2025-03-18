# 美食菜谱 App

中文 | [English](README_EN.md)

一个功能丰富的Flutter美食菜谱应用，提供菜谱的详细制作步骤和食材清单。

## 应用功能

- **菜谱浏览**：按分类浏览各种美食菜谱
- **菜谱详情**：查看详细的食材清单和制作步骤
- **收藏功能**：收藏喜爱的菜谱，方便日后查看
- **搜索功能**：根据菜名或食材搜索菜谱
- **设置选项**：自定义应用设置

## 技术架构

### 前端
- **Flutter框架**：使用Flutter构建跨平台UI
- **Material Design**：遵循Material设计规范
- **状态管理**：使用StatefulWidget管理组件状态

### 后端集成
- **API集成**：支持与Spoonacular API集成获取更多菜谱
- **本地数据**：内置中国传统菜谱数据

## 项目结构

```
lib/
  ├── config/         # 配置文件
  ├── models/         # 数据模型
  ├── screens/        # 应用页面
  ├── services/       # 服务层
  ├── widgets/        # 可复用组件
  └── main.dart       # 应用入口
```

## 菜谱分类

应用包含多种中国传统菜系：
- 川菜（如麻婆豆腐、回锅肉）
- 粤菜（如白切鸡、虾仁炒蛋）
- 鲁菜（如糖醋鲤鱼）
- 其他地方特色菜

## 安装指南

### 前提条件
- Flutter SDK (^3.7.2)
- Dart SDK
- Android Studio / Xcode (用于运行模拟器)

### 安装步骤

1. 克隆项目到本地
   ```
   git clone https://github.com/zym9863/recipe.git
   ```

2. 进入项目目录
   ```
   cd recipe
   ```

3. 安装依赖
   ```
   flutter pub get
   ```

4. 运行应用
   ```
   flutter run
   ```

## API配置

本应用支持与Spoonacular API集成。如需使用在线菜谱功能，请按以下步骤配置：

1. 在[Spoonacular](https://spoonacular.com/food-api)注册并获取API密钥
2. 在应用设置中输入您的API密钥

## 依赖项

- flutter: sdk
- http: ^1.3.0 - 用于API请求
- google_fonts: ^6.2.1 - 用于自定义字体
- cupertino_icons: ^1.0.8 - iOS风格图标

## 开发资源

- [Flutter官方文档](https://docs.flutter.dev/)
- [Dart官方文档](https://dart.dev/guides)
- [Material Design指南](https://material.io/design)

## 贡献指南

欢迎贡献代码、报告问题或提出新功能建议。请遵循以下步骤：

1. Fork项目
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建Pull Request
