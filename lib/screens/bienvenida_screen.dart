import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    // Mensaje de bienvenida automático
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _messages.add({
          'text': '¡Buenos días! Bienvenidos a nuestra empresa, ¿cómo podemos ayudarte?',
          'image': null,
          'isBot': true
        });
      });
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();

      setState(() {
        _messages.add({'text': null, 'image': bytes, 'isBot': false});
      });
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final userMessage = _controller.text;
      setState(() {
        _messages.add({'text': userMessage, 'image': null, 'isBot': false});
        _controller.clear();
      });
      _getResponse(userMessage);
    }
  }

  void _getResponse(String userMessage) {
    String response;

    // Respuestas basadas en palabras clave
    if (userMessage.toLowerCase().contains('precio')) {
      response = 'Los precios varían según el producto. ¿Hay algo específico que te interese?';
    } else if (userMessage.toLowerCase().contains('envio')) {
      response = 'Ofrecemos envío gratuito en pedidos mayores a \$50.';
    } else if (userMessage.toLowerCase().contains('horarios')) {
      response = 'Nuestro horario de atención es de 9:00 AM a 6:00 PM de lunes a viernes.';
    } else if (userMessage.toLowerCase().contains('hola')) {
      response = '¡Hola! ¿En qué puedo ayudarte hoy?';
    } else {
      response = 'Lo siento, no entendí tu pregunta. ¿Puedes reformularla?';
    }

    setState(() {
      _messages.add({'text': response, 'image': null, 'isBot': true});
    });
  }

  void _deleteImage(int index) {
    setState(() {
      _messages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatbot"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade100, Colors.deepPurple.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isBot = message['isBot'] ?? false;
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    alignment: isBot ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isBot ? Colors.deepPurple.shade200 : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: message['text'] != null
                          ? Text(
                              message['text'],
                              style: TextStyle(
                                fontSize: 16,
                                color: isBot ? Colors.white : Colors.black87,
                              ),
                            )
                          : Column(
                              children: [
                                Image.memory(
                                  message['image'],
                                  fit: BoxFit.cover,
                                  height: 200,
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: () => _deleteImage(index),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.image, color: Colors.deepPurple),
                    onPressed: _pickImage,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Escribe un mensaje",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.deepPurple),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
