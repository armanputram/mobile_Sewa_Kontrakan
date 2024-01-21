class BookmarkManager {
  static List<Map<String, dynamic>> bookmarkedProperties = [];

  static void addBookmark(Map<String, dynamic> property) {
    if (!bookmarkedProperties.contains(property)) {
      bookmarkedProperties.add(property);
    }
  }

  static void removeBookmark(Map<String, dynamic> property) {
    bookmarkedProperties.remove(property);
  }

  static bool isBookmarked(Map<String, dynamic> property) {
    return bookmarkedProperties.contains(property);
  }
}
