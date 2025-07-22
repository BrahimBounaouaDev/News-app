
class CategoryModel {
  final String? categoryName;

  CategoryModel({
    this.categoryName,
  });
}

class NewsModel {
  final String? title;
  final String? description;
  final String? urlToImage;
  final String? author;
  final String? content;

  NewsModel({
    this.title,
    this.description,
    this.urlToImage,
    this.author,
    this.content,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      urlToImage: json['urlToImage'],
      author: json['author'] ?? 'Unknown Author',
      content: json['content'] ?? 'No Content Available',
    );
  }
}