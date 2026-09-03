import 'package:flutter/material.dart';

class SchemeModel {
  final String title;
  final String description;
  final String amount;
  final String state;
  final String category;
  final bool popular;
  final IconData icon;
  final String eligibility;
  final String documents;
  final String officialWebsite;
  final String helpline;

  SchemeModel({
    required this.title,
    required this.description,
    required this.amount,
    required this.state,
    required this.category,
    required this.popular,
    required this.icon,
    required this.eligibility,
    required this.documents,
    required this.officialWebsite,
    required this.helpline,
  });

  factory SchemeModel.fromJson(Map<String, dynamic> json) {
    return SchemeModel(
      title: json['title'] as String,
      description: json['description'] as String,
      amount: json['amount'] as String,
      state: json['state'] as String,
      category: json['category'] as String,
      popular: json['popular'] as bool? ?? false,
      icon: iconFromString(json['icon'] as String? ?? 'work'),
      eligibility: json['eligibility'] as String? ?? '',
      documents: json['documents'] as String? ?? '',
      officialWebsite: json['officialWebsite'] as String? ?? '',
      helpline: json['helpline'] as String? ?? '',
    );
  }

  static IconData iconFromString(String name) {
    switch (name) {
      case 'agriculture':
        return Icons.agriculture;
      case 'shield':
        return Icons.shield;
      case 'woman':
        return Icons.woman;
      case 'school':
        return Icons.school;
      case 'work':
        return Icons.work;
      case 'elderly':
        return Icons.elderly;
      case 'home':
        return Icons.home;
      case 'health':
        return Icons.local_hospital;
      case 'business':
        return Icons.business_center;
      case 'disability':
        return Icons.accessible;
      case 'minority':
        return Icons.groups;
      case 'caste':
        return Icons.diversity_3;
      default:
        return Icons.account_balance;
    }
  }

  bool matchesState(String selectedState) {
    return state == 'सभी' || state == selectedState;
  }
}
