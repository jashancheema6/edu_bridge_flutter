import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../providers/notification_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<NotificationProvider>();
    var notifications = provider.notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          if (notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: "Clear All",
              onPressed: () async {
                await provider.clearAll();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("All notifications cleared")),
                );
              },
            )
        ],
      ),
      body: notifications.isEmpty
          ? Center(
        child: Text(
          "No notifications yet.",
          style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];

          // Convert Firestore Timestamp to DateTime safely
          DateTime? time;
          if (item["time"] != null && item["time"] is DateTime) {
            time = item["time"] as DateTime;
          }

          return Dismissible(
            key: Key(item["id"] ?? index.toString()),
            background: Container(
              padding: const EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.red.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.startToEnd,
            onDismissed: (_) async {
              if (item["id"] != null) {
                await provider.removeNotification(item["id"]);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Notification deleted")),
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---- Category Badge ----
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _getBadgeColor(item["type"]),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getTypeIcon(item["type"]),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 14),
                  // ---- Notification Text ----
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["title"] ?? "",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item["message"] ?? "",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          time != null
                              ? timeago.format(time)
                              : "",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Category color
  Color _getBadgeColor(String? type) {
    switch (type) {
      case "assignment":
        return Colors.green.shade400;
      case "notes":
        return Colors.blue.shade400;
      case "announcement":
        return Colors.orange.shade400;
      default:
        return Colors.grey;
    }
  }

  // Category icon
  IconData _getTypeIcon(String? type) {
    switch (type) {
      case "assignment":
        return Icons.assignment;
      case "notes":
        return Icons.note;
      case "announcement":
        return Icons.campaign;
      default:
        return Icons.notifications;
    }
  }
}
