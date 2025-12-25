import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import '../providers/favorites_provider.dart';
import '../providers/review_provider.dart';
import '../providers/menu_provider.dart';
import 'menu_screen.dart';
import 'reservation_screen.dart';
import '../providers/visit_provider.dart';

class RestaurantDetailsScreen extends ConsumerWidget {
  final Restaurant restaurant;

  const RestaurantDetailsScreen({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider).contains(restaurant.id);
    final reviews = ref.watch(restaurantReviewsProvider(restaurant.id));
    final averageRating = ref.watch(restaurantAverageRatingProvider(restaurant.id));
    final hasVisited = ref.watch(hasVisitedProvider(restaurant.id));

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              // Mark as visited button
              IconButton(
                onPressed: () {
                  if (!hasVisited) {
                    ref.read(visitsProvider.notifier).addVisit(
                      restaurantId: restaurant.id,
                      restaurantName: restaurant.name,
                      restaurantCuisine: restaurant.cuisine,
                      restaurantImageUrl: restaurant.imageUrl,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Marked as visited!'),
                        backgroundColor: Colors.green[400],
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  }
                },
                icon: Icon(
                  hasVisited ? Icons.check_circle : Icons.check_circle_outline,
                  color: hasVisited ? Colors.green : Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  ref.read(favoritesProvider.notifier).toggleFavorite(restaurant.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite ? 'Removed from favorites' : 'Added to favorites',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.grey[800],
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey(isFavorite),
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'restaurant-${restaurant.id}',
                child: Image.asset(
                  restaurant.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.restaurant, size: 80, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                      ),
                      _buildStatusBadge(),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant.isOpen ? restaurant.closingInfo : restaurant.openingInfo,
                    style: TextStyle(
                      fontSize: 14,
                      color: restaurant.isOpen ? Colors.green[300] : Colors.orange[300],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        restaurant.cuisine,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[400],
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        restaurant.priceLevelString,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.tealAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildRatingStars(restaurant.rating),
                      const SizedBox(width: 4),
                      Text(
                        restaurant.rating.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (restaurant.description.isNotEmpty) ...[
                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      restaurant.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[300],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  _buildOpeningHoursSection(context),
                  const SizedBox(height: 24),
                  
                  _buildInfoCard(
                    icon: Icons.location_on,
                    title: 'Address',
                    subtitle: restaurant.address,
                    onTap: () => _openMaps(),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.phone,
                    title: 'Phone',
                    subtitle: restaurant.phone,
                    onTap: () => _makePhoneCall(),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _makePhoneCall(),
                          icon: const Icon(Icons.phone, color: Colors.black),
                          label: const Text(
                            'Call',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.tealAccent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _openMaps(),
                          icon: const Icon(Icons.directions, color: Colors.tealAccent),
                          label: const Text(
                            'Directions',
                            style: TextStyle(
                              color: Colors.tealAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.tealAccent),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // View Menu Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MenuScreen(
                              restaurantId: restaurant.id,
                              restaurantName: restaurant.name,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.restaurant_menu, color: Colors.black),
                      label: const Text(
                        'View Menu',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Reserve Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReservationScreen(
                              restaurant: restaurant,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.calendar_today, color: Colors.tealAccent),
                      label: const Text(
                        'Make a Reservation',
                        style: TextStyle(
                          color: Colors.tealAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.tealAccent, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),


                  
                  _buildReviewsSection(context, ref, reviews, averageRating),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddReviewModal(context, ref),
        backgroundColor: Colors.tealAccent,
        icon: const Icon(Icons.rate_review, color: Colors.black),
        label: const Text(
          'Write Review',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildOpeningHoursSection(BuildContext context) {
    final days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final todayIndex = DateTime.now().weekday - 1;
    final tomorrowIndex = (todayIndex + 1) % 7;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Opening Hours',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
            TextButton.icon(
              onPressed: () => _showFullSchedule(context, days, dayNames, todayIndex),
              icon: const Icon(Icons.schedule, color: Colors.tealAccent, size: 18),
              label: const Text(
                'See all',
                style: TextStyle(color: Colors.tealAccent),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildHoursRow(
                dayNames[todayIndex],
                restaurant.hours[days[todayIndex]],
                isToday: true,
              ),
              const Divider(color: Colors.grey, height: 24),
              _buildHoursRow(
                dayNames[tomorrowIndex],
                restaurant.hours[days[tomorrowIndex]],
                isToday: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHoursRow(String day, OpeningHours? hours, {required bool isToday}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (isToday)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.tealAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'TODAY',
                  style: TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Text(
              day,
              style: TextStyle(
                color: isToday ? Colors.white : Colors.grey[400],
                fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
        Text(
          hours != null ? '${hours.open} - ${hours.close}' : 'Closed',
          style: TextStyle(
            color: hours != null 
                ? (isToday ? Colors.white : Colors.grey[400])
                : Colors.red[400],
            fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  void _showFullSchedule(BuildContext context, List<String> days, List<String> dayNames, int todayIndex) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A1A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Opening Hours',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(7, (index) {
                final isToday = index == todayIndex;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: _buildHoursRow(
                    dayNames[index],
                    restaurant.hours[days[index]],
                    isToday: isToday,
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewsSection(BuildContext context, WidgetRef ref, List<Review> reviews, double averageRating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Reviews',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
            if (reviews.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' (${reviews.length})',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (reviews.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: Column(
              children: [
                Icon(Icons.rate_review_outlined, size: 48, color: Colors.grey[600]),
                const SizedBox(height: 12),
                Text(
                  'No reviews yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Be the first to review!',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _buildReviewCard(reviews[index]);
            },
          ),
      ],
    );
  }

  Widget _buildReviewCard(Review review) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.tealAccent.withOpacity(0.2),
                child: Text(
                  review.userName[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.tealAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      review.timeAgo,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _buildRatingStars(review.rating, size: 14),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddReviewModal(BuildContext context, WidgetRef ref) {
    double selectedRating = 5.0;
    final commentController = TextEditingController();
    final nameController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Write a Review',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Share your experience at ${restaurant.name}',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    const SizedBox(height: 24),
                    
                    const Text(
                      'Your Rating',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedRating = index + 1.0;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              index < selectedRating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 40,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    
                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Your Name',
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.tealAccent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    TextField(
                      controller: commentController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Your Review',
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.tealAccent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (nameController.text.isEmpty || commentController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Please fill all fields'),
                                backgroundColor: Colors.red[400],
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                            return;
                          }
                          
                          ref.read(reviewsProvider.notifier).addReview(
                            restaurantId: restaurant.id,
                            userName: nameController.text,
                            rating: selectedRating,
                            comment: commentController.text,
                          );
                          
                          Navigator.pop(context);
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Review submitted successfully!'),
                              backgroundColor: Colors.green[400],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Submit Review',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: restaurant.isOpen ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: restaurant.isOpen ? Colors.green : Colors.red,
        ),
      ),
      child: Text(
        restaurant.isOpen ? 'Open' : 'Closed',
        style: TextStyle(
          color: restaurant.isOpen ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildRatingStars(double rating, {double size = 18}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, color: Colors.amber, size: size);
        } else if (index < rating) {
          return Icon(Icons.star_half, color: Colors.amber, size: size);
        } else {
          return Icon(Icons.star_border, color: Colors.amber, size: size);
        }
      }),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.tealAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.tealAccent),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _makePhoneCall() async {
    final Uri url = Uri.parse('tel:${restaurant.phone}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _openMaps() async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(restaurant.address)}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
