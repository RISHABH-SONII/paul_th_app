// transaction_builder.dart
class TransactionBuilder {
  static Map<String, dynamic> buildTransaction({
    required String contextType, // 'token' or 'gift'
    required String amount,
    required String selectedCurrency,
    required Map<String, dynamic> currentUser,
    Map<String, dynamic>? receiverUser,
    int? tokens,
    String? chatRoomId,
  }) {
    return {
      "amount": {
        "total": (double.tryParse(amount) ?? 0.0),
        "currency": selectedCurrency,
        "details": {"subtotal": (double.tryParse(amount) ?? 0.0), "shipping": "", "shipping_discount": 0.0}
      },
      "description": contextType == "gift"
          ? "Gift/Peek access to ${receiverUser?['name'] ?? ''}"
          : "Token purchase",
      "item_list": {
        "items": [
          {
            "name": contextType == "gift"
                ? "Peek Access for ${receiverUser?['name'] ?? ''}"
                : "Token Package (${tokens ?? 0} tokens)",
            "quantity": 1,
            "price": (double.tryParse(amount) ?? 0.0),
            "currency": selectedCurrency
          }
        ],
        "shipping_address": {
          "recipient_name": contextType == "gift"
              ? (receiverUser != null && receiverUser['name'] != null
                  ? receiverUser['name']
                  : 'N/A')
              : (currentUser['name'] ?? ''),
          "line1": "Delhi",
          "line2": "",
          "city": "Delhi",
          "country_code": "IN",
          "postal_code": "11001",
          "phone": "+00000000",
          "state": "Texas"
        }
      },
      "meta": {
        "used_for": contextType == "gift" ? "peek" : "token_purchase",
        "sender_id": currentUser['id'],
        "receiver_id": contextType == "gift"
            ? (receiverUser != null && receiverUser['name'] != null
                ? receiverUser['id']
                : '')
            : null,
        "tokens_purchased": contextType == "token" ? tokens : null,
        "chat_room_id": contextType == "gift" ? chatRoomId : null,
        "timestamp": DateTime.now().toIso8601String()
      }
    };
  }
}
