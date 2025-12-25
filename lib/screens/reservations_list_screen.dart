import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reservation.dart';
import '../providers/reservation_provider.dart';

class ReservationsListScreen extends ConsumerWidget {
  const ReservationsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservations = ref.watch(reservationsProvider);
    final upcoming = reservations.where((r) => r.isUpcoming).toList();
    final past = reservations.where((r) => !r.isUpcoming).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'My Reservations',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            indicatorColor: Colors.tealAccent,
            labelColor: Colors.tealAccent,
            unselectedLabelColor: Colors.grey[500],
            tabs: [
              Tab(text: 'Upcoming (${upcoming.length})'),
              Tab(text: 'Past (${past.length})'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildReservationsList(upcoming, ref, isUpcoming: true),
            _buildReservationsList(past, ref, isUpcoming: false),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationsList(List<Reservation> reservations, WidgetRef ref, {required bool isUpcoming}) {
    if (reservations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUpcoming ? Icons.calendar_today : Icons.history,
              size: 64,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 16),
            Text(
              isUpcoming ? 'No upcoming reservations' : 'No past reservations',
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
            if (isUpcoming) ...[
              const SizedBox(height: 8),
              Text(
                'Book a table at your favorite restaurant!',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final reservation = reservations[index];
        return _buildReservationCard(context, reservation, ref, isUpcoming);
      },
    );
  }

  Widget _buildReservationCard(BuildContext context, Reservation reservation, WidgetRef ref, bool isUpcoming) {
    Color statusColor;
    switch (reservation.status) {
      case ReservationStatus.confirmed:
        statusColor = Colors.green;
        break;
      case ReservationStatus.pending:
        statusColor = Colors.orange;
        break;
      case ReservationStatus.cancelled:
        statusColor = Colors.red;
        break;
      case ReservationStatus.completed:
        statusColor = Colors.blue;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        reservation.restaurantName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        reservation.statusString,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoChip(Icons.calendar_today, reservation.formattedDate),
                    const SizedBox(width: 12),
                    _buildInfoChip(Icons.access_time, reservation.time),
                    const SizedBox(width: 12),
                    _buildInfoChip(Icons.people, '${reservation.partySize} guests'),
                  ],
                ),
                if (reservation.specialRequests != null && reservation.specialRequests!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.note, size: 16, color: Colors.grey[500]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          reservation.specialRequests!,
                          style: TextStyle(color: Colors.grey[400], fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (isUpcoming && reservation.status != ReservationStatus.cancelled)
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[800]!)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _showCancelDialog(context, ref, reservation),
                      icon: const Icon(Icons.close, color: Colors.red, size: 18),
                      label: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  Container(width: 1, height: 40, color: Colors.grey[800]),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        // Could add modify functionality here
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Call the restaurant to modify'),
                            backgroundColor: Colors.grey[800],
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit, color: Colors.tealAccent, size: 18),
                      label: const Text(
                        'Modify',
                        style: TextStyle(color: Colors.tealAccent),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.tealAccent),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref, Reservation reservation) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Cancel Reservation?',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to cancel your reservation at ${reservation.restaurantName}?',
            style: TextStyle(color: Colors.grey[400]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Keep it', style: TextStyle(color: Colors.grey[400])),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(reservationsProvider.notifier).cancelReservation(reservation.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Reservation cancelled'),
                    backgroundColor: Colors.red[400],
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
