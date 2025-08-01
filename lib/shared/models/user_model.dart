class WeeklyLoginStats {
  final String weekStart;
  final String weekEnd;
  final int totalLoginsThisWeek;
  final Map<String, DayStats> days;

  WeeklyLoginStats({
    required this.weekStart,
    required this.weekEnd,
    required this.totalLoginsThisWeek,
    required this.days,
  });

  factory WeeklyLoginStats.fromJson(Map<String, dynamic> json) {
    final daysMap = <String, DayStats>{};
    final daysJson = json['days'] as Map<String, dynamic>;
    
    daysJson.forEach((key, value) {
      daysMap[key] = DayStats.fromJson(value);
    });

    return WeeklyLoginStats(
      weekStart: json['week_start'] ?? '',
      weekEnd: json['week_end'] ?? '',
      totalLoginsThisWeek: json['total_logins_this_week'] ?? 0,
      days: daysMap,
    );
  }

  Map<String, dynamic> toJson() {
    final daysJson = <String, dynamic>{};
    days.forEach((key, value) {
      daysJson[key] = value.toJson();
    });

    return {
      'week_start': weekStart,
      'week_end': weekEnd,
      'total_logins_this_week': totalLoginsThisWeek,
      'days': daysJson,
    };
  }
}

class DayStats {
  final String date;
  final bool loggedIn;
  final int dayNumber;

  DayStats({
    required this.date,
    required this.loggedIn,
    required this.dayNumber,
  });

  factory DayStats.fromJson(Map<String, dynamic> json) {
    return DayStats(
      date: json['date'] ?? '',
      loggedIn: json['logged_in'] ?? false,
      dayNumber: json['day_number'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'logged_in': loggedIn,
      'day_number': dayNumber,
    };
  }
}

class CheckIn {
  final int id;
  final String checkInDate;
  final String checkInChoice;
  final String description;

  CheckIn({
    required this.id,
    required this.checkInDate,
    required this.checkInChoice,
    required this.description,
  });

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return CheckIn(
      id: json['id'] ?? 0,
      checkInDate: json['check_in_date'] ?? '',
      checkInChoice: json['check_in_choice'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'check_in_date': checkInDate,
      'check_in_choice': checkInChoice,
      'description': description,
    };
  }
}

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? avatar;
  final DateTime createdAt;
  final bool isActive;
  final WeeklyLoginStats? weeklyLoginStats;
  final List<CheckIn> checkIns;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.avatar,
    required this.createdAt,
    this.isActive = true,
    this.weeklyLoginStats,
    this.checkIns = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Parse weekly login stats
    WeeklyLoginStats? weeklyStats;
    if (json['weekly_login_stats'] != null) {
      weeklyStats = WeeklyLoginStats.fromJson(json['weekly_login_stats']);
    }

    // Parse check-ins
    List<CheckIn> checkInsList = [];
    if (json['check_in'] != null) {
      final checkInsJson = json['check_in'] as List;
      checkInsList = checkInsJson.map((item) => CheckIn.fromJson(item)).toList();
    }

    return UserModel(
      id: json['id']?.toString() ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      avatar: json['avatar'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      isActive: json['is_active'] ?? true,
      weeklyLoginStats: weeklyStats,
      checkIns: checkInsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'created_at': createdAt.toIso8601String(),
      'is_active': isActive,
      'weekly_login_stats': weeklyLoginStats?.toJson(),
      'check_in': checkIns.map((checkIn) => checkIn.toJson()).toList(),
    };
  }

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? avatar,
    DateTime? createdAt,
    bool? isActive,
    WeeklyLoginStats? weeklyLoginStats,
    List<CheckIn>? checkIns,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      weeklyLoginStats: weeklyLoginStats ?? this.weeklyLoginStats,
      checkIns: checkIns ?? this.checkIns,
    );
  }
} 