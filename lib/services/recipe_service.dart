import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe/models/recipe.dart';
import 'package:recipe/config/api_config.dart';

class RecipeService {
  // 单例模式
  static final RecipeService _instance = RecipeService._internal();
  
  factory RecipeService() {
    return _instance;
  }
  
  RecipeService._internal() {
    // 初始化时从API加载数据
    fetchRecipesFromApi();
  }
  
  // 存储从API获取的菜谱
  List<Recipe> _recipes = [];
  
  // 本地菜谱数据，作为备用数据
  final List<Recipe> _localRecipes = [
    // 川菜
    Recipe(
      id: '1',
      title: '麻婆豆腐',
      imageUrl: 'assets/麻婆豆腐.jpg',
      ingredients: ['豆腐400g', '猪肉末100g', '郫县豆瓣酱', '花椒', '干辣椒', '葱花', '蒜末', '生抽', '盐'],
      steps: [
        '豆腐切块，泡盐水10分钟',
        '热锅下油，爆香蒜末',
        '加入肉末翻炒至变色',
        '加入豆瓣酱炒出红油',
        '加入适量水烧开，放入豆腐',
        '大火烧至入味',
        '最后撒上花椒粉和葱花即可'
      ],
      cookingTime: 20,
      category: '川菜',
    ),
    Recipe(
      id: '2',
      title: '回锅肉',
      imageUrl: 'assets/回锅肉.jpg',
      ingredients: ['五花肉400g', '青椒', '蒜苗', '豆瓣酱', '料酒', '生抽', '盐'],
      steps: [
        '五花肉切片，焯水后晾干',
        '青椒、蒜苗切段',
        '热锅下油，爆香豆瓣酱',
        '放入肉片翻炒至表面微卷',
        '加入青椒和蒜苗翻炒',
        '加入调味料翻炒均匀即可'
      ],
      cookingTime: 25,
      category: '川菜',
    ),
    // 粤菜
    Recipe(
      id: '3',
      title: '白切鸡',
      imageUrl: 'assets/白切鸡.jpg',
      ingredients: ['整鸡1只', '姜片', '葱段', '料酒', '盐', '生抽', '蒜蓉', '姜葱油'],
      steps: [
        '鸡洗净，加入姜片、葱段、料酒腌制20分钟',
        '锅中加水，放入鸡，大火煮沸',
        '转小火慢炖30分钟',
        '关火焖10分钟',
        '取出晾凉后切块',
        '淋上姜葱油和蒜蓉即可'
      ],
      cookingTime: 60,
      category: '粤菜',
    ),
    Recipe(
      id: '4',
      title: '虾仁炒蛋',
      imageUrl: 'assets/虾仁炒蛋.jpg',
      ingredients: ['虾仁200g', '鸡蛋3个', '葱花', '盐', '料酒', '淀粉'],
      steps: [
        '虾仁去壳，用盐和料酒腌制10分钟',
        '鸡蛋打散，加入少许盐',
        '热锅下油，倒入蛋液炒至半熟',
        '加入虾仁翻炒',
        '最后撒上葱花即可'
      ],
      cookingTime: 15,
      category: '粤菜',
    ),
    // 鲁菜
    Recipe(
      id: '5',
      title: '糖醋鲤鱼',
      imageUrl: 'assets/糖醋鲤鱼.jpg',
      ingredients: ['鲤鱼1条', '葱姜', '料酒', '醋', '白糖', '生抽', '淀粉'],
      steps: [
        '鱼洗净，两面划花刀',
        '腌制15分钟去腥',
        '热油锅炸至金黄',
        '另起锅，加入调味料熬制糖醋汁',
        '淋在鱼身上即可'
      ],
      cookingTime: 40,
      category: '鲁菜',
    ),
    Recipe(
      id: '6',
      title: '葱爆羊肉',
      imageUrl: 'assets/葱爆羊肉.jpg',
      ingredients: ['羊肉300g', '大葱', '姜片', '蒜片', '料酒', '生抽', '盐'],
      steps: [
        '羊肉切片，用料酒腌制20分钟',
        '大葱切段，姜蒜切片',
        '热锅下油，爆香姜蒜',
        '加入羊肉快速翻炒',
        '加入大葱翻炒',
        '加入调味料翻炒均匀即可'
      ],
      cookingTime: 25,
      category: '鲁菜',
    ),
  ];
  
