class CreateBookingRequest {
  final String serviceId;
  final String providerId;

  CreateBookingRequest({required this.serviceId, required this.providerId});
  Map<String, dynamic> toJson() {
    return {"service_id": serviceId, "provider_id": providerId};
  }
}
