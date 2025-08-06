import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/user_repository.dart';
import '../Model/user/user.dart';

final userProvider = FutureProvider<User>((ref) async {
  final repository = ref.watch(userRepositoryProvider);
  return await repository.userStream.first;
});
