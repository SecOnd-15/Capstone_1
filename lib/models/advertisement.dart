import 'package:cloud_firestore/cloud_firestore.dart';

/// ERD Entity: `advertisements`
/// Promotional content incl. promotional videos (FR 2.1.5.2.10).
class Advertisement {
  final String advertisementId;
  final String title;
  final String bodyText;
  final String? imageUrl;
  final String? videoUrl;
  final bool isActive;
  final int displayOrder;
  final DateTime? publishedAt;

  const Advertisement({
    required this.advertisementId,
    required this.title,
    required this.bodyText,
    this.imageUrl,
    this.videoUrl,
    required this.isActive,
    required this.displayOrder,
    this.publishedAt,
  });

  factory Advertisement.fromMap(Map<String, dynamic> map, String docId) {
    return Advertisement(
      advertisementId: docId,
      title: map['title'] as String,
      bodyText: map['body_text'] as String,
      imageUrl: map['image_url'] as String?,
      videoUrl: map['video_url'] as String?,
      isActive: map['is_active'] as bool,
      displayOrder: map['display_order'] as int,
      publishedAt: map['published_at'] != null
          ? (map['published_at'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body_text': bodyText,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'is_active': isActive,
      'display_order': displayOrder,
      'published_at':
          publishedAt != null ? Timestamp.fromDate(publishedAt!) : null,
    };
  }

  Advertisement copyWith({
    String? title,
    String? bodyText,
    String? imageUrl,
    String? videoUrl,
    bool? isActive,
    int? displayOrder,
    DateTime? publishedAt,
  }) {
    return Advertisement(
      advertisementId: advertisementId,
      title: title ?? this.title,
      bodyText: bodyText ?? this.bodyText,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      isActive: isActive ?? this.isActive,
      displayOrder: displayOrder ?? this.displayOrder,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;
}
