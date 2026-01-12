import 'package:flutter/material.dart';
import 'package:imdumb/core/app/app_url.dart';
import 'package:imdumb/domain/models/entities/movie.dart';
import 'package:imdumb/presentation/providers/detail_providers.dart';
import 'package:imdumb_dependencies/imdumb_dependencies.dart';

class DetailScreen extends ConsumerWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We fetch full detail (runtime, etc) and credits
    // Initial data is from list, but we refresh/expand with detail provider
    final fullDetailAsync = ref.watch(movieDetailProvider(movie.id));
    final creditsAsync = ref.watch(movieCreditsProvider(movie.id));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCarousel(fullDetailAsync.value ?? movie),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: movie.voteAverage / 2,
                            itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                            itemCount: 5,
                            itemSize: 20.0,
                            direction: Axis.horizontal,
                          ),
                          const SizedBox(width: 8),
                          Text('${movie.voteAverage}/10'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Overview',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(movie.overview),
                      const SizedBox(height: 16),
                      Text(
                        'Cast',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildCastList(creditsAsync),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: ElevatedButton(
                onPressed: () => _showRecommendModal(context, movie),
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                child: const Text('Recomendar'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel(Movie movieData) {
    final images = [movieData.backdropPath, movieData.posterPath].where((e) => e.isNotEmpty).toList();

    if (images.isEmpty) {
      return Container(height: 250, color: Colors.grey);
    }

    return FlutterCarousel(
      options: FlutterCarouselOptions(height: 250.0, showIndicator: true, slideIndicator: CircularSlideIndicator()),
      items: images.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CachedNetworkImage(imageUrl: '${AppUrl.imageBaseUrl}$i', fit: BoxFit.cover),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildCastList(AsyncValue creditsAsync) {
    return SizedBox(
      height: 100,
      child: creditsAsync.when(
        data: (castList) {
          if (castList is! List) return const SizedBox();
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: castList.length,
            itemBuilder: (context, index) {
              final actor = castList[index];
              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 8),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: (actor.profilePath as String).isNotEmpty
                          ? CachedNetworkImageProvider('${AppUrl.imageBaseUrl}${actor.profilePath}')
                          : null,
                      child: (actor.profilePath as String).isEmpty ? const Icon(Icons.person) : null,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      actor.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Text('Failed to load cast'),
      ),
    );
  }

  void _showRecommendModal(BuildContext context, Movie movie) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Recomendar ${movie.title}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              constraints: const BoxConstraints(maxHeight: 150),
              child: SingleChildScrollView(
                child: Text(movie.overview, style: const TextStyle(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(hintText: 'Escribe tu comentario...', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                showSimpleNotification(const Text("Recomendación enviada con éxito"), background: Colors.green);
              },
              child: const Text('Confirmar'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
