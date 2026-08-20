import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notice_model.dart'; // ✅ Go up one level to lib/, then into models/

class ApiService {
  static const String baseUrl = 'http://localhost/smart_campus_api';

  // GET - Fetch all notices
  static Future<List<Notice>> getNotices() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/notices.php'),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Notice.fromJson(json)).toList();
      }

      return _getMockNotices();
    } catch (e) {
      return _getMockNotices();
    }
  }

  // POST - Create new notice
  static Future<void> createNotice(Notice notice) async {
    try {
      await http
          .post(
            Uri.parse('$baseUrl/notices.php'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(notice.toJson()),
          )
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      // Silent fail in development
    }
  }

  // DELETE - Remove notice
  static Future<void> deleteNotice(int id) async {
    try {
      await http
          .delete(
            Uri.parse('$baseUrl/notices.php?id=$id'),
          )
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      // Silent fail in development
    }
  }

  // MOCK DATA - Used when backend is not ready
  static List<Notice> _getMockNotices() {
    return [
      Notice(
        id: 1,
        title: '🎉 Welcome to Smart Campus',
        content:
            'This is your campus notice board. Connect to backend for real data.',
        category: 'General',
        priority: 'normal',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        isUrgent: false,
      ),
      Notice(
        id: 2,
        title: '📚 Exam Schedule 2024',
        content:
            'Final exams will start from December 15, 2024. Check timetable.',
        category: 'Academic',
        priority: 'high',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isUrgent: true,
      ),
      Notice(
        id: 3,
        title: '🏆 Sports Day Announcement',
        content:
            'Annual sports day on January 20, 2024. Register by January 10.',
        category: 'Sports',
        priority: 'medium',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isUrgent: false,
      ),
      Notice(
        id: 4,
        title: '💻 Hackathon 2024',
        content: 'Join the biggest hackathon. Prizes worth \$5000!',
        category: 'Event',
        priority: 'high',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isUrgent: true,
      ),
      Notice(
        id: 5,
        title: '📢 Campus Cleanliness Drive',
        content:
            'Please maintain cleanliness on campus. Waste segregation is mandatory.',
        category: 'Administrative',
        priority: 'low',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        isUrgent: false,
      ),
    ];
  }
}
