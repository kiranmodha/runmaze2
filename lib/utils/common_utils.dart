import 'package:intl/intl.dart';

class CommonUtils {
  static String getStringDateDMY(String dateYMD) {
    final dateTime = DateFormat("yyyy-MM-dd").parse(dateYMD);
    final formattedDate = DateFormat("dd/MM/yyyy").format(dateTime);
    return formattedDate;
  }

  static String titleCase(String text) {
    if (text.isEmpty) {
      return text;
    }

    final words = text.split(" ");
    final capitalizedWords = words.map((word) {
      if (word.isNotEmpty) {
        final firstLetter = word[0].toUpperCase();
        final remainingLetters = word.substring(1).toLowerCase();
        return '$firstLetter$remainingLetters';
      }
      return word;
    }).toList();

    return capitalizedWords.join(" ");
  }

  static DateTime? convertToDate(String dateTimeYMDHM) {
    try {
      final parsedDateTime =
          DateFormat("yyyy-MM-dd HH:mm").parse(dateTimeYMDHM, true);
      return parsedDateTime;
    } catch (e) {
      print("Error parsing date: $e");
      return null;
    }
  }
}
