import 'package:intl/intl.dart';

class CustomDateFormat {
  static String? toYmd(DateTime? date) {
    if (date == null) return null;
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return formattedDate;
  }

  static String? tomdYRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return null;
    String formattedStartDate = DateFormat('dd/MMM/yyyy').format(startDate);
    String formattedEndDate = DateFormat('dd/MMM/yyyy').format(endDate);
    if (startDate == endDate) return formattedStartDate;
    return '$formattedStartDate - $formattedEndDate';
  }

  static String? todMYRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return null;
    String formattedStartDate = DateFormat('dd MMM yyyy').format(startDate);
    String formattedEndDate = DateFormat('dd MMM yyyy').format(endDate);
    if (startDate == endDate) return formattedStartDate;
    return '$formattedStartDate - $formattedEndDate';
  }

  static String? todYRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null && endDate == null) return null;
    String formattedStartDate = DateFormat(
      endDate != startDate ? 'dd' : 'dd, yyyy',
    ).format(startDate!);
    String formattedEndDate = DateFormat('dd, yyyy').format(endDate!);
    if (startDate == endDate) return formattedStartDate;
    return '$formattedStartDate - $formattedEndDate';
  }

  static String? toYmdHis(DateTime? date) {
    if (date == null) return null;
    String formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(date);
    return formattedDate;
  }

  static String? todMY(DateTime? date) {
    if (date == null) return null;
    String formattedDate = DateFormat('dd MMM yyyy').format(date);
    return formattedDate;
  }

  static String? todMMY(DateTime? date) {
    if (date == null) return null;
    String formattedDate = DateFormat('dd MMMM yyyy').format(date);
    return formattedDate;
  }

  static String? toMonth(DateTime? date) {
    if (date == null) return null;
    String formattedDate = DateFormat('MMMM').format(date);
    return formattedDate;
  }

  static String? todMYHis(DateTime? date) {
    if (date == null) return null;
    String formattedDate = DateFormat('dd MMM yyyy hh:mm:ss').format(date);
    return formattedDate;
  }

  static String? todMYHi(DateTime? date) {
    if (date == null) return null;
    String formattedDate = DateFormat('dd/MM/yyyy hh:mm').format(date);
    return formattedDate;
  }

  static String timeAgo(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return 'Baru saja';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} menit lalu';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} jam lalu';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} hari lalu';
    } else {
      return DateFormat('dd MMM yyy - hh:mm').format(date);
    }
  }

  static String timeAgodMy(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return 'Baru saja';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} menit lalu';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} jam lalu';
    } else if (diff.inDays < 4) {
      return '${diff.inDays} hari lalu';
    } else {
      return DateFormat('dd MMMM yyy').format(date);
    }
  }

  static String toHmRange(DateTime start, DateTime end) {
    final formatter = DateFormat('HH:mm');
    return '${formatter.format(start)} - ${formatter.format(end)}';
  }

  static String formatDateRange(
    DateTime start,
    DateTime end, {
    String? locale,
    bool useShortMonth = false,
  }) {
    // Pastikan urutan benar
    if (end.isBefore(start)) {
      final tmp = start;
      start = end;
      end = tmp;
    }

    // Normalisasi ke tanggal (abaikan jam)
    DateTime s = DateTime(start.year, start.month, start.day);
    DateTime e = DateTime(end.year, end.month, end.day);

    final monthPattern = useShortMonth ? 'MMM' : 'MMMM';
    final d = DateFormat('d', locale);
    final m = DateFormat(monthPattern, locale);
    final y = DateFormat('y', locale);
    final full = DateFormat('$monthPattern d, y', locale);

    // Same day
    if (s.year == e.year && s.month == e.month && s.day == e.day) {
      return full.format(s);
    }

    // Same month & year → September 19–21, 2025
    if (s.year == e.year && s.month == e.month) {
      return '${m.format(s)} ${d.format(s)}–${d.format(e)}, ${y.format(s)}';
    }

    // Same year, different month → August 28 – September 1, 2025
    if (s.year == e.year) {
      return '${m.format(s)} ${d.format(s)} – ${m.format(e)} ${d.format(e)}, ${y.format(s)}';
    }

    // Different year → December 28, 2025 – January 3, 2026
    return '${m.format(s)} ${d.format(s)}, ${y.format(s)} – ${m.format(e)} ${d.format(e)}, ${y.format(e)}';
  }
}
