import 'package:flutter/material.dart';
import '../models/notice_model.dart';
import '../api_service.dart'; // ✅ Fixed import path

class NoticeProvider extends ChangeNotifier {
  // Private variables
  List<Notice> _notices = [];
  List<Notice> _filteredNotices = [];
  bool _loading = false;
  String _error = '';
  String _selectedCategory = 'All';
  String _searchQuery = '';

  // Getters
  List<Notice> get notices {
    return _filteredNotices.isNotEmpty ? _filteredNotices : _notices;
  }

  List<Notice> get allNotices => _notices;
  bool get loading => _loading;
  String get error => _error;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  // Get unique categories
  List<String> get categories {
    final Set<String> categorySet = {'All'};
    for (var notice in _notices) {
      categorySet.add(notice.category);
    }
    return categorySet.toList();
  }

  // Get urgent notices
  List<Notice> get urgentNotices {
    return _notices.where((notice) => notice.isUrgent).toList();
  }

  // Get notices by priority
  List<Notice> get highPriorityNotices {
    return _notices.where((notice) => notice.priority == 'high').toList();
  }

  // Get latest notices (last 7 days)
  List<Notice> get recentNotices {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return _notices
        .where((notice) => notice.createdAt.isAfter(sevenDaysAgo))
        .toList();
  }

  // FETCH - Get all notices
  Future<void> fetchNotices() async {
    _loading = true;
    _error = '';
    notifyListeners();

    try {
      _notices = await ApiService.getNotices();
      _applyFilters();
    } catch (e) {
      _error = e.toString();
      _notices = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ADD - Create new notice
  Future<bool> addNotice({
    required String title,
    required String content,
    String category = 'General',
    String priority = 'normal',
    bool isUrgent = false,
    String? imageUrl,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      final notice = Notice(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        content: content,
        category: category,
        priority: priority,
        createdAt: DateTime.now(),
        isUrgent: isUrgent,
        imageUrl: imageUrl,
      );

      await ApiService.createNotice(notice);

      _notices.insert(0, notice);
      _applyFilters();
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // DELETE - Remove notice
  Future<bool> deleteNotice(int id) async {
    _loading = true;
    notifyListeners();

    try {
      await ApiService.deleteNotice(id);

      _notices.removeWhere((notice) => notice.id == id);
      _applyFilters();
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // FILTER - By category
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  // SEARCH - By query
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  // Clear all filters
  void clearFilters() {
    _selectedCategory = 'All';
    _searchQuery = '';
    _filteredNotices = [];
    notifyListeners();
  }

  // Apply all filters
  void _applyFilters() {
    var filtered = List<Notice>.from(_notices);

    if (_selectedCategory != 'All') {
      filtered =
          filtered.where((n) => n.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered
          .where((n) =>
              n.title.toLowerCase().contains(query) ||
              n.content.toLowerCase().contains(query) ||
              n.category.toLowerCase().contains(query))
          .toList();
    }

    _filteredNotices = filtered;
    notifyListeners();
  }

  // Sort notices (newest first)
  void sortNewestFirst() {
    _notices.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _applyFilters();
    notifyListeners();
  }

  // Get notice by ID
  Notice? getNoticeById(int id) {
    try {
      return _notices.firstWhere((n) => n.id == id);
    } catch (e) {
      return null;
    }
  }

  // Clear error
  void clearError() {
    _error = '';
    notifyListeners();
  }

  // Refresh with pull-to-refresh
  Future<void> refreshNotices() async {
    await fetchNotices();
  }

  // Get count by category
  int getCountByCategory(String category) {
    if (category == 'All') return _notices.length;
    return _notices.where((n) => n.category == category).length;
  }

  // Get unread count
  int get unreadCount {
    final twentyFourHoursAgo =
        DateTime.now().subtract(const Duration(hours: 24));
    return _notices
        .where((n) => n.createdAt.isAfter(twentyFourHoursAgo))
        .length;
  }
}
