class Env {
  final String baseUrl;
  final String name;
  final bool isStaging;

  const Env._({
    required this.baseUrl,
    required this.name,
    required this.isStaging,
  });

  static Env fromDefines() {
    const env = String.fromEnvironment('ENV', defaultValue: 'staging');
    switch (env) {
      case 'prod':
        return const Env._(
          baseUrl: 'https://rosterup.in/',
          name: 'Production',
          isStaging: false,
        );
      case 'staging':
      default:
        return const Env._(
          baseUrl: 'http://staging.rosterup.in/',
          name: 'Staging',
          isStaging: true,
        );
    }
  }
}
