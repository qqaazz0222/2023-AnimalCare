part of 'health_check_bloc.dart';

class HealthCheckState {
  final HealthCheck? healthCheckResults;
  final HealthCheck? lastHealthCheckResults;
  final bool isLoading;

  HealthCheckState({this.healthCheckResults, this.lastHealthCheckResults, this.isLoading = false});

  HealthCheckState copyWith({
    HealthCheck? healthCheckResults,
    HealthCheck? lastHealthCheckResults,
    bool isLoading = false,
  }) {
    return HealthCheckState(
        healthCheckResults: healthCheckResults ?? this.healthCheckResults,
        lastHealthCheckResults: lastHealthCheckResults ?? this.lastHealthCheckResults,
        isLoading: isLoading);
  }
}