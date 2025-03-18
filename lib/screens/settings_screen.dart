import 'package:flutter/material.dart';
import 'package:recipe/config/api_config.dart';
import 'package:recipe/services/recipe_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final apiKey = await ApiConfig.getApiKey();
    setState(() {
      _apiKeyController.text = apiKey;
    });
  }

  Future<void> _saveApiKey() async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final apiKey = _apiKeyController.text.trim();
      if (apiKey.isEmpty) {
        setState(() {
          _errorMessage = '请输入API密钥';
          _isSaving = false;
        });
        return;
      }

      await ApiConfig.setApiKey(apiKey);
      
      // 保存API密钥后刷新食谱数据
      final recipeService = RecipeService();
      await recipeService.refreshRecipes();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('API密钥保存成功，食谱数据已更新')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = '保存失败: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Spoonacular API密钥',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '请输入您的Spoonacular API密钥，您可以在Spoonacular官网注册获取免费密钥。',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _apiKeyController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: '请输入API密钥',
                errorText: _errorMessage,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveApiKey,
                child: _isSaving
                    ? const CircularProgressIndicator()
                    : const Text('保存'),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '如何获取API密钥？',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. 访问 https://spoonacular.com/food-api/console#Dashboard\n'
              '2. 注册并登录账号\n'
              '3. 在控制台页面找到您的API密钥\n'
              '4. 复制并粘贴到上方输入框中',
            ),
          ],
        ),
      ),
    );
  }
}