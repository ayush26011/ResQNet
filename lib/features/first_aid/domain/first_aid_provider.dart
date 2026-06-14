import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/database_service.dart';
import '../../../shared/models/first_aid_guide.dart';
import '../data/first_aid_data.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedCategoryProvider =
    StateProvider<FirstAidCategory?>((ref) => null);

class FirstAidNotifier extends StateNotifier<List<FirstAidGuide>> {
  FirstAidNotifier() : super([]) {
    loadGuides();
  }

  Future<void> loadGuides() async {
    try {
      final guides = await DatabaseService.instance.getFirstAidGuides();
      state = guides;
    } catch (_) {
      state = [];
    }
  }
}

final firstAidGuidesProvider =
    StateNotifierProvider<FirstAidNotifier, List<FirstAidGuide>>((ref) {
  return FirstAidNotifier();
});

List<FirstAidCategory> groupGuidesToCategories(List<FirstAidGuide> guides) {
  final Map<String, List<FirstAidArticle>> categoryToArticles = {};
  final Map<String, String> categoryToEmoji = {};

  for (final guide in guides) {
    final categoryKey = guide.category;
    if (!categoryToArticles.containsKey(categoryKey)) {
      categoryToArticles[categoryKey] = [];
    }
    categoryToEmoji[categoryKey] = guide.emoji;

    categoryToArticles[categoryKey]!.add(
      FirstAidArticle(
        id: guide.id,
        title: guide.title,
        summary: guide.shortDescription,
        steps: guide.steps,
        warnings: guide.warnings,
        emoji: guide.emoji,
        duration: guide.duration,
        difficulty: guide.difficulty,
      ),
    );
  }

  return categoryToArticles.entries.map((entry) {
    final categoryName = entry.key;
    final articles = entry.value;
    final emoji = categoryToEmoji[categoryName] ?? '🩺';

    return FirstAidCategory(
      id: categoryName.toLowerCase().replaceAll(' ', '_'),
      title: categoryName,
      subtitle: '${articles.length} topic${articles.length == 1 ? "" : "s"} available',
      emoji: emoji,
      articles: articles,
    );
  }).toList();
}

final filteredCategoriesProvider = Provider<List<FirstAidCategory>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final allGuides = ref.watch(firstAidGuidesProvider);

  final filteredGuides = allGuides.where((guide) {
    if (query.isEmpty) return true;
    return guide.title.toLowerCase().contains(query) ||
        guide.category.toLowerCase().contains(query) ||
        guide.shortDescription.toLowerCase().contains(query) ||
        guide.steps.any((s) => s.toLowerCase().contains(query)) ||
        guide.warnings.any((w) => w.toLowerCase().contains(query));
  }).toList();

  return groupGuidesToCategories(filteredGuides);
});
