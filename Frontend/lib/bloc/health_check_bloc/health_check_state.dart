part of 'health_check_bloc.dart';

class HealthCheckState {
  final HealthCheck? healthCheckResults;
  // final html.Blob? healthCheckResults;
  // final HealthCheck? lastHealthCheckResults;
  final bool isLoading;

  // HealthCheckState({this.healthCheckResults, this.lastHealthCheckResults, this.isLoading = false});
  HealthCheckState({this.healthCheckResults, this.isLoading = false});

  HealthCheckState copyWith({
    HealthCheck? healthCheckResults,
    bool isLoading = false,
  }) {
    return HealthCheckState(
        healthCheckResults: healthCheckResults ?? this.healthCheckResults,
        isLoading: isLoading);
  }
}