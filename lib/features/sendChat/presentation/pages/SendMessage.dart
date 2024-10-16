import 'dart:io';
import 'dart:ui';

import 'package:chat_bot_frontend/features/sendChat/data/models/message_model.dart';
import 'package:chat_bot_frontend/features/sendChat/domain/entities/chat.dart';
import 'package:chat_bot_frontend/features/sendChat/presentation/bloc/chat/chat_bloc.dart';
import 'package:chat_bot_frontend/features/sendChat/presentation/bloc/lista_contacto/lista_contacto_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ListchatBloc>(context).add(LoadChatsEvent());
  }

  String? _selectedValue;
  String? _enviarMensaje;

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
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/',
              (route) => false,
            );
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
                                            _enviarMensaje =
                                                selectedChat.mensaje;
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
                        onPressed: () {
                          if (_enviarMensaje == "" || _enviarMensaje is Null) {
                            final dialog = ContentDialog(
                              title: Text("Advertencia"),
                              content: Row(
                                children: [Text("Seleccione un mensaje")],
                              ),
                              actions: [
                                FilledButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Cierra el diálogo
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

                            return;
                          }
                          BlocProvider.of<ListaContactoBloc>(context)
                              .add(LoadExcel());
                        },
                      ),
                    ],
                    secondaryItems: [],
                  )),
              Expanded(
                flex: 5,
                child: BlocBuilder<ListaContactoBloc, ListaContactoState>(
                  builder: (context, state) {
                    List<Widget> _headers = [Text("Enviar")];
                    List<List<Widget>> _data = [];
                    if (state is ListaContactoLoadState) {
                      state.data.forEach(
                        (element) {
                          List<Widget> reg = [Icon(FluentIcons.accept)];
                          element.forEach(
                            (element) {
                              print(element.value);
                              print(element.runtimeType);
                              reg.add(Text(element.value.toString()));
                            },
                          );
                          _data.add(reg);
                        },
                      );
                      state.headers.forEach(
                        (element) {
                          _headers.add(Text(element.toString()));
                        },
                      );
                      return MostrarTabla(
                        data: _data,
                        headers: _headers,
                        enivarMensaje: _enviarMensaje ?? "",
                      );
                    } else if (state is ListaContactoSendend) {
                      // Limpiar las listas antes de mostrar los nuevos datos
                      _data.clear();
                      _headers.clear();

                      _headers.add(Text(
                          "Enviar")); // O la lógica que necesites para agregar los headers

                      // Procesar los datos emitidos en el estado Sendend
                      state.data.forEach((element) {
                        List<Widget> reg = [
                          Icon(FluentIcons.accept,
                              color: Colors.successPrimaryColor),
                        ];
                        element.forEach((element) {
                          reg.add(Text(element.value.toString()));
                        });
                        _data.add(reg);
                      });

                      state.headers.forEach((element) {
                        _headers.add(Text(element.toString()));
                      });

                      return MostrarTabla(
                        data: _data,
                        headers: _headers,
                        enivarMensaje: _enviarMensaje ?? "",
                      );
                    }
                    if (state is ListaContactoInitial) {
                      return Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Cargar un archivo Excel para ver los datos'),
                          SizedBox(width: 10),
                          Button(
                              child: Row(
                                children: [
                                  Icon(FluentIcons.contact_list),
                                  SizedBox(width: 5),
                                  Text("Importar Contactos")
                                ],
                              ),
                              onPressed: () {})
                        ],
                      ));
                    }
                    return Container();
                  },
                ),
              )
            ],
          )),
        );
      },
    );
  }
}

class MostrarTabla extends StatefulWidget {
  MostrarTabla(
      {super.key,
      required this.data,
      required this.headers,
      this.enivarMensaje = ""});
  List<Widget> headers = [];
  List<List<Widget>> data = [];
  String enivarMensaje;

  @override
  State<MostrarTabla> createState() => _MostrarTablaState();
}

class _MostrarTablaState extends State<MostrarTabla> {
  int? _selectedHeaderIndex;
  void _selectHeader(int index) {
    setState(() {
      _selectedHeaderIndex = _selectedHeaderIndex == index ? null : index;
    });
  }

  List<bool> listEnviado = [];
  bool _isDragging = false;
  Offset _dragStart = Offset.zero;

