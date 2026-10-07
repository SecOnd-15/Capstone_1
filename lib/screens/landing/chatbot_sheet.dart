import 'package:flutter/material.dart';

class ChatBotSheet extends StatefulWidget {
  const ChatBotSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ChatBotSheet(),
    );
  }

  @override
  State<ChatBotSheet> createState() => _ChatBotSheetState();
}

class _ChatBotSheetState extends State<ChatBotSheet> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Welcome message
    _messages.add(_ChatMessage(
      text: 'Mabuhay! 🤖 Welcome to Gran Verde Cacao Farm!\n\n'
          'I\'m Verde Bot, your AI Assistant. How can I help you today?',
      isBot: true,
    ));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isBot: false));
      _isTyping = true;
    });
    _messageController.clear();
    _scrollToBottom();

    // Simulate bot response
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      final response = _generateBotResponse(text);
      setState(() {
        _messages.add(_ChatMessage(text: response, isBot: true));
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }

  String _generateBotResponse(String userMessage) {
    final msg = userMessage.toLowerCase();

    if (msg.contains('book') || msg.contains('reserve') || msg.contains('schedule')) {
      return '📋 To book a tour or experience, simply:\n\n'
          '1. Browse our experiences on the homepage\n'
          '2. Tap "Book Now" on any tour\n'
          '3. Choose your slot, add-ons, and pay via GCash/Maya/BPI\n\n'
          'No account needed! Guests can book directly. 🎉';
    }

    if (msg.contains('price') || msg.contains('cost') || msg.contains('how much') || msg.contains('fee')) {
      return '💰 Our tour pricing:\n\n'
          '• Bean-to-Bar Workshop — ₱350/person\n'
          '• Morning Brew & Birding — ₱150/person\n'
          '• Farm Walk & Canopy — ₱280/person\n'
          '• Tablea Tasting Cup — ₱150\n\n'
          'Group discounts available for 7+ guests!';
    }

    if (msg.contains('hour') || msg.contains('open') || msg.contains('time') || msg.contains('schedule')) {
      return '🕐 Farm Operating Hours:\n\n'
          '• Monday–Saturday: 8:00 AM – 5:00 PM\n'
          '• Sunday: 9:00 AM – 3:00 PM\n'
          '• Holidays: By appointment only\n\n'
          'Tour slots: 8 AM, 10 AM, and 2 PM daily.';
    }

    if (msg.contains('location') || msg.contains('where') || msg.contains('address') || msg.contains('how to get')) {
      return '📍 Gran Verde Cacao Farm\n'
          'Calinan District, Davao City, Philippines\n\n'
          '🚗 ~45 min from downtown Davao\n'
          '🚌 Take the Calinan-bound jeepney from Bankerohan\n\n'
          'We can arrange shuttle pickups for groups of 5+!';
    }

    if (msg.contains('product') || msg.contains('tablea') || msg.contains('chocolate') || msg.contains('store')) {
      return '🍫 Our Artisan Products:\n\n'
          '• Pure Davao Tablea — ₱180/box\n'
          '• Single-Origin Dark Choco — ₱220/bar\n'
          '• Roasted Cacao Nibs — ₱160/pouch\n'
          '• Cacao Husk Herbal Tea — ₱140/tin\n'
          '• Cacao Butter Balm — ₱250/jar\n\n'
          'All farm-made & organic! 🌱';
    }

    if (msg.contains('hello') || msg.contains('hi') || msg.contains('hey') || msg.contains('kumusta')) {
      return 'Hello! 😊 Welcome to Gran Verde!\n\n'
          'I can help you with:\n'
          '• 🎯 Tour bookings & pricing\n'
          '• 🍫 Artisan cacao products\n'
          '• 🕐 Farm hours & location\n'
          '• 🌿 Sustainability practices\n\n'
          'What would you like to know?';
    }

    if (msg.contains('payment') || msg.contains('gcash') || msg.contains('maya') || msg.contains('pay')) {
      return '💳 We accept:\n\n'
          '• GCash — 0917-888-8721\n'
          '• Maya — 0917-888-8721\n'
          '• BPI Bank Transfer\n\n'
          'Just scan the QR code in the booking form and enter your reference number. Staff will verify within 30 minutes!';
    }

    if (msg.contains('thank') || msg.contains('salamat')) {
      return 'You\'re welcome! 🌿 Salamat!\n\n'
          'We look forward to welcoming you at Gran Verde Cacao Farm. '
          'If you need anything else, just ask! 😊';
    }

    // Default fallback
    return '🌿 Thanks for your message!\n\n'
        'I can assist you with:\n'
        '• 🎯 Booking tours & experiences\n'
        '• 💰 Pricing & packages\n'
        '• 📍 Location & directions\n'
        '• 🕐 Operating hours\n'
        '• 🍫 Farm products & store\n'
        '• 💳 Payment methods\n\n'
        'Try asking about any of these topics!';
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
      decoration: const BoxDecoration(
        color: Color(0xFFF7F8F7),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Chat Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF0F4E31),
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.smart_toy_rounded, color: Colors.white, size: 22),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verde Bot — AI Assistant',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Online • Gran Verde Cacao Farm',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Color(0xFF8BCFA5),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Quick Reply Chips (above message box)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickChip('🎯 Book a Tour'),
                  _buildQuickChip('💰 Pricing'),
                  _buildQuickChip('🕐 Hours'),
                  _buildQuickChip('📍 Location'),
                  _buildQuickChip('🍫 Products'),
                  _buildQuickChip('💳 Payment'),
                ],
              ),
            ),
          ),

          // Input Bar
          Container(
            padding: EdgeInsets.fromLTRB(12, 8, 8, bottomInset + 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: TextField(
                      controller: _messageController,
                      onSubmitted: (_) => _handleSend(),
                      textInputAction: TextInputAction.send,
                      decoration: const InputDecoration(
                        hintText: 'Ask Verde anything...',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: Color(0xFF9CA3AF),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Material(
                  color: const Color(0xFF0F4E31),
                  borderRadius: BorderRadius.circular(22),
                  child: InkWell(
                    onTap: _handleSend,
                    borderRadius: BorderRadius.circular(22),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.send_rounded, color: Colors.white, size: 19),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: () {
          _messageController.text = label.replaceAll(RegExp(r'[^\w\s]'), '').trim();
          _handleSend();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFD1D5DB)),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage message) {
    final isBot = message.isBot;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBot) ...[
            Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(right: 8, top: 2),
              decoration: const BoxDecoration(
                color: Color(0xFF0F4E31),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.smart_toy_rounded, color: Colors.white, size: 16),
              ),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isBot ? Colors.white : const Color(0xFF0F4E31),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isBot ? 4 : 16),
                  bottomRight: Radius.circular(isBot ? 16 : 4),
                ),
                border: isBot ? Border.all(color: const Color(0xFFE5E7EB)) : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  height: 1.45,
                  color: isBot ? const Color(0xFF1F2937) : Colors.white,
                ),
              ),
            ),
          ),
          if (!isBot) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF0F4E31),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.smart_toy_rounded, color: Colors.white, size: 16),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return Container(
                  margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F4E31).withValues(alpha: 0.4 + (i * 0.15)),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isBot;

  _ChatMessage({required this.text, required this.isBot});
}
