class AppEndpoints {
  //
  //Auth endpoints
  static const String register = 'auth/register';
  static const String login = 'auth/login';
  static const String refresh = 'auth/refresh-token';

  // User endpoints
  static const String myProfile = 'users/me';
  static const String updateMyProfile = 'users/me';
  static const String deleteMyProfile = 'users/me';
  static const String uploadMyProfilePicture = 'users/upload-profile-picture';
  static const String forgotPassword = 'users/forgot-password';

  // Service Endpoints
  static const String createService = "services/create-service";
  static const String allService = "services/all-services";
  static const String singleService = "services/single-service";
  static const String updateService = "services/update-service";
  static const String deleteService = "services/delete-service";
  

  // Booking
  static const String createBooking = "bookings/create-booking";
  static const String allBookings = "bookings/all-booking";
  static const String singleBooking = "bookings/single-booking";
  static const String userBooking = "bookings/user-booking";
  static const String updateBooking = "bookings/update-booking";
  static const String changeBookingStatus = "bookings/update-booking-status";
  static const String deleteBooking = "bookings/delete-booking";

  // Conversation
  static const String createConversation = "conversations/create-conversation";
  static const String singleConversation = "conversations/single-conversation";
  static const String myConversation = "conversations/user-conversation";

  // Message
  static const String createMessage = "messages/send-message";
  static const String userMessages = "messages/user-message";

  // Review

  static const String reviewClient = "reviews/review-client/client";
  static const String reviewProvider = "reviews/review-provider/provider";
  static const String clientReviews = "reviews/client-review/client";
  static const String providerReviews = "reviews/provider-review/provider";


  // File Upload
  static const String uploadServiceImage = "file/upload-service-image";
  static const String uploadProfileImage = "file/upload-profile-picture";
  
}
