import 'package:flutter/material.dart';
import 'package:recipe/services/recipe_service.dart';
import 'package:recipe/widgets/recipe_card.dart';
import 'package:recipe/screens/recipe_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeService = RecipeService();
    final favoriteRecipes = recipeService.getFavoriteRecipes();

    return favoriteRecipes.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text('暂无收藏的菜谱', style: TextStyle(fontSize: 18, color: Colors.grey)),
                SizedBox(height: 8),
                Text('浏览菜谱并点击心形图标添加收藏', style: TextStyle(color: Colors.grey)),
              ],
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: favoriteRecipes.length,
            itemBuilder: (ctx, index) {
              final recipe = favoriteRecipes[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => RecipeDetailScreen(recipeId: recipe.id),
                    ),
                  );
                },
                child: RecipeCard(recipe: recipe),
              );
            },
          );
  }
}