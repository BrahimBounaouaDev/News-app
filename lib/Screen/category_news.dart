import 'package:flutter/material.dart';
import 'package:news_app/Screen/news_detail.dart';
import 'package:news_app/Services/services.dart';
import 'package:news_app/model/news_model.dart';

class SelectedCategoryNews extends StatefulWidget {
  final String category;
  const SelectedCategoryNews({super.key, required this.category});

  @override
  State<SelectedCategoryNews> createState() => _SelectedCategoryNewsState();
}

class _SelectedCategoryNewsState extends State<SelectedCategoryNews> {
  List<NewsModel> articles = [];
  bool isLoading = true;
  String? errorMessage;

  Future<void> getNews() async {
    try {
      final news = CategoryNews();
      await news.getNews(widget.category);
      
      if (news.dataStore.isEmpty) {
        throw Exception('No articles found for ${widget.category}');
      }

      setState(() {
        articles = news.dataStore;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load news: ${e.toString()}';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(
          widget.category,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(errorMessage!),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: getNews,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: articles.length,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsDetail(newsModel: article),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Image.network(
                                article.urlToImage ?? '',
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  height: 180,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.error,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.title ?? 'No Title',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  if (article.description != null)
                                    Text(
                                      article.description!,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}