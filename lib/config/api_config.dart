class ApiConfig {
  // 静态变量用于在内存中存储API密钥
  static String _apiKey = '';
  
  // 获取API密钥
  static Future<String> getApiKey() async {
    return _apiKey;
  }
  
  // 设置API密钥
  static Future<void> setApiKey(String apiKey) async {
    _apiKey = apiKey;
  }
  
  // 清除API密钥
  static Future<void> clearApiKey() async {
    _apiKey = '';
  }
  
  // Spoonacular API基础URL
  static const String baseUrl = 'https://api.spoonacular.com';
  
  // 搜索菜谱的端点
  static const String searchEndpoint = '/recipes/complexSearch';
  
  // 获取菜谱详情的端点
  static const String recipeDetailsEndpoint = '/recipes/{id}/information';
  
  // 获取菜谱步骤的端点
  static const String recipeStepsEndpoint = '/recipes/{id}/analyzedInstructions';
  
  // 获取菜谱营养信息的端点
  static const String recipeNutritionEndpoint = '/recipes/{id}/nutritionWidget.json';
  }
