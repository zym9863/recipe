import 'package:flutter/material.dart';
import 'package:recipe/models/recipe.dart';
import 'package:recipe/services/recipe_service.dart';
import 'package:recipe/widgets/recipe_card.dart';
import 'package:recipe/screens/recipe_detail_screen.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeService = RecipeService();
    final recipes = recipeService.getAllRecipes();
    final categories = recipeService.getAllCategories();

    return DefaultTabController(
      length: categories.length + 1,
      child: Scaffold(
        appBar: TabBar(
          isScrollable: true,
          tabs: [
            const Tab(text: '全部'),
            ...categories.map((category) => Tab(text: category)).toList(),
          ],
        ),
        body: TabBarView(
          children: [
            // 全部菜谱
            _buildRecipeGrid(context, recipes),
            // 分类菜谱
            ...categories.map((category) => 
              _buildRecipeGrid(context, recipeService.getRecipesByCategory(category))
            ).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeGrid(BuildContext context, List<Recipe> recipes) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: recipes.length,
      itemBuilder: (ctx, index) {
        final recipe = recipes[index];
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