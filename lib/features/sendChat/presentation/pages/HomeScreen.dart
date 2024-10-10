import 'package:chat_bot_frontend/features/sendChat/presentation/pages/SendMessage.dart';
import 'package:chat_bot_frontend/features/sendChat/presentation/pages/video/videoApp.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {});
  }

  int topIndex = 0; // Controla el índice del elemento seleccionado
  PaneDisplayMode displayMode = PaneDisplayMode.auto;

  List<NavigationPaneItem> items = [
    PaneItem(
      icon: const Icon(FluentIcons.home),
      title: const Text('Home'),
      body: VideoApp(),
    ),
    PaneItemSeparator(),
    PaneItemExpander(
      icon: const Icon(FluentIcons.issue_tracking),
      title: const Text(
        'Mensajes',
        overflow: TextOverflow.ellipsis,
      ),
      body: SendMessage(),
      items: [],
    ),
    /*  */
    PaneItem(
      icon: const Icon(FluentIcons.disable_updates),
      title: const Text('Reportes'),
      body: Container(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
          automaticallyImplyLeading: false,
          actions: IconButton(
              onPressed: () {},
              icon: Icon(
                FluentIcons.align_justify,
                size: 30,
              ))),
      pane: NavigationPane(
        selected: topIndex,
        onItemPressed: (index) {
          if (index == topIndex) {
            if (displayMode == PaneDisplayMode.open) {
              setState(() => this.displayMode = PaneDisplayMode.compact);
            } else if (displayMode == PaneDisplayMode.compact) {
              setState(() => this.displayMode = PaneDisplayMode.open);
            }
          }
        },
        onChanged: (index) => setState(() => topIndex = index),
        displayMode: displayMode,
        items: items,
        footerItems: [
          PaneItemAction(
            icon: const Icon(FluentIcons.design),
            title: const Text('Desarrollado por Jose Carlos A'),
            onTap: () async {
              //const url = Uri.parse('https://jcapala.com');
              final url = Uri.parse('https://jcapala.com');
              bool espera = await canLaunchUrl(url);
              if (espera) {
                await launchUrl(url);
              } else {
                throw 'No se pudo abrir la URL: $url';
              }
            },
          ),
        ],
      ),
    );
  }
}
