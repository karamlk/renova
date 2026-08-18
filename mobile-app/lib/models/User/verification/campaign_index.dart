import 'dart:convert';

class CampaignIndex {
  final String? message;
  final List<CampaignData>? data;

  CampaignIndex({this.message, this.data});

  factory CampaignIndex.fromJson(Map<String, dynamic> json) {
    return CampaignIndex(
      message: json['message'] as String?,
      data: json['data'] != null
          ? (json['data'] as List)
                .map((item) => CampaignData.fromJson(item as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'data': data?.map((item) => item.toJson()).toList()};
  }
}

class CampaignData {
  final int id;
  final int? foundationVerificationRequestId;
  final String? title;
  final String? description;
  final String? location;
  final String? targetAmount;
  final String? collectedAmount;
  final String? startsAt;
  final String? endsAt;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final List<CampaignImage>? images;

  CampaignData({
    required this.id,
    this.foundationVerificationRequestId,
    this.title,
    this.description,
    this.location,
    this.targetAmount,
    this.collectedAmount,
    this.startsAt,
    this.endsAt,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.images,
  });

  factory CampaignData.fromJson(Map<String, dynamic> json) {
    return CampaignData(
      id: json['id'],
      foundationVerificationRequestId: json['foundation_verification_request_id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      location: json['location'] as String?,
      targetAmount: json['target_amount'] as String?,
      collectedAmount: json['collected_amount'] as String?,
      startsAt: json['starts_at'] as String?,
      endsAt: json['ends_at'] as String?,
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      images: json['images'] != null
          ? (json['images'] as List)
                .map((item) => CampaignImage.fromJson(item as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foundation_verification_request_id': foundationVerificationRequestId,
      'title': title,
      'description': description,
      'location': location,
      'target_amount': targetAmount,
      'collected_amount': collectedAmount,
      'starts_at': startsAt,
      'ends_at': endsAt,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'images': images?.map((item) => item.toJson()).toList(),
    };
  }
}

class CampaignImage {
  final int? id;
  final int? donationCampaignId;
  final String? image;
  final String? createdAt;
  final String? updatedAt;
  final String? imageUrl;

  CampaignImage({
    this.id,
    this.donationCampaignId,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
  });

  factory CampaignImage.fromJson(Map<String, dynamic> json) {
    return CampaignImage(
      id: json['id'] as int?,
      donationCampaignId: json['donation_campaign_id'] as int?,
      image: json['image'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'donation_campaign_id': donationCampaignId,
      'image': image,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'image_url': imageUrl,
    };
  }
}
