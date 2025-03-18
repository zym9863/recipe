import 'package:flutter/material.dart';
import 'package:recipe/models/recipe.dart';
import 'package:recipe/services/recipe_service.dart';
import 'package:recipe/widgets/recipe_card.dart';
import 'package:recipe/screens/recipe_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Recipe> _searchResults = [];
  final RecipeService _recipeService = RecipeService();

  @override
  void initState() {
    super.initState();
    // 初始显示所有菜谱
    _searchResults = _recipeService.getAllRecipes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _searchResults = _recipeService.searchRecipes(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '搜索菜谱、食材或分类',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _performSearch('');
                },
              ),
            ),
            onChanged: _performSearch,
          ),
        ),
        Expanded(
          child: _searchResults.isEmpty
              ? const Center(child: Text('没有找到相关菜谱'))
              : GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _searchResults.length,
                  itemBuilder: (ctx, index) {
                    final recipe = _searchResults[index];
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
                ),
        ),
      ],
    );
  }
}