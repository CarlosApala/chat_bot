

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';



class SerialCodePage extends StatefulWidget {
  
  @override
  State<SerialCodePage> createState() => _SerialCodePageState();
}

class _SerialCodePageState extends State<SerialCodePage> {
  final List<TextEditingController> _controllers = List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());

  @override
  void initState() {
    super.initState();

    // Añadir listener a cada controlador para cambiar el foco
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].text.length == (i == 0 ? 8 : (i == 4 ? 12 : 4))) {
          if (i < 4) {
            FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            for (int i = 0; i < _controllers.length; i++)
              Container(
                width: 140,
                height: 30,
                child: TextBox(
                  controller: _controllers[i],
                  focusNode: _focusNodes[i],
                  
                  textInputAction: TextInputAction.next,
                  maxLength: (i == 0 ? 8 : (i == 4 ? 12 : 4)),
                  keyboardType: TextInputType.text,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F]'))],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
