import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:webview_flutter/webview_flutter.dart';

import 'package:tk8/config/styles.config.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/ui/widgets/widgets.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebViewScreen({
    Key key,
    @required this.url,
    this.title,
  })  : assert(url != null && url != ''),
        super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
        leading: MaterialButton(
          onPressed: getIt<NavigationService>().pop,
          padding: EdgeInsets.zero,
          child: Text(
            translate('screens.webview.actions.done.title'),
            style: const TextStyle(color: TK8Colors.ocean),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget.url,
              onWebViewCreated: (controller) {
                setState(() => _controller = controller);
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                color: Color(0x260c2246),
                blurRadius: 15,
              )
            ], color: Colors.white),
            child: SafeArea(
              child: Row(
                children: [
                  _buildActionBarButton(
                    const Icon(Icons.open_in_browser),
                    () {
                      url_launcher.launch(
                        widget.url,
                        forceSafariVC: false,
                      );
                    },
                  ),
                  const Spacer(),
                  _buildActionBarButton(
                    const Icon(Icons.refresh, size: 30),
                    _controller?.reload,
                  ),
                  const Space.horizontal(10),
                  _buildActionBarButton(
                    const Icon(Icons.arrow_back_ios),
                    _controller?.goBack,
                  ),
                  _buildActionBarButton(
                    const Icon(Icons.arrow_forward_ios),
                    _controller?.goForward,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActionBarButton(Widget icon, VoidCallback onPress) {
    return IconButton(
      icon: icon,
      color: TK8Colors.ocean,
      onPressed: onPress,
    );
  }
}
