import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/visit.dart';
import '../providers/visit_provider.dart';

class VisitsHistoryScreen extends ConsumerWidget {
  const VisitsHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visits = ref.watch(visitsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Visit History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (visits.isNotEmpty)
            TextButton(
              onPressed: () => _showClearAllDialog(context, ref),
              child: const Text(
                'Clear All',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
      body: visits.isEmpty
          ? _buildEmptyState()
          : _buildVisitsList(context, ref, visits),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey[700]),
          const SizedBox(height: 16),
          Text(
            'No visits yet',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your visited restaurants will appear here',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitsList(BuildContext context, WidgetRef ref, List<Visit> visits) {
    // Group visits by month
    final groupedVisits = <String, List<Visit>>{};
    for (final visit in visits) {
      final monthYear = '${_getMonthName(visit.visitDate.month)} ${visit.visitDate.year}';
      groupedVisits.putIfAbsent(monthYear, () => []).add(visit);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedVisits.length,
      itemBuilder: (context, index) {
        final monthYear = groupedVisits.keys.elementAt(index);
        final monthVisits = groupedVisits[monthYear]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Text(
                    monthYear,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.tealAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${monthVisits.length}',
                      style: const TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...monthVisits.map((visit) => _buildVisitCard(context, ref, visit)),
          ],
        );
      },
    );
  }

  Widget _buildVisitCard(BuildContext context, WidgetRef ref, Visit visit) {
    return Dismissible(
      key: Key(visit.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        ref.read(visitsProvider.notifier).removeVisit(visit.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Visit removed'),
            backgroundColor: Colors.grey[800],
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    visit.restaurantImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.restaurant, color: Colors.grey[600]);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      visit.restaurantName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      visit.restaurantCuisine,
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          visit.timeAgo,
                          style: TextStyle(color: Colors.grey[400], fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.check, color: Colors.green, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 
                    'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }

  void _showClearAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Clear All History?',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'This will remove all your visit history. This action cannot be undone.',
            style: TextStyle(color: Colors.grey[400]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[400])),
            ),
            ElevatedButton(
              onPressed: () {
                final visits = ref.read(visitsProvider);
                for (final visit in visits) {
                  ref.read(visitsProvider.notifier).removeVisit(visit.id);
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Clear All', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
