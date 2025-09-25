import 'dart:async';

// A function that simulates a network call with a delay
Future<String> fetchUserOrder() {
  return Future.delayed(Duration(seconds: 2), () => 'Large Latte');
}

// A function that simulates another network call with a delay
Future<String> fetchUserDetails() {
  return Future.delayed(Duration(seconds: 1), () => 'User: John Doe');
}

void main() {
  print('Fetching user details...');
  fetchUserDetails().then((userDetails) {
    print(userDetails);
    print('Fetching user order...');
    return fetchUserOrder();
  }).then((userOrder) {
    print(userOrder);
  }).catchError((error) {
    print('An error occurred: $error');
  }).whenComplete(() {
    print('Done fetching data.');
  });
}
