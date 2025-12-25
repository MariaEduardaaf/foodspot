import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/restaurant_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/reservation_provider.dart';
import 'reservations_list_screen.dart';
import 'visits_history_screen.dart';
import '../providers/visit_provider.dart';
import '../models/restaurant.dart';
import 'restaurant_details_screen.dart';

class RestaurantListScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends ConsumerState<RestaurantListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final restaurantsAsync = ref.watch(restaurantProvider);
    final filteredRestaurants = ref.watch(filteredRestaurantsProvider);
    final selectedCuisine = ref.watch(cuisineFilterProvider);
    final availableCuisines = ref.watch(availableCuisinesProvider);
    final sortOption = ref.watch(sortOptionProvider);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    ),
                  ),
                  const Spacer(),
                  // Reservations button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReservationsListScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.calendar_today, color: Colors.tealAccent, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // History button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VisitsHistoryScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.history, color: Colors.green, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Favorites button
                  GestureDetector(
                    onTap: () => _showFavoritesBottomSheet(context, ref),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: favorites.isNotEmpty ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                          if (favorites.isNotEmpty)
                            Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${favorites.length}',
                                    style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Sort button
                  PopupMenuButton<SortOption>(
                    offset: const Offset(0, 40),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.tune, color: Colors.white, size: 20),
                    ),
                    color: Colors.grey[900],
                    onSelected: (option) {
                      ref.read(sortOptionProvider.notifier).state = option;
                    },
                    itemBuilder: (context) => [
                      _buildSortMenuItem(SortOption.rating, Icons.star, 'Best Rating', sortOption),
                      _buildSortMenuItem(SortOption.name, Icons.sort_by_alpha, 'Name A-Z', sortOption),
                      _buildSortMenuItem(SortOption.price, Icons.attach_money, 'Lowest Price', sortOption),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Find your',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const Text(
                    'favorite food',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search restaurants...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey[600]),
                            onPressed: () {
                              _searchController.clear();
                              ref.read(searchProvider.notifier).state = '';
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onChanged: (value) {
                    ref.read(searchProvider.notifier).state = value;
                    setState(() {});
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Cuisine filter chips
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildFilterChip('All', null, selectedCuisine, ref),
                  ...availableCuisines.map((cuisine) => _buildFilterChip(cuisine, cuisine, selectedCuisine, ref)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Results count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    '${filteredRestaurants.length} restaurants',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                  const Spacer(),
                  Text(
                    _getSortLabel(sortOption),
                    style: const TextStyle(color: Colors.tealAccent, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Restaurant list
            Expanded(
              child: restaurantsAsync.when(
                loading: () => _buildShimmerList(),
                error: (error, stack) => _buildErrorState(ref),
                data: (restaurants) {
                  if (filteredRestaurants.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    color: Colors.tealAccent,
                    backgroundColor: Colors.grey[900],
                    onRefresh: () async {
                      ref.refresh(restaurantProvider);
                      await ref.read(restaurantProvider.future);
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredRestaurants.length,
                      itemBuilder: (context, index) {
                        return AnimatedRestaurantCard(
                          restaurant: filteredRestaurants[index],
                          index: index,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<SortOption> _buildSortMenuItem(SortOption option, IconData icon, String label, SortOption current) {
    final isSelected = current == option;
    return PopupMenuItem(
      value: option,
      child: Row(
        children: [
          Icon(icon, color: isSelected ? Colors.tealAccent : Colors.grey, size: 20),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: isSelected ? Colors.tealAccent : Colors.white)),
          if (isSelected) ...[
            const Spacer(),
            const Icon(Icons.check, color: Colors.tealAccent, size: 18),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? value, String? selected, WidgetRef ref) {
    final isSelected = selected == value;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () => ref.read(cuisineFilterProvider.notifier).state = value,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.tealAccent : Colors.grey[900],
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isSelected ? Colors.tealAccent : Colors.transparent,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  String _getSortLabel(SortOption option) {
    switch (option) {
      case SortOption.rating:
        return 'Top Rated';
      case SortOption.name:
        return 'A-Z';
      case SortOption.price:
        return 'Cheapest';
    }
  }

  void _showFavoritesBottomSheet(BuildContext context, WidgetRef ref) {
    final favorites = ref.read(favoritesProvider);
    final allRestaurants = ref.read(restaurantProvider).maybeWhen(
      data: (list) => list,
      orElse: () => <Restaurant>[],
    );
    final favoriteRestaurants = allRestaurants.where((r) => favorites.contains(r.id)).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.favorite, color: Colors.red, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Favorites',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        '${favoriteRestaurants.length} saved places',
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (favoriteRestaurants.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.favorite_border, size: 64, color: Colors.grey[700]),
                        const SizedBox(height: 16),
                        Text(
                          'No favorites yet',
                          style: TextStyle(color: Colors.grey[400], fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the heart icon on restaurants\nyou love to save them here',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: favoriteRestaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = favoriteRestaurants[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              restaurant.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            restaurant.name,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Row(
                            children: [
                              Text(restaurant.cuisine, style: TextStyle(color: Colors.grey[500])),
                              const SizedBox(width: 8),
                              const Icon(Icons.star, color: Colors.amber, size: 14),
                              Text(' ${restaurant.rating}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RestaurantDetailsScreen(restaurant: restaurant),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[800]!,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 80, color: Colors.grey[800]),
          const SizedBox(height: 16),
          Text('No restaurants found', style: TextStyle(color: Colors.grey[400], fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Try adjusting your filters', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildErrorState(WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off, size: 80, color: Colors.grey[700]),
          const SizedBox(height: 16),
          Text('Connection error', style: TextStyle(color: Colors.grey[400], fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Please check your internet', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => ref.refresh(restaurantProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Try Again', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class AnimatedRestaurantCard extends ConsumerStatefulWidget {
  final Restaurant restaurant;
  final int index;

  const AnimatedRestaurantCard({Key? key, required this.restaurant, required this.index}) : super(key: key);

  @override
  ConsumerState<AnimatedRestaurantCard> createState() => _AnimatedRestaurantCardState();
}

class _AnimatedRestaurantCardState extends ConsumerState<AnimatedRestaurantCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: widget.index * 80), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(favoritesProvider).contains(widget.restaurant.id);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: _buildCard(context, isFavorite),
      ),
    );
  }

  Widget _buildCard(BuildContext context, bool isFavorite) {
    final restaurant = widget.restaurant;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => RestaurantDetailsScreen(restaurant: restaurant),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0.0, 0.05), end: Offset.zero)
                      .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image
              Hero(
                tag: 'restaurant-${restaurant.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    restaurant.imageUrl,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            restaurant.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (!restaurant.isOpen)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Closed',
                              style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      restaurant.cuisine,
                      style: TextStyle(color: Colors.grey[500], fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                restaurant.rating.toString(),
                                style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.tealAccent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            restaurant.priceLevelString,
                            style: const TextStyle(color: Colors.tealAccent, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Favorite button
              GestureDetector(
                onTap: () {
                  ref.read(favoritesProvider.notifier).toggleFavorite(restaurant.id);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      key: ValueKey(isFavorite),
                      color: isFavorite ? Colors.red : Colors.grey[600],
                      size: 26,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
