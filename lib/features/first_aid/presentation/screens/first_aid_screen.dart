import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/neumorphic_card.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../domain/first_aid_provider.dart';
import '../../data/first_aid_data.dart';
import '../widgets/article_screen.dart';

class FirstAidScreen extends ConsumerStatefulWidget {
  const FirstAidScreen({super.key});

  @override
  ConsumerState<FirstAidScreen> createState() => _FirstAidScreenState();
}

class _FirstAidScreenState extends ConsumerState<FirstAidScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoriesAsync = ref.watch(filteredCategoriesProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.warmCream,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _FirstAidHeader(
              isDark: isDark,
              searchController: _searchController,
              onSearch: (q) =>
                  ref.read(searchQueryProvider.notifier).state = q,
            ),
          ),
          categoriesAsync.when(
            data: (categories) => SliverMainAxisGroup(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.horizontalPadding,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _FeaturedCard(isDark: isDark, categories: categories),
                      const SizedBox(height: AppConstants.spaceXL),
                      SectionHeader(
                        title: 'Categories',
                        subtitle: '${categories.length} topics available',
                      ),
                      const SizedBox(height: AppConstants.spaceMD),
                    ]),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.horizontalPadding,
                  ),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.85,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _CategoryCard(
                        category: categories[index],
                        isDark: isDark,
                        delay: Duration(milliseconds: 300 + index * 80),
                        onTap: () => _openArticle(context, categories[index]),
                      ),
                      childCount: categories.length,
                    ),
                  ),
                ),
              ],
            ),
            loading: () => const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (err, stack) => SliverToBoxAdapter(
              child: Center(child: Text('Error: $err')),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  void _openArticle(BuildContext context, FirstAidCategory category) {
    if (category.articles.isEmpty) return;
    if (category.articles.length == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ArticleScreen(
            article: category.articles.first,
            categoryEmoji: category.emoji,
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => _ArticleListSheet(
          category: category,
        ),
      );
    }
  }
}

class _FirstAidHeader extends StatelessWidget {
  final bool isDark;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;

  const _FirstAidHeader({
    required this.isDark,
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppConstants.horizontalPadding,
        MediaQuery.of(context).padding.top + 16,
        AppConstants.horizontalPadding,
        AppConstants.spaceXL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppColors.mintGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.medical_services_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'First Aid',
                    style: AppTextStyles.displaySmall.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Emergency care guides',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ],
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),
          const SizedBox(height: AppConstants.spaceXL),
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? AppColors.neuDarkMode.withOpacity(0.8)
                      : AppColors.neuDark.withOpacity(0.3),
                  offset: const Offset(4, 4),
                  blurRadius: 14,
                ),
                BoxShadow(
                  color: isDark
                      ? AppColors.neuLightDarkMode.withOpacity(0.3)
                      : AppColors.neuLight,
                  offset: const Offset(-4, -4),
                  blurRadius: 14,
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              onChanged: onSearch,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search first aid guides...',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.deepMint,
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          searchController.clear();
                          onSearch('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
        ],
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final bool isDark;
  final List<FirstAidCategory> categories;
  const _FeaturedCard({required this.isDark, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingXL),
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                colors: [AppColors.darkCard, AppColors.darkCardElevated],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFECED), Color(0xFFFFF5E0)],
              ),
        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.neuDarkMode.withOpacity(0.8)
                : AppColors.emergencyRed.withOpacity(0.12),
            offset: const Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusBadge(
                  label: 'Must Know',
                  color: AppColors.emergencyRed,
                  icon: Icons.priority_high_rounded,
                ),
                const SizedBox(height: 10),
                Text(
                  'Know CPR?\nYou can save a life.',
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    try {
                      final cpr = categories.firstWhere((c) => c.id == 'cpr');
                      if (cpr.articles.isNotEmpty) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ArticleScreen(
                              article: cpr.articles.first,
                              categoryEmoji: cpr.emoji,
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      // Do nothing if not found
                    }
                  },
                  child: Text(
                    'Learn CPR →',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.emergencyRed,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text('❤️', style: const TextStyle(fontSize: 60)),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideY(begin: 0.1);
  }
}

class _CategoryCard extends StatelessWidget {
  final FirstAidCategory category;
  final bool isDark;
  final Duration delay;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.isDark,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppConstants.paddingXL),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusXL),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? AppColors.neuDarkMode.withOpacity(0.8)
                  : AppColors.neuDark.withOpacity(0.35),
              offset: const Offset(6, 6),
              blurRadius: 18,
            ),
            BoxShadow(
              color: isDark
                  ? AppColors.neuLightDarkMode.withOpacity(0.3)
                  : AppColors.neuLight,
              offset: const Offset(-6, -6),
              blurRadius: 18,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.emoji,
              style: const TextStyle(fontSize: 40),
            ),
            const Spacer(),
            Text(
              category.title,
              style: AppTextStyles.headlineMedium.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              category.subtitle,
              style: AppTextStyles.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.mintGreen.withOpacity(isDark ? 0.2 : 1.0),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${category.articles.length} guide${category.articles.length > 1 ? 's' : ''}',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.deepMint,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: delay, duration: 400.ms)
        .slideY(begin: 0.15, end: 0);
  }
}

class _ArticleListSheet extends StatelessWidget {
  final FirstAidCategory category;
  const _ArticleListSheet({required this.category});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(top: 60),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardElevated : AppColors.divider,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '${category.emoji}  ${category.title}',
              style: AppTextStyles.headlineLarge.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...category.articles.map((article) => ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.mintGreen.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      article.emoji,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                title: Text(
                  article.title,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                subtitle: Text(article.duration, style: AppTextStyles.bodySmall),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.deepMint,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ArticleScreen(
                        article: article,
                        categoryEmoji: category.emoji,
                      ),
                    ),
                  );
                },
              )),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
