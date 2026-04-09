import '../../../../core/errors/result.dart';
import '../entities/match.dart';

abstract class MatchRepository {
  Future<Result<List<Match>>> getLiveMatches({String? sportKey});
  Future<Result<List<Match>>> getMyUpcomingMatches({String? sportKey});
  Future<Result<PaginatedMatches>> getUpcomingMatches({
    int page = 1,
    int perPage = 20,
    String? sportKey,
  });
  Future<Result<PaginatedMatches>> getCompletedMatches({
    int page = 1,
    int perPage = 20,
    String? sportKey,
  });
}
