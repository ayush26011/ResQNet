import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/first_aid_data.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedCategoryProvider =
    StateProvider<FirstAidCategory?>((ref) => null);

final filteredCategoriesProvider = Provider<List<FirstAidCategory>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  if (query.isEmpty) return firstAidCategories;
  return firstAidCategories
      .where((cat) =>
          cat.title.toLowerCase().contains(query) ||
          cat.subtitle.toLowerCase().contains(query) ||
          cat.articles.any((a) =>
              a.title.toLowerCase().contains(query) ||
              a.summary.toLowerCase().contains(query)))
      .toList();
});
