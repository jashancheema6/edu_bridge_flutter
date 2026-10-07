import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../widgets/custome_button.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({super.key});

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final TextEditingController messageController = TextEditingController();
  bool isSending = false;

  // Async function to send message to Firestore
  Future<void> sendMessage() async {
    String msg = messageController.text.trim();
    if (msg.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a message")),
      );
      return;
    }

    setState(() {
      isSending = true;
    });

    try {
      await FirebaseFirestore.instance.collection('messages').add({
        'message': msg,
        'sender': 'teacher', // optional: store teacher ID
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Message sent: $msg")),
      );

      messageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send: $e")),
      );
    } finally {
      setState(() {
        isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Message"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Write your message:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Enter Message",
                labelStyle: const TextStyle(color: Colors.indigo),
                prefixIcon: const Icon(Icons.message, color: Colors.indigo),
                filled: true,
                fillColor: const Color(0xFFE8EAF6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 25),
            CustomButton(
              text: isSending ? "Sending..." : "Send Message",
              icon: Icons.send,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFE1F5FE),
                  Color(0xFFB3E5FC),
                ],
              ),
              // Wrap async function in synchronous closure to satisfy VoidCallback
              onTap: isSending
                  ? () {}
                  : () {
                sendMessage();
              },
            ),
          ],
        ),
      ),
    );
  }
}
