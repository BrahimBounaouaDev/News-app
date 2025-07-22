import 'package:flutter/material.dart';
import 'package:news_app/model/news_model.dart';

class NewsDetail extends StatelessWidget {
  final NewsModel newsModel;
  const NewsDetail({super.key, required this.newsModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              newsModel.title ?? 'No Title',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              newsModel.author ?? 'Unknown Author',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            newsModel.urlToImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      newsModel.urlToImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.error),
                      ),
                    ),
                  )
                : Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(child: Text('No Image Available')),
                  ),
            const SizedBox(height: 16),
            Text(
              newsModel.description ?? 'No description available',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              newsModel.content ?? 'No content available',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}