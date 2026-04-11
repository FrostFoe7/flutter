import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'appwrite_config.g.dart';

@riverpod
Client appwriteClient(Ref ref) {
  final client = Client()
    ..setEndpoint('https://sgp.cloud.appwrite.io/v1') 
    ..setProject('695103540022da68cbb9');
  return client;
}

@riverpod
Account appwriteAccount(Ref ref) {
  final client = ref.watch(appwriteClientProvider);
  return Account(client);
}
