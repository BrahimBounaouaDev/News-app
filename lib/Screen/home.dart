import 'package:flutter/material.dart';
import 'package:news_app/Screen/category_news.dart';
import 'package:news_app/Screen/news_detail.dart';
import 'package:news_app/Services/services.dart';
import 'package:news_app/model/category_data.dart';
import 'package:news_app/model/news_model.dart';

class NewsHomeScreen extends StatefulWidget {
  @override
  _NewsHomeScreenState createState() => _NewsHomeScreenState();
}

class _NewsHomeScreenState extends State<NewsHomeScreen> {
  List<NewsModel> articles = [];
  List<CategoryModel> categories = [];
  bool isLoading = true;
  String? errorMessage;

  Future<void> getNews() async {
    try {
      final newsApi = NewsApi();
      await newsApi.getNews();
      
      if (newsApi.dataStore.isEmpty) {
        throw Exception('No articles available');
      }

      setState(() {
        articles = newsApi.dataStore;
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
    categories = getCategories();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flutter News App",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
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
              : Column(
                  children: [
                    // Categories Section
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        height: 50,
                        child: ListView.builder(
                          itemCount: categories.length,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SelectedCategoryNews(
                                        category: category.categoryName!,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  category.categoryName!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // News Articles Section
                    Expanded(
                      child: articles.isEmpty
                          ? const Center(
                              child: Text(
                                "No articles available",
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: getNews,
                              child: ListView.builder(
                                itemCount: articles.length,
                                physics: const ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final article = articles[index];
                                  return Card(
                                    margin: const EdgeInsets.all(12),
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
                                            builder: (context) =>
                                                NewsDetail(newsModel: article),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                    top: Radius.circular(12)),
                                            child: Image.network(
                                              article.urlToImage ?? '',
                                              height: 200,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Container(
                                                height: 200,
                                                color: Colors.grey[200],
                                                child: const Icon(Icons.error,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  article.title ?? 'No Title',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 8),
                                                if (article.description != null)
                                                  Text(
                                                    article.description!,
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                            ),
                    ),
                  ],
                ),
    );
  }
}