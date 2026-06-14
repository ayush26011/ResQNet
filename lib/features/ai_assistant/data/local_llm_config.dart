class LocalLlmConfig {
  final String modelFileName;
  final String modelDisplayName;
  final int contextSize;
  final int maxTokens;
  final double temperature;
  final double topP;
  final List<String> supportedPlatforms;

  const LocalLlmConfig({
    required this.modelFileName,
    required this.modelDisplayName,
    this.contextSize = 2048,
    this.maxTokens = 256,
    this.temperature = 0.7,
    this.topP = 0.9,
    this.supportedPlatforms = const ['android', 'ios', 'macos', 'windows', 'linux'],
  });
}
