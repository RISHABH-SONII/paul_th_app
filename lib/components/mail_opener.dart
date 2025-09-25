import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:url_launcher/url_launcher.dart';

class MailOpener {
  static Future<void> openGmailCompose({
    required String email,
    required String subject,
    required String body,
    String? attachmentPath,
  }) async {
    try {
      final List<String> attachments = [];
      if (attachmentPath != null && File(attachmentPath).existsSync()) {
        attachments.add(attachmentPath);
      }

      final MailOptions mailOptions = MailOptions(
        body: body,
        subject: subject,
        recipients: [email],
        isHTML: true,
        attachments: attachments,
      );

      await FlutterMailer.send(mailOptions);
    } catch (e) {
      debugPrint('FlutterMailer failed, falling back: $e');

      final Uri params = Uri(
        scheme: 'mailto',
        path: email,
        query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
      );
      await launchUrl(params); // from url_launcher
    }
  }

}