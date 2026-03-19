import 'package:flutter/material.dart';

class FetchBook {
  final dynamic data;
  final bool isLoading;
  final Exception? error;
  final VoidCallback? refetch;

  FetchBook({
    required this.data,
    required this.isLoading,
    required this.error,
    required this.refetch
  });
}