// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome => 'Welcome';

  @override
  String get login => 'Login';

  @override
  String get selectRole => 'Select Role';

  @override
  String get worker => 'Worker';

  @override
  String get employer => 'Employer';

  @override
  String get workerDashboard => 'Worker Dashboard';

  @override
  String get confirmLogout => 'Confirm Logout';

  @override
  String get logoutPrompt => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get logout => 'Logout';

  @override
  String get nearbyJobs => 'Nearby Jobs';

  @override
  String get electricianJobTitle => 'Electrician Needed';

  @override
  String get electricianJobSubtitle => '₹300/hour • Rajahmundry';

  @override
  String get jobs => 'Jobs';

  @override
  String get profile => 'Profile';

  @override
  String get appTitle => 'Local Job Finder';

  @override
  String get youAreSigningInAs => 'You are signing in as:';

  @override
  String get loginWithPhone => 'Login with Phone';

  @override
  String get labelPhoneExample => 'Phone (e.g., +9198xxxxxx)';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get verifyAndContinue => 'Verify & Continue';

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get enterOtp => 'Enter 6-digit OTP';

  @override
  String get otpResent => 'OTP re-sent';

  @override
  String get errUserNotLoggedIn => 'User not logged in.';

  @override
  String get errPhoneRequired => 'Phone required';

  @override
  String get errPhoneCountryCode => 'Include country code, e.g. +91...';

  @override
  String get errPhoneInvalid => 'Enter valid phone number';

  @override
  String get errOtpSixDigits => 'Enter the 6-digit code';

  @override
  String errAutoSignInFailed(String error) {
    return 'Auto sign-in failed: $error';
  }

  @override
  String errRoleLocked(String role) {
    return 'You have already signed in as $role. Role change not allowed.';
  }

  @override
  String errGeneric(String error) {
    return '$error';
  }

  @override
  String verifyPhone(String phone) {
    return 'Verify $phone';
  }

  @override
  String get jobNotifications => 'Job Notifications';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get jobApplications => 'Job Applications';

  @override
  String get alerts => 'Alerts';

  @override
  String get searchByTitleOrCategory => 'Search by title or category';

  @override
  String get rateType => 'Rate Type';

  @override
  String get sort => 'Sort:';

  @override
  String get sortClosest => 'Closest';

  @override
  String get sortHighestPay => 'Highest Pay';

  @override
  String get sortNewest => 'Newest';

  @override
  String get noJobsFoundMatching => 'No jobs found matching filters.';

  @override
  String get locationPermissionRequired => 'Location permission required to show nearby jobs.';

  @override
  String get rateAny => 'Any';

  @override
  String get ratePerHour => 'Per Hour';

  @override
  String get ratePerDay => 'Per Day';

  @override
  String get ratePerWeek => 'Per Week';

  @override
  String get ratePerMonth => 'Per Month';

  @override
  String get myApplications => 'My Applications';

  @override
  String get noApplicationsFound => 'No applications found.';

  @override
  String get loadingJob => 'Loading job...';

  @override
  String get jobDetails => 'Job Details';

  @override
  String get location => 'Location';

  @override
  String get category => 'Category';

  @override
  String get rate => 'Rate';

  @override
  String get timing => 'Timing';

  @override
  String get contact => 'Contact';

  @override
  String get description => 'Description';

  @override
  String get status => 'Status';

  @override
  String get close => 'Close';

  @override
  String get applyNow => 'Apply Now';

  @override
  String get alreadyApplied => 'Already Applied';

  @override
  String get applicationSubmitted => 'Application submitted';

  @override
  String get failedToLaunchDialer => 'Failed to launch dialer';

  @override
  String get cannotLaunchDialer => 'Cannot launch dialer: No app found';

  @override
  String get callEmployer => 'Call Employer';

  @override
  String get noNewJobsInArea => 'No new jobs in your area.';

  @override
  String get markAsSeen => 'Mark as seen';

  @override
  String get profileInformation => 'Profile Information';

  @override
  String get noProfileDataFound => 'No profile data found.';

  @override
  String get name => 'Name';

  @override
  String get skills => 'Skills';

  @override
  String get experience => 'Experience';

  @override
  String get years => 'years';

  @override
  String get expectedRate => 'Expected Rate';

  @override
  String get mobileNumber => 'Mobile Number';

  @override
  String get address => 'Address';

  @override
  String get availableNow => 'Available Now';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get idVerification => 'ID Verification';

  @override
  String get verificationStatus => 'Verification Status';

  @override
  String get noIdProofUploaded => 'No ID proof uploaded.';

  @override
  String get setupWorkerProfile => 'Setup Worker Profile';

  @override
  String get fullName => 'Full Name';

  @override
  String get skillsCommaSeparated => 'Skills (comma-separated)';

  @override
  String get experienceYears => 'Experience (years)';

  @override
  String get expectedRateAmount => 'Expected Rate';

  @override
  String get uploadIdCameraGallery => 'Upload ID (Camera / Gallery)';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get takePhoto => 'Take a Photo';

  @override
  String get removeSelected => 'Remove Selected';

  @override
  String get saveProfile => 'Save Profile';

  @override
  String get profileSavedSuccessfully => 'Profile saved successfully';

  @override
  String errorSavingProfile(String error) {
    return 'Error saving profile: $error';
  }

  @override
  String get required => 'Required';

  @override
  String get noTitle => 'No Title';

  @override
  String get noDescription => 'No Description';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get notProvided => 'Not provided';

  @override
  String get notMentioned => 'Not Mentioned';

  @override
  String get noAddress => 'No Address';

  @override
  String get perHour => 'Per Hour';

  @override
  String get perDay => 'Per Day';

  @override
  String get perWeek => 'Per Week';

  @override
  String get perMonth => 'Per Month';

  @override
  String applicantsForJob(String jobTitle) {
    return 'Applicants for \"$jobTitle\"';
  }

  @override
  String get noApplicantsYet => 'No applicants yet.';

  @override
  String get loading => 'Loading...';

  @override
  String get workerProfileNotFound => 'Worker profile not found.';

  @override
  String get unableToOpenDialer => 'Unable to open dialer';

  @override
  String get verified => 'Verified';

  @override
  String get noAddressAvailable => 'No address available';

  @override
  String get idProof => 'ID Proof';

  @override
  String get ratingsAndReviews => 'Ratings & Reviews';

  @override
  String get noReviewsYet => 'No reviews yet.';

  @override
  String averageRating(String rating, int count) {
    return '⭐ Average Rating: $rating ($count reviews)';
  }

  @override
  String get rateWorker => 'Rate Worker';

  @override
  String get ratingLabel => 'Rating (1.0 - 5.0)';

  @override
  String get comment => 'Comment';

  @override
  String get submit => 'Submit';

  @override
  String get enterValidRating => 'Enter a valid rating (1.0 to 5.0)';

  @override
  String get reviewSubmitted => 'Review submitted';

  @override
  String get accept => 'Accept';

  @override
  String get reject => 'Reject';

  @override
  String get pending => 'PENDING';

  @override
  String get accepted => 'ACCEPTED';

  @override
  String get rejected => 'REJECTED';

  @override
  String get rateWorkerButton => 'Rate Worker';

  @override
  String get unnamed => 'Unnamed';

  @override
  String skillsLabel(String skills) {
    return 'Skills: $skills';
  }

  @override
  String experienceLabel(int experience) {
    return 'Experience: $experience yrs';
  }

  @override
  String get employerDashboard => 'Employer Dashboard';

  @override
  String get favoriteWorkers => 'Favorite Workers';

  @override
  String get employerProfile => 'Employer Profile';

  @override
  String get yourJobPosts => 'Your Job Posts';

  @override
  String get noJobPostsYet => 'No job posts yet.';

  @override
  String posted(String date) {
    return 'Posted: $date';
  }

  @override
  String get untitled => 'Untitled';

  @override
  String get postJob => 'Post Job';

  @override
  String get nearbyWorkers => 'Nearby Workers';

  @override
  String get postAJob => 'Post a Job';

  @override
  String get jobTitle => 'Job Title';

  @override
  String get jobCategory => 'Job Category';

  @override
  String get contactMobileNumber => 'Contact Mobile Number(+91 or +44)';

  @override
  String get jobTiming => 'Job Timing:';

  @override
  String get jobDescription => 'Job Description';

  @override
  String get pleaseFillAllFields => 'Please fill all fields and set job timing';

  @override
  String get jobPostedSuccessfully => 'Job posted successfully!';

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String get notSet => 'Not Set';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get fetchingCurrentLocation => 'Fetching current location...';

  @override
  String get locationFetchFailed => 'Location fetch failed';

  @override
  String get businessType => 'Business Type';

  @override
  String get company => 'Company';

  @override
  String get setupEmployerProfile => 'Setup Employer Profile';

  @override
  String get companyNameOptional => 'Company Name (optional)';

  @override
  String get employerProfileSaved => 'Employer profile saved';

  @override
  String errorSavingEmployerProfile(String error) {
    return 'Error saving profile: $error';
  }

  @override
  String get noName => 'No Name';

  @override
  String get notVerified => 'Not Verified';

  @override
  String rateTypeLabel(String rateType) {
    return 'Rate Type: $rateType';
  }

  @override
  String expectedRateLabel(String rate) {
    return 'Expected Rate: $rate';
  }

  @override
  String availableNowLabel(String available) {
    return 'Available Now: $available';
  }

  @override
  String get tapImageToViewFullSize => 'Tap image to view full size';

  @override
  String get noIdUploaded => 'No ID uploaded.';

  @override
  String get noFavoriteWorkers => 'No favorite workers.';

  @override
  String get searchBySkills => 'Search by Skills (comma separated)';

  @override
  String get noWorkersFoundNearby => 'No workers found nearby.';

  @override
  String get mobile => 'Mobile';

  @override
  String get viewId => 'View ID';

  @override
  String get unfavorite => 'Unfavorite';

  @override
  String get favorite => 'Favorite';

  @override
  String get deleteJob => 'Delete Job';

  @override
  String get deleteJobConfirmation => 'Are you sure you want to delete this job post?';

  @override
  String get delete => 'Delete';

  @override
  String get jobDeleted => 'Job deleted';

  @override
  String get edit => 'Edit';

  @override
  String get jobNotFound => 'Job not found';

  @override
  String get title => 'Title';

  @override
  String get jobTimings => 'Job Timings';

  @override
  String get noTimingsMentioned => 'No Timings Mentioned';

  @override
  String get contactNumber => 'Contact Number';

  @override
  String get noDescriptionProvided => 'No description provided.';

  @override
  String postedAt(String date) {
    return 'Posted at: $date';
  }

  @override
  String get viewApplicants => 'View Applicants';

  @override
  String get untitledJob => 'Untitled Job';

  @override
  String get editJob => 'Edit Job';

  @override
  String get pleaseCompleteAllFields => 'Please complete all fields and job timing';

  @override
  String get jobUpdatedSuccessfully => 'Job updated successfully!';

  @override
  String updateFailed(String error) {
    return 'Update failed: $error';
  }

  @override
  String get contactMobile => 'Contact Mobile';

  @override
  String get updateJob => 'Update Job';
}
