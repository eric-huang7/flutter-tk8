enum BuildType {
  local,
  development,
  staging,
  store,
}

const devApiHost = 'https://tk8-api.herokuapp.com';
const stagingApiHost = 'https://tk8-api.herokuapp.com';
const productionApiHost = 'https://tk8-api.herokuapp.com';

const defaultApiHost = {
  BuildType.local: devApiHost,
  BuildType.development: devApiHost,
  BuildType.staging: stagingApiHost,
  BuildType.store: productionApiHost,
};

class AppConfig {
  final BuildType buildType;

  AppConfig() : buildType = _getBuildTypeFromEnvironment();

  String get apiHost => defaultApiHost[buildType];

  bool get showDebugScreen =>
      buildType == BuildType.local || buildType == BuildType.development;
}

BuildType _getBuildTypeFromEnvironment() {
  const envBuildType = String.fromEnvironment('BUILD_TYPE');
  switch (envBuildType.toLowerCase()) {
    case 'store':
      return BuildType.store;
    case 'staging':
      return BuildType.staging;
    case 'development':
      return BuildType.development;
    case 'local':
    default:
      return BuildType.local;
  }
}
