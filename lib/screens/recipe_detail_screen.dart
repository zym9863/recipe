import 'package:flutter/material.dart';
import 'package:recipe/models/recipe.dart';
import 'package:recipe/services/recipe_service.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Recipe? recipe;
  final RecipeService _recipeService = RecipeService();

  @override
  void initState() {
    super.initState();
    recipe = _recipeService.getRecipeById(widget.recipeId);
  }

  void _toggleFavorite() {
    setState(() {
      _recipeService.toggleFavorite(widget.recipeId);
      recipe = _recipeService.getRecipeById(widget.recipeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('菜谱详情')),
        body: const Center(child: Text('菜谱不存在')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe!.title),
        actions: [
          IconButton(
            icon: Icon(
              recipe!.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: recipe!.isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 菜谱图片
            AspectRatio(
              aspectRatio: 16 / 9,
              child: recipe!.imageUrl.startsWith('http') 
                ? Image.network(
                    recipe!.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(child: Text('图片加载失败')),
                      );
                    },
                  )
                : Image.asset(
                    recipe!.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(child: Text('图片加载失败')),
                      );
                    },
                  ),
            ),
            
            // 烹饪时间
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.timer, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text('烹饪时间: ${recipe!.cookingTime} 分钟', style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            
            // 食材清单
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('食材', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recipe!.ingredients.length,
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Row(
                    children: [
                      const Icon(Icons.fiber_manual_record, size: 12),
                      const SizedBox(width: 8),
                      Text(recipe!.ingredients[index]),
                    ],
                  ),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // 烹饪步骤
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('步骤', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recipe!.steps.length,
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(recipe!.steps[index])),
                    ],
                  ),
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // 生成购物清单按钮
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  _showShoppingList(context, recipe!.ingredients);
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('生成购物清单'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showShoppingList(BuildContext context, List<String> ingredients) {
    // 创建一个状态列表来跟踪每个复选框的状态
    List<bool> checkedItems = List.generate(ingredients.length, (_) => false);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.3,
            maxChildSize: 0.8,
            expand: false,
            builder: (_, scrollController) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '购物清单',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: ingredients.length,
                      itemBuilder: (ctx, index) {
                        return CheckboxListTile(
                          title: Text(ingredients[index]),
                          value: checkedItems[index],
                          onChanged: (bool? value) {
                            setState(() {
                              checkedItems[index] = value ?? false;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}