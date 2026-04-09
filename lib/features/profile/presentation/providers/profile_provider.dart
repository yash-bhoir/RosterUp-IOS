import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/profile_repository.dart';
import '../../domain/entities/profile.dart';

final profileProvider =
    AsyncNotifierProvider<ProfileNotifier, UserProfile>(ProfileNotifier.new);

class ProfileNotifier extends AsyncNotifier<UserProfile> {
  @override
  Future<UserProfile> build() async {
    final repo = ref.read(profileRepositoryProvider);
    final result = await repo.getProfile();
    return result.when(
      success: (data) => data,
      failure: (e) => throw e,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

final accountStatsProvider =
    AsyncNotifierProvider<AccountStatsNotifier, AccountStats>(
  AccountStatsNotifier.new,
);

class AccountStatsNotifier extends AsyncNotifier<AccountStats> {
  @override
  Future<AccountStats> build() async {
    final repo = ref.read(profileRepositoryProvider);
    final result = await repo.getAccountStats();
    return result.when(
      success: (data) => data,
      failure: (e) => throw e,
    );
  }
}

final updateProfileProvider =
    StateNotifierProvider<UpdateProfileNotifier, AsyncValue<void>>((ref) {
  return UpdateProfileNotifier(ref);
});

class UpdateProfileNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  UpdateProfileNotifier(this._ref) : super(const AsyncData(null));

  Future<bool> update({
    String? email,
    String? userState,
    String? dateOfBirth,
    String? gender,
  }) async {
    state = const AsyncLoading();
    final repo = _ref.read(profileRepositoryProvider);
    final result = await repo.updateProfile(
      email: email,
      state: userState,
      dateOfBirth: dateOfBirth,
      gender: gender,
    );
    return result.when(
      success: (_) {
        state = const AsyncData(null);
        _ref.read(profileProvider.notifier).refresh();
        return true;
      },
      failure: (e) {
        state = AsyncError(e, StackTrace.current);
        return false;
      },
    );
  }
}
