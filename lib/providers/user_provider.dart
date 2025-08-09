import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/user_repository.dart';
import '../Model/user/user.dart';

final userProvider = StreamProvider<User>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.userStream;
});
