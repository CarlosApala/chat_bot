import 'dart:io';
import 'dart:ui';

import 'package:chat_bot_frontend/features/sendChat/data/models/message_model.dart';
import 'package:chat_bot_frontend/features/sendChat/domain/entities/chat.dart';
import 'package:chat_bot_frontend/features/sendChat/presentation/bloc/chat/chat_bloc.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/listchat/listchat_bloc.dart';

class SendMessage extends StatefulWidget {
  SendMessage({super.key});

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<String> _headers = [];
  List<List<dynamic>> _data = [];

  String? _selectedValue;

  void _showDialog(BuildContext context) {
    final dialog = ContentDialog(
      title: Text('Formulario de Mensaje'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextBox(
            placeholder: 'Título',
            controller: _titleController,
          ),
          SizedBox(height: 10),
          TextBox(
            minLines: null,
            maxLines: null,
            placeholder: 'Mensaje',
            controller: _messageController,
            expands: true, // Permite que el campo se expanda
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment
                .start, // Alinea los elementos al inicio verticalmente
            children: [
              Icon(FluentIcons.alert_solid),
              SizedBox(width: 8), // Espacio entre el ícono y el texto
              Expanded(
                child: RichText(
                  text: m.TextSpan(
                    children: [
                      m.TextSpan(
                        text: "Utilize el ",
                        style: DefaultTextStyle.of(context).style,
                      ),
                      m.TextSpan(
                        text: "#cliente",
                        style: DefaultTextStyle.of(context).style.copyWith(
                              fontWeight: FontWeight.bold, // Negrita
                            ),
                      ),
                      m.TextSpan(
                        text: ", este se cambiará por el nombre del mismo",
                        style: DefaultTextStyle.of(context).style,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () {
            String title = _titleController.text;
            String message = _messageController.text;

            print('Título: $title');
            print('Mensaje: $message');
            BlocProvider.of<ChatBloc>(context)
                .add(SaveChatMessage(mensaje: message, titulo: title));

            //BlocProvider.of<ListchatBloc>(context).add(LoadChatsEvent());
            _messageController.clear();
            _titleController.clear();
            Navigator.of(context).pop();
          },
          child: Text('Guardar'),
        ),
        FilledButton(
          style: ButtonStyle(
            backgroundColor: ButtonState.all(Colors.red), // Color de peligro
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancelar',
          ),
        ),
      ],
    );

    showDialog(
      barrierDismissible: true,
      dismissWithEsc: true,
      context: context,
      builder: (context) => dialog,
    ).then((_) {});
  }

  void _showDialogMostrar(BuildContext context,
      {required ChatModel existingChat}) {
    _titleController.text = existingChat.titulo ?? '';
    _messageController.text = existingChat.mensaje ?? '';
    final dialog = ContentDialog(
      title: Text('Formulario de Mensaje'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextBox(
            placeholder: 'Título',
            controller: _titleController,
          ),
          SizedBox(height: 10),
          TextBox(
            minLines: null,
            maxLines: null,
            placeholder: 'Mensaje',
            controller: _messageController,
            expands: true, // Permite que el campo se expanda
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment
                .start, // Alinea los elementos al inicio verticalmente
            children: [
              Icon(FluentIcons.alert_solid),
              SizedBox(width: 8), // Espacio entre el ícono y el texto
              Expanded(
                child: RichText(
                  text: m.TextSpan(
                    children: [
                      m.TextSpan(
                        text: "Utilize el ",
                        style: DefaultTextStyle.of(context).style,
                      ),
                      m.TextSpan(
                        text: "#cliente",
                        style: DefaultTextStyle.of(context).style.copyWith(
                              fontWeight: FontWeight.bold, // Negrita
                            ),
                      ),
                      m.TextSpan(
                        text: ", este se cambiará por el nombre del mismo",
                        style: DefaultTextStyle.of(context).style,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () {
            String title = _titleController.text;
            String message = _messageController.text;

            print('Título: $title');
            print('Mensaje: $message');
            BlocProvider.of<ChatBloc>(context)
                .add(UpdateChatMessage(chat: existingChat));
            Navigator.of(context).pop();
          },
          child: Text('Guardar'),
        ),
        FilledButton(
          style: ButtonStyle(
            backgroundColor: ButtonState.all(Colors.red), // Color de peligro
          ),
          onPressed: () {
            BlocProvider.of<ChatBloc>(context)
                .add(DeleteChatMessage(id: existingChat.id!));
            Navigator.of(context).pop();
          },
          child: Text('Eliminar'),
        ),
      ],
    );

    showDialog(
      barrierDismissible: true,
      dismissWithEsc: true,
      context: context,
      builder: (context) => dialog,
    ).then((_) {
      // Limpia los controladores cuando se cierra el diálogo
      _clearTextFields();
    });
    ;
  }

  // Método para limpiar los controladores
  void _clearTextFields() {
    _titleController.clear();
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatSaveChat) {
          BlocProvider.of<ListchatBloc>(context).add(LoadChatsEvent());
        }
        return ScaffoldPage(
          padding: EdgeInsets.only(top: 0),
          resizeToAvoidBottomInset: false,
          content: Expanded(
              child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: CommandBar(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Alineación de los elementos
                    primaryItems: [
                      CommandBarButton(
                        icon: const Icon(FluentIcons.add),
                        label: const Text('Crear Mensaje'),
                        onPressed: () => _showDialog(context),
                      ),
                      CommandBarSeparator(), // Separador entre los botones

                      CommandBarButton(
                        icon: const Icon(FluentIcons.list),
                        label: SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Seleccione el Mensaje'),
                              SizedBox(
                                width: 250, // Ajusta el ancho del ComboBox
                                child: BlocBuilder<ListchatBloc, ListchatState>(
                                  builder: (context, state) {
                                    if (state is ListchatLoading) {
                                      return const ProgressBar();
                                    } else if (state is ListchatLoaded) {
                                      return ComboBox<String>(
                                        placeholder:
                                            Text('Selecciona una opción'),
                                        value: _selectedValue,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedValue = newValue;

                                            // Encuentra el chat correspondiente al valor seleccionado
                                            final selectedChat = state.chats
                                                .firstWhere(
                                                    (chat) =>
                                                        chat.id.toString() ==
                                                        newValue,
                                                    orElse:
                                                        null // En caso de que no se encuentre
                                                    );

                                            if (selectedChat != null) {
                                              String? title = selectedChat
                                                  .titulo; // Título del chat
                                              /* String message =
                                                  'Mensaje para ${selectedChat.titulo}'; */
                                              _showDialogMostrar(context,
                                                  existingChat: selectedChat);
                                            }
                                          });
                                        },
                                        items: state.chats.map((chat) {
                                          return ComboBoxItem<String>(
                                            value: chat.id
                                                .toString(), // Usa un identificador único
                                            child: Text(chat.titulo
                                                .toString()), // Título del chat
                                          );
                                        }).toList(),
                                      );
                                    } else if (state is ListchatError) {
                                      return Text('Error: ${state.message}');
                                    }
                                    return const SizedBox
                                        .shrink(); // Placeholder vacío
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () {},
                      ),
                      CommandBarSeparator(),

                      CommandBarButton(
                        icon: const Icon(FluentIcons.contact_list),
                        label: const Text('Importar Contactos'),
                        onPressed: _loadExcel,
                      ),
                    ],
                    secondaryItems: [],
                  )),
              Expanded(
                child: MostrarTabla(
                  data: _data,
                  headers: _headers,
                ),
                flex: 5,
              )
            ],
          )),
        );
      },
    );
  }

  //---------------------------------

  Future<void> _loadExcel() async {
    // Asegúrate de que el contexto sea válido al llamar a FilePicker
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.single.path!);
        var bytes = await file.readAsBytes();
        var excel = Excel.decodeBytes(bytes);

        for (var table in excel.tables.keys) {
          var sheet = excel.tables[table];

          if (sheet != null) {
            _headers = sheet.rows.first
                .map((cell) => cell?.value?.toString() ?? '')
                .toList()
                .cast<String>();
            _data = sheet.rows
                .skip(1)
                .map((row) => row.map((cell) => cell?.value ?? '').toList())
                .toList();
          }
        }

        setState(() {});
      }
    } catch (e) {
      // Manejo de errores
      print('Error al cargar el archivo: $e');
    }
  }
}

class MostrarTabla extends StatefulWidget {
  MostrarTabla({super.key, required this.data, required this.headers});
  List<String> headers = [];
  List<List<dynamic>> data = [];
  int? _selectedHeaderIndex; // Índice del encabezado seleccionado
  @override
  State<MostrarTabla> createState() => _MostrarTablaState();
}

class _MostrarTablaState extends State<MostrarTabla> {
  void _selectHeader(int index) {
    setState(() {
      // Cambia el índice del encabezado seleccionado
      widget._selectedHeaderIndex =
          widget._selectedHeaderIndex == index ? null : index;
    });
  }

  bool _isDragging = false;
  Offset _dragStart = Offset.zero;

  void _onMouseDrag(PointerEvent details) {
    if (_isDragging) {
      // Calcula la diferencia del movimiento
      double delta = details.localDelta.dx;
      // Mueve el scroll horizontalmente
      _horizontalScrollController.jumpTo(
        _horizontalScrollController.offset - delta,
      );
    }
  }

  void _onRightMouseDown(PointerDownEvent details) {
    if (details.kind == PointerDeviceKind.mouse) {
      setState(() {
        _isDragging = true;
      });
      _dragStart = details.localPosition;
    }
  }

  void _onRightMouseUp(PointerUpEvent details) {
    setState(() {
      _isDragging = false;
    });
  }

  void _showWarningDialog(BuildContext context,
      {required List<List<dynamic>> data,
      required List<String> headers,
      required String buscardor}) {
    final dialog = ContentDialog(
      title: Text(
        'Advertencia',
        style: TextStyle(color: Colors.red),
      ),
      content: Row(
        children: [
          Icon(
            FluentIcons.alert_solid,
            color: Colors.red,
          ),
          SizedBox(width: 8), // Espacio entre el icono y el texto
          Expanded(
            child: Text(
              'Esta seguro de enviar un mensaje a todos los clientes?',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () {
            List<List<dynamic>> filterData =
                filterDataByHeader(data, headers, "celular");
            int index = headers.indexWhere((nomb) => nomb == buscardor);
            for (var element in filterData) {
              print(element[index]);
            }
            Navigator.of(context).pop(); // Cierra el diálogo
          },
          child: Text('Aceptar'),
        ),
      ],
    );

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => dialog,
    );
  }

  // Controladores de scroll
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  final FlyoutController _flyoutController = FlyoutController();
  final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  Offset _flyoutPosition = Offset.zero;

  final menuController = FlyoutController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ListchatBloc>(context).add(LoadChatsEvent());
  }

  void _removeSelectedColumn() {
    if (widget._selectedHeaderIndex != null) {
      setState(() {
        // Elimina el encabezado seleccionado
        widget.headers.removeAt(widget._selectedHeaderIndex!);
        // Elimina la columna correspondiente en cada fila de datos
        for (var row in widget.data) {
          row.removeAt(widget._selectedHeaderIndex!);
        }
        widget._selectedHeaderIndex = null; // Resetea el índice seleccionado
      });
    }
  }

  List<List<dynamic>> filterDataByHeader(
      List<List<dynamic>> data, List<String> headers, String targetHeader) {
    // Encuentra el índice del encabezado "celular"
    int headerIndex = headers.indexOf(targetHeader);

    if (headerIndex == -1) {
      throw Exception("Header '$targetHeader' no encontrado.");
    }

    // Filtrar los datos donde la columna "celular" no sea nula o vacía
    return data
        .where((row) =>
            row[headerIndex] != null && row[headerIndex].toString().isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return widget.headers.isEmpty
        ? Center(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              m.Text('Cargar un archivo Excel para ver los datos'),
              SizedBox(
                width: 10,
              ),
              Button(
                  child: Row(
                    children: [
                      Icon(FluentIcons.contact_list),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Importar Contactos")
                    ],
                  ),
                  onPressed: () {})
            ],
          ))
        : Column(
            children: [
              Container(
                width: double.infinity, // Ocupar todo el espacio disponible
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(FluentIcons.alert_solid),
                        SizedBox(
                            width: 8), // Espaciado entre el icono y el texto
                        Text("Seleccione el campo telefónico"),
                      ],
                    ),
                    Container(
                      width: 150,
                      child: FilledButton(
                        style: ButtonStyle(),
                        child: Text("Enviar Mensaje"),
                        onPressed: () => _showWarningDialog(context,
                            data: widget.data,
                            headers: widget.headers,
                            buscardor: "celular"),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: MouseRegion(
                  onEnter: (_) {},
                  onExit: (_) {
                    setState(() {
                      _isDragging = false;
                    });
                  },
                  onHover: _onMouseDrag,
                  child: GestureDetector(
                    onPanStart: (details) {
                      if (details.localPosition.dx >= 0) {
                        _onRightMouseDown(
                          PointerDownEvent(
                            position: details.localPosition,
                            kind: PointerDeviceKind.mouse,
                          ),
                        );
                      }
                    },
                    onPanUpdate: (details) {
                      // Actualiza la posición durante el arrastre
                      if (_isDragging) {
                        // Mueve el scroll horizontalmente usando delta.dx
                        _horizontalScrollController.jumpTo(
                          _horizontalScrollController.offset - details.delta.dx,
                        );
                      }
                    },
                    onPanEnd: (details) {
                      // Finaliza el arrastre
                      _isDragging = false;
                    },
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: _verticalScrollController,
                      interactive: true,
                      child: SingleChildScrollView(
                        controller: _verticalScrollController,
                        scrollDirection: Axis.vertical,
                        child: Scrollbar(
                          thumbVisibility: true,
                          style: ScrollbarThemeData(
                            thickness: 10,
                          ),
                          controller: _horizontalScrollController,
                          child: SingleChildScrollView(
                            controller: _horizontalScrollController,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    minWidth:
                                        800), // Ancho mínimo para activar el scroll
                                child: m.DataTable(
                                  columns: widget.headers.map((header) {
                                    GlobalKey key = GlobalKey();
                                    int index = widget.headers.indexOf(header);
                                    return m.DataColumn(
                                      label: MouseRegion(
                                        cursor: m.SystemMouseCursors.click,
                                        child: FlyoutTarget(
                                          controller: _flyoutController,
                                          child: GestureDetector(
                                            key: key,
                                            onTap: () {
                                              _selectHeader(index);
                                              final RenderBox renderBox = key
                                                      .currentContext!
                                                      .findRenderObject()
                                                  as RenderBox;
                                              final Offset offset = renderBox
                                                  .localToGlobal(Offset.zero);

                                              _flyoutController.showFlyout(
                                                position: Offset(
                                                    offset.dx, offset.dy + 40),
                                                barrierDismissible: true,
                                                dismissOnPointerMoveAway: false,
                                                dismissWithEsc: true,
                                                navigatorKey: rootNavigatorKey
                                                    .currentState,
                                                builder: (context) {
                                                  var repeat = true;
                                                  var shuffle = false;

                                                  var radioIndex = 1;
                                                  return StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                    return MenuFlyout(items: [
                                                      MenuFlyoutItem(
                                                        text: const Text(
                                                            'Ocultar columna'),
                                                        onPressed: () {
                                                          // Oculta la columna
                                                          Flyout.of(context)
                                                              .close();
                                                        },
                                                      ),
                                                      MenuFlyoutItem(
                                                        text: const Text(
                                                            'Mostrar completa'),
                                                        onPressed: () {
                                                          // Muestra la columna completa
                                                          Flyout.of(context)
                                                              .close();
                                                        },
                                                      ),
                                                      MenuFlyoutItem(
                                                        text: const Text(
                                                            'Eliminar columna'),
                                                        onPressed: () {
                                                          _removeSelectedColumn();
                                                          Flyout.of(context)
                                                              .close();
                                                        },
                                                      ),
                                                    ]);
                                                  });
                                                },
                                              );
                                            },
                                            /* onTap: () {
                                              _selectHeader(index);
                                              _flyoutController.showFlyout(
                                                  barrierDismissible: true,
                                                  dismissWithEsc: true,
                                                  dismissOnPointerMoveAway:
                                                      false,
                                                  navigatorKey: rootNavigatorKey
                                                      .currentState,
                                                  builder: (context) {
                                                    var repeat = true;
                                                    var shuffle = false;
                                        
                                                    var radioIndex = 1;
                                                    return StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                      return MenuFlyout(items: [
                                                        MenuFlyoutItem(
                                                          text: const Text(
                                                              'Reset'),
                                                          onPressed: () {
                                                            setState(() {
                                                              repeat = false;
                                                              shuffle = false;
                                                            });
                                                          },
                                                        ),
                                                        const MenuFlyoutSeparator(),
                                                        ToggleMenuFlyoutItem(
                                                          text: const Text(
                                                              'Repeat'),
                                                          value: repeat,
                                                          onChanged: (v) {
                                                            setState(() =>
                                                                repeat = v);
                                                          },
                                                        ),
                                                        ToggleMenuFlyoutItem(
                                                          text: const Text(
                                                              'Shuffle'),
                                                          value: shuffle,
                                                          onChanged: (v) {
                                                            setState(() =>
                                                                shuffle = v);
                                                          },
                                                        ),
                                                        const MenuFlyoutSeparator(),
                                                        ...List.generate(3,
                                                            (index) {
                                                          return RadioMenuFlyoutItem(
                                                            text: Text([
                                                              'Small icons',
                                                              'Medium icons',
                                                              'Large icons',
                                                            ][index]),
                                                            value: index,
                                                            groupValue:
                                                                radioIndex,
                                                            onChanged: (v) {
                                                              setState(() =>
                                                                  radioIndex =
                                                                      index);
                                                            },
                                                          );
                                                        }),
                                                      ]);
                                                    });
                                                  });
                                            }, */
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color:
                                                    widget._selectedHeaderIndex ==
                                                            index
                                                        ? m.Colors.blue[200]
                                                        : m.Colors.transparent,
                                                border: m.Border.all(
                                                    color: m.Colors.grey),
                                              ),
                                              child: Text(
                                                header,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  rows: widget.data.map((row) {
                                    return m.DataRow(
                                      cells: row.map((cell) {
                                        return m.DataCell(
                                          ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                minWidth:
                                                    100), // Ajusta el ancho mínimo de cada columna
                                            child: Text(cell.toString()),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