  // 从API获取菜谱数据
  Future<void> fetchRecipesFromApi() async {
    try {
      // 获取API密钥
      final apiKey = await ApiConfig.getApiKey();
      
      // 检查API密钥是否为空
      if (apiKey.isEmpty) {
        // 如果API密钥为空，直接使用本地数据
        _recipes = [..._localRecipes];
        print('未设置API密钥，使用本地数据');
        return;
      }
      
      // 构建API请求URL
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.searchEndpoint}?apiKey=$apiKey&number=20');
      
      // 发送请求
      final response = await http.get(url);
      
      // 检查响应状态
      if (response.statusCode == 200) {
        // 解析响应数据
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        
        // 清空现有数据
        _recipes = [];
        
        // 将API响应数据转换为Recipe对象
        for (var item in results) {
          // 获取菜谱详情
          final recipeDetails = await getRecipeDetails(item['id'].toString());
          if (recipeDetails != null) {
            _recipes.add(recipeDetails);
          }
        }
      } else {
        // 如果API请求失败，使用本地数据
        _recipes = [..._localRecipes];
        print('API请求失败: ${response.statusCode}');
      }
    } catch (e) {
      // 发生错误时使用本地数据
      _recipes = [..._localRecipes];
      print('获取菜谱数据时出错: $e');
    }
  }
  
  // 获取菜谱详情
  Future<Recipe?> getRecipeDetails(String id) async {
    try {
      // 获取API密钥
      final apiKey = await ApiConfig.getApiKey();
      // 构建API请求URL
      final detailsUrl = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.recipeDetailsEndpoint.replaceAll('{id}', id)}?apiKey=$apiKey');
      final stepsUrl = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.recipeStepsEndpoint.replaceAll('{id}', id)}?apiKey=$apiKey');
      
      // 发送请求
      final detailsResponse = await http.get(detailsUrl);
      final stepsResponse = await http.get(stepsUrl);
      
      // 检查响应状态
      if (detailsResponse.statusCode == 200 && stepsResponse.statusCode == 200) {
        // 解析响应数据
        final detailsData = json.decode(detailsResponse.body);
        final stepsData = json.decode(stepsResponse.body);
        
        // 提取食材列表
        List<String> ingredients = [];
        if (detailsData['extendedIngredients'] != null) {
          for (var ingredient in detailsData['extendedIngredients']) {
            ingredients.add(ingredient['original']);
          }
        }
        
        // 提取步骤列表
        List<String> steps = [];
        if (stepsData.isNotEmpty && stepsData[0]['steps'] != null) {
          for (var step in stepsData[0]['steps']) {
            steps.add(step['step']);
          }
        }
        
        // 创建Recipe对象
        return Recipe(
          id: id,
          title: detailsData['title'] ?? '',
          imageUrl: detailsData['image'] ?? '',
          ingredients: ingredients,
          steps: steps,
          cookingTime: detailsData['readyInMinutes'] ?? 30,
          category: detailsData['dishTypes'] != null && detailsData['dishTypes'].isNotEmpty 
              ? detailsData['dishTypes'][0] 
              : '未分类',
          isFavorite: false,
        );
      }
      return null;
    } catch (e) {
      print('获取菜谱详情时出错: $e');
      return null;
    }
  }
  
  // 搜索API菜谱
  Future<List<Recipe>> searchApiRecipes(String query) async {
    try {
      // 获取API密钥
      final apiKey = await ApiConfig.getApiKey();
      // 构建API请求URL
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.searchEndpoint}?apiKey=$apiKey&query=$query&number=10');
      
      // 发送请求
      final response = await http.get(url);
      
      // 检查响应状态
      if (response.statusCode == 200) {
        // 解析响应数据
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        
        List<Recipe> searchResults = [];
        
        // 将API响应数据转换为Recipe对象
        for (var item in results) {
          // 获取菜谱详情
          final recipeDetails = await getRecipeDetails(item['id'].toString());
          if (recipeDetails != null) {
            searchResults.add(recipeDetails);
          }
        }
        
        return searchResults;
      }
      return [];
    } catch (e) {
      print('搜索菜谱时出错: $e');
      return [];
    }
  }
  
  // 获取所有菜谱
  List<Recipe> getAllRecipes() {
    return [..._recipes];
  }
  
  // 根据ID获取菜谱
  Recipe? getRecipeById(String id) {
    try {
      return _recipes.firstWhere((recipe) => recipe.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // 获取收藏的菜谱
  List<Recipe> getFavoriteRecipes() {
    return _recipes.where((recipe) => recipe.isFavorite).toList();
  }
  
  // 切换收藏状态
  void toggleFavorite(String id) {
    final index = _recipes.indexWhere((recipe) => recipe.id == id);
    if (index >= 0) {
      final recipe = _recipes[index];
      _recipes[index] = recipe.copyWith(isFavorite: !recipe.isFavorite);
    }
  }
  
  // 搜索菜谱（本地搜索）
  List<Recipe> searchRecipes(String query) {
    if (query.isEmpty) {
      return getAllRecipes();
    }
    return _recipes.where((recipe) {
      return recipe.title.toLowerCase().contains(query.toLowerCase()) ||
          recipe.category.toLowerCase().contains(query.toLowerCase()) ||
          recipe.ingredients.any((ingredient) => ingredient.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }
  
  // 刷新菜谱数据
  Future<void> refreshRecipes() async {
    await fetchRecipesFromApi();
  }
  
  // 根据分类获取菜谱
  List<Recipe> getRecipesByCategory(String category) {
    return _recipes.where((recipe) => recipe.category == category).toList();
  }
  
  // 获取所有分类
  List<String> getAllCategories() {
    final categories = _recipes.map((recipe) => recipe.category).toSet().toList();
    return categories;
  }
}