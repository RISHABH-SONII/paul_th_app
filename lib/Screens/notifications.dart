import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/PostInformation.dart';
import 'package:tharkyApp/main.dart';
import 'package:tharkyApp/models/NotificationModel.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/utils/colors.dart';

class NotificationsScreen extends StatefulWidget {
  final User currentUser;

  const NotificationsScreen({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;
    setState(() => _isLoadingMore = true);
    appController.getNotifications();
    setState(() => _isLoadingMore = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: blackColor,
        appBar: AppBar(
          title: Text(
            el.tr('notifications'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: blackColor,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: appController.notifications.isEmpty
              ? _buildEmptyState()
              : _buildNotificationsList(),
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 60,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            el.tr("You don't have any notification !"),
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return RefreshIndicator(
      onRefresh: () async {
        appController.notifications.clear();
        appController.getNotifications();
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 16),
        itemCount:
            appController.notifications.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= appController.notifications.length) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildNotificationItem(appController.notifications[index]);
        },
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    final isMeetingNotification = notification.meeting != null;
    final isUnread = !notification.isRead;

    return Dismissible(
      key: Key(notification.id),
      background: Container(color: Colors.red),
      secondaryBackground: Container(color: Colors.green),
      onDismissed: (direction) {
        // Handle dismiss actions
      },
      child: InkWell(
        onTap: () async {
          if (isUnread) {
            var req = {
              'isRead': true,
              "notifficationId": notification.id,
            };
            markNotifAsRead(req);
          }
          final index = appController.notifications
              .indexWhere((n) => n.id == notification.id);
          if (index != -1) {
            appController.notifications[index] =
                notification.copyWith(isRead: true);
          }

          if (notification.type == NotificationType.like) {
            Get.to(() => PostInformation(
                play: true,
                isVideo: notification.data['resourceType'] == "video" ?? false,
                mediaId: notification.data['resourceId']));
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNotificationIcon(notification),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isUnread ? primaryColor : Colors.grey[800],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification.body,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatDate(notification.createdAt),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
              if (isMeetingNotification)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: notification.meeting!.callType == "VideoCall"
                          ? Colors.blue[100]
                          : Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      notification.meeting!.callType == "VideoCall"
                          ? el.tr('video call')
                          : el.tr('audio call'),
                      style: TextStyle(
                        color: notification.meeting!.callType == "VideoCall"
                            ? Colors.blue[800]
                            : Colors.green[800],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
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

  Widget _buildNotificationIcon(NotificationModel notification) {
    switch (notification.type) {
      case NotificationType.callIncoming:
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.videocam_rounded,
            color: Colors.blue[400],
            size: 24,
          ),
        );
      case NotificationType.callMissed:
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.red[50],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.call_missed,
            color: Colors.red[400],
            size: 24,
          ),
        );
      case NotificationType.message:
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.green[50],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.message_rounded,
            color: Colors.green[400],
            size: 24,
          ),
        );
      case NotificationType.like:
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.green[50],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.thumb_up_alt_rounded,
            color: Colors.green[400],
            size: 24,
          ),
        );
      default:
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.notifications,
            color: Colors.grey[600],
            size: 24,
          ),
        );
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${el.tr('days ago')}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${el.tr('hours ago')}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${el.tr('minutes ago')}';
    } else {
      return el.tr('just now');
    }
  }
}
