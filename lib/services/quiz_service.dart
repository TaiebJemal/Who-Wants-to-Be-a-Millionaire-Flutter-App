class QuizService {
  static String finalQuizUrl = ''; // Shared final URL
  static const String _baseUrl = 'https://opentdb.com/api.php?';

  static String buildApiUrl({
    required int amount,
    int? category,
    String? difficulty,
  }) {
    final buffer = StringBuffer('${_baseUrl}amount=$amount');

    if (category != null) buffer.write('&category=$category');
    if (difficulty != null) buffer.write('&difficulty=$difficulty');

    return buffer.toString();
  }

  static final Map<String, int> categories = {
    'Any Category': 8,
    'General Knowledge': 9,
    'Entertainment: Books': 10,
    'Entertainment: Film': 11,
    'Entertainment: Music': 12,
    'Entertainment: Musicals & Theatres': 13,
    'Entertainment: Television': 14,
    'Entertainment: Video Games': 15,
    'Entertainment: Board Games': 16,
    'Science & Nature': 17,
    'Science: Computers': 18,
    'Science: Mathematics': 19,
    'Mythology': 20,
    'Sports': 21,
    'Geography': 22,
    'History': 23,
    'Politics': 24,
    'Art': 25,
    'Celebrities': 26,
    'Animals': 27,
    'Vehicles': 28,
    'Entertainment: Comics': 29,
    'Science: Gadgets': 30,
    'Entertainment: Japanese Anime & Manga': 31,
    'Entertainment: Cartoon & Animations': 32,
  };
}
