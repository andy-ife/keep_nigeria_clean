import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keep_nigeria_clean/theme/colors.dart';
import 'package:keep_nigeria_clean/widgets/icon_and_label.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constraints = MediaQuery.of(context);

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.youtube.com/embed/1nicf4RjU00'));

    return Scaffold(
      appBar: AppBar(
        title: Text('Learn'),
        bottom: PreferredSize(
          preferredSize: Size(constraints.size.width, 56.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SearchBar(
              backgroundColor: WidgetStateProperty.all(AppColors.white),
              leading: Icon(Icons.search_outlined),
              hintText: 'Search articles, guides, videos...',
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            SizedBox(),
            Text(
              'Educational Categories',
              style: theme.textTheme.headlineSmall,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _EducationCard(
                  icon: SvgPicture.asset('assets/recycle.svg', width: 40.0),
                  title: Text(
                    'Recycling Basics',
                    style: theme.textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    'Understanding recycling processes',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  numLessons: 1,
                  stickerColor: Colors.green[100]!,
                  stickerTextColor: Colors.green[700]!,
                ),
                _EducationCard(
                  icon: SvgPicture.asset('assets/graph.svg', width: 40.0),
                  title: Text(
                    'Waste Reduction',
                    style: theme.textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    'Strategies to minimize waste and littering',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  numLessons: 1,
                  stickerColor: Colors.purple[100]!,
                  stickerTextColor: Colors.purple[700]!,
                ),
              ],
            ),
            SizedBox(),
            Text('Featured Video', style: theme.textTheme.headlineSmall),
            Container(
              height: constraints.size.height * 0.40,
              width: constraints.size.width - 32.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: WebViewWidget(controller: controller),
            ),
            SizedBox(),
            Text('Trending Articles', style: theme.textTheme.headlineSmall),
            _NewsCard(
              title: 'New Recycling Facility Opens in Lagos',
              subtitle:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris fermentum sodales leo, ut porta ante eleifend nec. Donec eget consequat est. Vestibulum id tristique lectus.',
              image: Image.network(
                'https://picsum.photos/seed/factory/200',
                scale: 1.0,
              ),
              tag: 'recycling',
              source: 'The Guardian',
              numMinutes: '5',
              views: '10k',
            ),
            _NewsCard(
              title: 'New Recycling Facility Opens in Lagos',
              subtitle:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris fermentum sodales leo, ut porta ante eleifend nec. Donec eget consequat est. Vestibulum id tristique lectus.',
              image: Image.network(
                'https://picsum.photos/seed/factory/200',
                scale: 1.0,
              ),
              tag: 'recycling',
              source: 'The Guardian',
              numMinutes: '5',
              views: '10k',
            ),
          ],
        ),
      ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  const _EducationCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.numLessons,
    required this.stickerColor,
    required this.stickerTextColor,
    super.key,
  });

  final Widget icon;
  final Widget title;
  final Widget subtitle;
  final int numLessons;
  final Color stickerColor;
  final Color stickerTextColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constraints = MediaQuery.of(context);

    final lessons = numLessons > 1 ? 'lessons' : 'lesson';
    return SizedBox(
      width: constraints.size.width * 0.44,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.0,
            children: [
              icon,
              title,
              subtitle,
              Container(
                decoration: BoxDecoration(
                  color: stickerColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$numLessons $lessons',
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: stickerTextColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.tag,
    required this.source,
    required this.numMinutes,
    required this.views,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget image;
  final String tag;
  final String source;
  final String numMinutes;
  final String views;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        horizontalTitleGap: 4.0,
        title: Text(title, overflow: TextOverflow.ellipsis, maxLines: 2),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Text(subtitle, overflow: TextOverflow.ellipsis, maxLines: 2),
            SizedBox(height: 24.0),
            Text(source),
            IconAndLabel(
              icon: Icon(Icons.timer_outlined, size: 16.0),
              label: Text('$numMinutes min read'),
            ),
          ],
        ),
        trailing: image,
        isThreeLine: true,
      ),
    );
  }
}