  void _onMouseDrag(PointerEvent details) {
    if (_isDragging) {
      double delta = details.localDelta.dx;
      _horizontalScrollController
          .jumpTo(_horizontalScrollController.offset - delta);
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

  void _showWarningDialog(BuildContext context, {required int buscardor}) {
    print(_selectedHeaderIndex);

    if (widget.enivarMensaje == "") {
      final dialog = ContentDialog(
        title: Text("Advertencia"),
        content: Row(
          children: [Text("Seleccione un mensaje")],
        ),
        actions: [
          FilledButton(
            onPressed: () {
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

      return;
    }
    final dialog = ContentDialog(
      title: Text('Advertencia', style: TextStyle(color: Colors.red)),
      content: Row(
        children: [
          Icon(FluentIcons.alert_solid, color: Colors.red),
          SizedBox(width: 8),
          Expanded(
            child: Text(
                '¿Está seguro de enviar un mensaje a todos los clientes?',
                style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () {
            BlocProvider.of<ListaContactoBloc>(context).add(
                EnviarMensajesMasivos(
                    index: _selectedHeaderIndex! - 1,
                    mensaje: widget.enivarMensaje));
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

  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  final FlyoutController _flyoutController = FlyoutController();
  final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  Offset _flyoutPosition = Offset.zero;
  List<double> columnWidths = [];

  final menuController = FlyoutController();

  // Función para ocultar una columna
  void _hideColumn(int index) {
    setState(() {
      columnWidths[index] = 5; // Cambia el ancho de la columna a 20
    });
  }

  // Función para restaurar una columna
  void _restoreColumn(int index) {
    setState(() {
      columnWidths[index] =
          150; // Restaura el ancho de la columna a su tamaño original
    });
  }

  @override
  void initState() {
    super.initState();
    listEnviado = List.generate(
      widget.data.length,
      (index) {
        return false;
      },
    );

    BlocProvider.of<ListchatBloc>(context).add(LoadChatsEvent());
  }

  void _removeSelectedColumn() {
    if (_selectedHeaderIndex != null) {
      setState(() {
        widget.headers.removeAt(_selectedHeaderIndex!);
        for (var row in widget.data) {
          row.removeAt(_selectedHeaderIndex!);
        }
        _selectedHeaderIndex = null;
      });
    }
  }

  List<List<dynamic>> filterDataByHeader(
      List<List<dynamic>> data, List<String> headers, String targetHeader) {
    int headerIndex = headers.indexOf(targetHeader);

    if (headerIndex == -1) {
      throw Exception("Header '$targetHeader' no encontrado.");
    }

    return data
        .where((row) =>
            row[headerIndex] != null && row[headerIndex].toString().isNotEmpty)
        .toList();
  }

  double anchominimo = 900;

  @override
  Widget build(BuildContext context) {
    // Agregar "Enviado" como primer encabezado
    /* List<String> headersWithSent = ["Enviado"] + widget.headers;
    print("lista de width");
    print(columnWidths.length); */

    if (widget.headers.isNotEmpty) {
      if (columnWidths.length == 0) {
        columnWidths = List<double>.filled(widget.headers.length, 150);
      }
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Icon(FluentIcons.alert_solid),
                  SizedBox(width: 8),
                  Text("Seleccione el campo telefónico"),
                ],
              ),
              Container(
                width: 150,
                child: FilledButton(
                  child: Text("Enviar Mensaje"),
                  onPressed: () => _showWarningDialog(context,
                      buscardor: _selectedHeaderIndex!),
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
                if (_isDragging) {
                  _horizontalScrollController.jumpTo(
                      _horizontalScrollController.offset - details.delta.dx);
                }
              },
              onPanEnd: (details) {
                _isDragging = false;
              },
              child: Scrollbar(
                thumbVisibility: true,
                controller: _verticalScrollController,
                child: SingleChildScrollView(
                  controller: _verticalScrollController,
                  scrollDirection: Axis.vertical,
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: _horizontalScrollController,
                    child: SingleChildScrollView(
                      controller: _horizontalScrollController,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: 50),
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
                                      onSecondaryTap: () {
                                        final RenderBox renderBox = key
                                            .currentContext!
                                            .findRenderObject() as RenderBox;
                                        final Offset offset = renderBox
                                            .localToGlobal(Offset.zero);

                                        _flyoutController.showFlyout(
                                          position:
                                              Offset(offset.dx, offset.dy + 40),
                                          barrierDismissible: true,
                                          dismissOnPointerMoveAway: false,
                                          dismissWithEsc: true,
                                          navigatorKey:
                                              rootNavigatorKey.currentState,
                                          builder: (context) {
                                            var repeat = true;
                                            var shuffle = false;

                                            var radioIndex = 1;
                                            return StatefulBuilder(
                                                builder: (context, setState) {
                                              return MenuFlyout(items: [
                                                MenuFlyoutItem(
                                                  text: const Text(
                                                      'Ocultar columna'),
                                                  onPressed: () {
                                                    _hideColumn(index);

                                                    Flyout.of(context).close();
                                                  },
                                                ),
                                                MenuFlyoutItem(
                                                  text: const Text(
                                                      'Mostrar completa'),
                                                  onPressed: () {
                                                    _restoreColumn(index);
                                                    Flyout.of(context).close();
                                                  },
                                                ),
                                                MenuFlyoutItem(
                                                  text: const Text(
                                                      'Eliminar columna'),
                                                  onPressed: () {
                                                    _removeSelectedColumn();
                                                    Flyout.of(context).close();
                                                  },
                                                ),
                                              ]);
                                            });
                                          },
                                        );
                                      },
                                      onDoubleTap: () {},
                                      onTap: () {
                                        _selectHeader(index);
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: _selectedHeaderIndex == index
                                                ? m.Colors.blue[200]
                                                : m.Colors.transparent,
                                            border: m.Border.all(
                                                color: m.Colors.grey),
                                          ),
                                          child:
                                              header /* Text(
                                          header,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ), */
                                          ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            rows: widget.data.map((row) {
                              // Agregar el ícono de check al principio de cada fila
                              return m.DataRow(
                                cells: [
                                  ...row.asMap().entries.map((entry) {
                                    int cellIndex = entry.key;
                                    var cell = entry.value;
                                    print(cell);
                                    print(cellIndex);
                                    print(columnWidths[cellIndex]);
                                    return m.DataCell(
                                      ConstrainedBox(
                                          constraints: BoxConstraints(
                                              minWidth:
                                                  columnWidths[cellIndex]),
                                          child:
                                              cell /* Text(
                                          cell.toString(),
                                          overflow: TextOverflow.ellipsis,
                                        ), */
                                          ),
                                    );
                                  }).toList(), // Ícono de check
                                  /* ...row.asMap().entries.map((entry) {
                                          int cellIndex = entry.key;
                                          var cell = entry.value;
                                          return m.DataCell(
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minWidth: columnWidths[
                                                    cellIndex], // Ajustar el ancho de cada celda según su índice
                                              ),
                                              child: Text(cell.toString()),
                                            ),
                                          );
                                        }).toList(), */
                                ],
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
