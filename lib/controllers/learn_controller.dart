import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

final reduceUrl = Uri.parse(
  "https://www.nature.org/en-us/about-us/where-we-work/united-states/delaware/stories-in-delaware/delaware-eight-ways-to-reduce-waste/",
);

final recycleUrl = Uri.parse(
  "https://www.earthday.org/7-tips-to-recycle-better/",
);

class LearnController extends ChangeNotifier {
  final webController = WebViewController()
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

  Future recycle() async {
    if (!await launchUrl(recycleUrl, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $recycleUrl');
    }
  }

  Future reduce() async {
    if (!await launchUrl(reduceUrl, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $reduceUrl');
    }
  }
}
