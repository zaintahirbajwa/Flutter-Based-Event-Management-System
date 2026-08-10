class AppConstants {
  // App-related constants
  static const String appName = "Event Management System";
  static const String eventRegistrationTitle = "Events Registration";
  static const String eventRegistered = "Event registered successfully!";
  static const String registerEventButtonText = "Register Event";

  // Login Page Constants
  static const String loginTitle = "Login to Your Account";
  static const String loginButtonText = "Login"; // Added
  static const String forgotPasswordText = "Forgot Password?"; // Added
  static const String registerText = "Don't have an account? Register here";
  static const String eventNameLabel = "Event Name";
  static const String eventNameError = "Please enter a valid event name.";

  // Settings Page Constants
  static const String settingsTitle = "Settings";
  static const String darkModeLabel = "Dark Mode";
  static const String languageSelectionLabel = "Select Language";

  // Event-related Constants
  static const String eventTitle = "Event Title";
  static const String eventDate = "Event Date";
  static const String eventTime = "Event Time";
  static const String eventLocation = "Event Location";
  static const String eventDescription = "Event Description";
  static const String eventDateFutureError =
      "Event date must be in the future."; // New constant for date validation error

  static const String eventDateLabel =
      "Event Date"; // Added for user schedule screen
  static const String eventDescriptionLabel =
      "Event Description"; // Added for event details
  static const String eventDescriptionError =
      "Please enter a valid description."; // Newly added

  // Ticketing Page Constants
  static const String ticketTitle = "Ticket Title";
  static const String ticketPrice = "Ticket Price";
  static const String ticketQuantity = "Ticket Quantity";
  static const String ticketQuantityLabel = "Tickets Quantity"; // Newly added
  static const String ticketBookedLabel =
      "Tickets Booked"; // Added for user schedule screen

  // Schedule Page Constants
  static const String userScheduleTitle = "My Schedule"; // Added
  static const String noTicketsBooked =
      "You have not booked any tickets yet."; // Added
  static const String eventScheduleTitle = "Events Schedule"; // Newly added
  static const String noEventsScheduled =
      "No events are scheduled for your account."; // Newly added

  // Ticketing Screen Constants
  static const String ticketingTitle = "Ticketing"; // Added
  static const String noEventsAvailable = "No events available"; // Added
  static const String buyTicketButton = "Buy Ticket"; // Added
  static const String ticketPurchaseError =
      "Error purchasing ticket. Please try again."; // Added

  // Event Details Page Constants
  static const String eventDetailsTitle = "Event Details"; // Newly added

  // Admin Ticketing Screen Constants
  static const String adminTicketingTitle =
      "Admin Ticketing"; // Added for admin ticketing screen
  static const String ticketAvailableLabel = "Tickets Available"; // Added
  static const String ticketSoldLabel = "Tickets Sold"; // Added
  static const String ticketManagementTitle =
      "Ticket Management"; // Added for ticket management
  static const String soldTicketsLabel =
      "Sold Tickets"; // Added for displaying sold tickets
  static const String updateTicketButton =
      "Update Ticket"; // Added for updating ticket details

  // Error/Validation Messages
  static const String emptyFieldError = "This field cannot be empty.";
  static const String invalidEmailError = "Please enter a valid email address.";
  static const String passwordMismatchError = "Passwords do not match.";
  static const String loginError = "Invalid username or password.";
  static const String usernameError = "Please enter a valid username."; // Added
  static const String passwordError = "Please enter a valid password."; // Added
  static const String ticketQuantityError =
      "Please select a valid ticket quantity."; // Added for event details dialog

  // Labels
  static const String usernameLabel = "Username";
  static const String passwordLabel = "Password";
  static const String confirmPasswordLabel = "Confirm Password";
  static const String emailLabel = "Email Address";
  static const String phoneLabel = "Phone Number";
  static const String fullNameLabel = "Full Name";

  // Theme-related Constants
  static const double defaultPadding = 16.0;
  static const double borderRadius = 12.0;

  // Font Constants
  static const String primaryFont = "Poppins"; // Define your primary font
  static const String secondaryFont = "Roboto";

  // API URLs (if any, for now it's placeholders)
  static const String apiBaseUrl = "https://api.example.com/";
  static const String fetchEventsUrl = "${apiBaseUrl}events";
  static const String registerEventUrl = "${apiBaseUrl}events/register";

  // Success Messages
  static const String eventRegistrationSuccess =
      "Event successfully registered!";
  static const String ticketPurchaseSuccess = "Ticket successfully purchased!";

  // Auth Constants (Add these for login functionality)
  static const String isLoggedInKey = "isLoggedIn";
  static const String usernameKey = "username";
  static const String passwordKey = "password";

  // Getter for eventDateError
  static String get eventDateError => "Please select a valid event date.";

  // New Constants Added for Events Screen
  static const String viewEventsTitle =
      "View Events"; // Added for events screen
  static const String closeButton = "Close";
}
