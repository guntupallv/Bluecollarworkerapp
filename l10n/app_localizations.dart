import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('te')
  ];

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select Role'**
  String get selectRole;

  /// No description provided for @worker.
  ///
  /// In en, this message translates to:
  /// **'Worker'**
  String get worker;

  /// No description provided for @employer.
  ///
  /// In en, this message translates to:
  /// **'Employer'**
  String get employer;

  /// No description provided for @workerDashboard.
  ///
  /// In en, this message translates to:
  /// **'Worker Dashboard'**
  String get workerDashboard;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogout;

  /// No description provided for @logoutPrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutPrompt;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @nearbyJobs.
  ///
  /// In en, this message translates to:
  /// **'Nearby Jobs'**
  String get nearbyJobs;

  /// No description provided for @electricianJobTitle.
  ///
  /// In en, this message translates to:
  /// **'Electrician Needed'**
  String get electricianJobTitle;

  /// No description provided for @electricianJobSubtitle.
  ///
  /// In en, this message translates to:
  /// **'₹300/hour • Rajahmundry'**
  String get electricianJobSubtitle;

  /// No description provided for @jobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get jobs;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Local Job Finder'**
  String get appTitle;

  /// No description provided for @youAreSigningInAs.
  ///
  /// In en, this message translates to:
  /// **'You are signing in as:'**
  String get youAreSigningInAs;

  /// No description provided for @loginWithPhone.
  ///
  /// In en, this message translates to:
  /// **'Login with Phone'**
  String get loginWithPhone;

  /// No description provided for @labelPhoneExample.
  ///
  /// In en, this message translates to:
  /// **'Phone (e.g., +9198xxxxxx)'**
  String get labelPhoneExample;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @verifyAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Verify & Continue'**
  String get verifyAndContinue;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit OTP'**
  String get enterOtp;

  /// No description provided for @otpResent.
  ///
  /// In en, this message translates to:
  /// **'OTP re-sent'**
  String get otpResent;

  /// No description provided for @errUserNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'User not logged in.'**
  String get errUserNotLoggedIn;

  /// No description provided for @errPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone required'**
  String get errPhoneRequired;

  /// No description provided for @errPhoneCountryCode.
  ///
  /// In en, this message translates to:
  /// **'Include country code, e.g. +91...'**
  String get errPhoneCountryCode;

  /// No description provided for @errPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter valid phone number'**
  String get errPhoneInvalid;

  /// No description provided for @errOtpSixDigits.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get errOtpSixDigits;

  /// No description provided for @errAutoSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Auto sign-in failed: {error}'**
  String errAutoSignInFailed(String error);

  /// No description provided for @errRoleLocked.
  ///
  /// In en, this message translates to:
  /// **'You have already signed in as {role}. Role change not allowed.'**
  String errRoleLocked(String role);

  /// No description provided for @errGeneric.
  ///
  /// In en, this message translates to:
  /// **'{error}'**
  String errGeneric(String error);

  /// No description provided for @verifyPhone.
  ///
  /// In en, this message translates to:
  /// **'Verify {phone}'**
  String verifyPhone(String phone);

  /// No description provided for @jobNotifications.
  ///
  /// In en, this message translates to:
  /// **'Job Notifications'**
  String get jobNotifications;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @jobApplications.
  ///
  /// In en, this message translates to:
  /// **'Job Applications'**
  String get jobApplications;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @searchByTitleOrCategory.
  ///
  /// In en, this message translates to:
  /// **'Search by title or category'**
  String get searchByTitleOrCategory;

  /// No description provided for @rateType.
  ///
  /// In en, this message translates to:
  /// **'Rate Type'**
  String get rateType;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort:'**
  String get sort;

  /// No description provided for @sortClosest.
  ///
  /// In en, this message translates to:
  /// **'Closest'**
  String get sortClosest;

  /// No description provided for @sortHighestPay.
  ///
  /// In en, this message translates to:
  /// **'Highest Pay'**
  String get sortHighestPay;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortNewest;

  /// No description provided for @noJobsFoundMatching.
  ///
  /// In en, this message translates to:
  /// **'No jobs found matching filters.'**
  String get noJobsFoundMatching;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Location permission required to show nearby jobs.'**
  String get locationPermissionRequired;

  /// No description provided for @rateAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get rateAny;

  /// No description provided for @ratePerHour.
  ///
  /// In en, this message translates to:
  /// **'Per Hour'**
  String get ratePerHour;

  /// No description provided for @ratePerDay.
  ///
  /// In en, this message translates to:
  /// **'Per Day'**
  String get ratePerDay;

  /// No description provided for @ratePerWeek.
  ///
  /// In en, this message translates to:
  /// **'Per Week'**
  String get ratePerWeek;

  /// No description provided for @ratePerMonth.
  ///
  /// In en, this message translates to:
  /// **'Per Month'**
  String get ratePerMonth;

  /// No description provided for @myApplications.
  ///
  /// In en, this message translates to:
  /// **'My Applications'**
  String get myApplications;

  /// No description provided for @noApplicationsFound.
  ///
  /// In en, this message translates to:
  /// **'No applications found.'**
  String get noApplicationsFound;

  /// No description provided for @loadingJob.
  ///
  /// In en, this message translates to:
  /// **'Loading job...'**
  String get loadingJob;

  /// No description provided for @jobDetails.
  ///
  /// In en, this message translates to:
  /// **'Job Details'**
  String get jobDetails;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @timing.
  ///
  /// In en, this message translates to:
  /// **'Timing'**
  String get timing;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @applyNow.
  ///
  /// In en, this message translates to:
  /// **'Apply Now'**
  String get applyNow;

  /// No description provided for @alreadyApplied.
  ///
  /// In en, this message translates to:
  /// **'Already Applied'**
  String get alreadyApplied;

  /// No description provided for @applicationSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Application submitted'**
  String get applicationSubmitted;

  /// No description provided for @failedToLaunchDialer.
  ///
  /// In en, this message translates to:
  /// **'Failed to launch dialer'**
  String get failedToLaunchDialer;

  /// No description provided for @cannotLaunchDialer.
  ///
  /// In en, this message translates to:
  /// **'Cannot launch dialer: No app found'**
  String get cannotLaunchDialer;

  /// No description provided for @callEmployer.
  ///
  /// In en, this message translates to:
  /// **'Call Employer'**
  String get callEmployer;

  /// No description provided for @noNewJobsInArea.
  ///
  /// In en, this message translates to:
  /// **'No new jobs in your area.'**
  String get noNewJobsInArea;

  /// No description provided for @markAsSeen.
  ///
  /// In en, this message translates to:
  /// **'Mark as seen'**
  String get markAsSeen;

  /// No description provided for @profileInformation.
  ///
  /// In en, this message translates to:
  /// **'Profile Information'**
  String get profileInformation;

  /// No description provided for @noProfileDataFound.
  ///
  /// In en, this message translates to:
  /// **'No profile data found.'**
  String get noProfileDataFound;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @skills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skills;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @expectedRate.
  ///
  /// In en, this message translates to:
  /// **'Expected Rate'**
  String get expectedRate;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @availableNow.
  ///
  /// In en, this message translates to:
  /// **'Available Now'**
  String get availableNow;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @idVerification.
  ///
  /// In en, this message translates to:
  /// **'ID Verification'**
  String get idVerification;

  /// No description provided for @verificationStatus.
  ///
  /// In en, this message translates to:
  /// **'Verification Status'**
  String get verificationStatus;

  /// No description provided for @noIdProofUploaded.
  ///
  /// In en, this message translates to:
  /// **'No ID proof uploaded.'**
  String get noIdProofUploaded;

  /// No description provided for @setupWorkerProfile.
  ///
  /// In en, this message translates to:
  /// **'Setup Worker Profile'**
  String get setupWorkerProfile;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @skillsCommaSeparated.
  ///
  /// In en, this message translates to:
  /// **'Skills (comma-separated)'**
  String get skillsCommaSeparated;

  /// No description provided for @experienceYears.
  ///
  /// In en, this message translates to:
  /// **'Experience (years)'**
  String get experienceYears;

  /// No description provided for @expectedRateAmount.
  ///
  /// In en, this message translates to:
  /// **'Expected Rate'**
  String get expectedRateAmount;

  /// No description provided for @uploadIdCameraGallery.
  ///
  /// In en, this message translates to:
  /// **'Upload ID (Camera / Gallery)'**
  String get uploadIdCameraGallery;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get takePhoto;

  /// No description provided for @removeSelected.
  ///
  /// In en, this message translates to:
  /// **'Remove Selected'**
  String get removeSelected;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get saveProfile;

  /// No description provided for @profileSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile saved successfully'**
  String get profileSavedSuccessfully;

  /// No description provided for @errorSavingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error saving profile: {error}'**
  String errorSavingProfile(String error);

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @noTitle.
  ///
  /// In en, this message translates to:
  /// **'No Title'**
  String get noTitle;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No Description'**
  String get noDescription;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @notProvided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get notProvided;

  /// No description provided for @notMentioned.
  ///
  /// In en, this message translates to:
  /// **'Not Mentioned'**
  String get notMentioned;

  /// No description provided for @noAddress.
  ///
  /// In en, this message translates to:
  /// **'No Address'**
  String get noAddress;

  /// No description provided for @perHour.
  ///
  /// In en, this message translates to:
  /// **'Per Hour'**
  String get perHour;

  /// No description provided for @perDay.
  ///
  /// In en, this message translates to:
  /// **'Per Day'**
  String get perDay;

  /// No description provided for @perWeek.
  ///
  /// In en, this message translates to:
  /// **'Per Week'**
  String get perWeek;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'Per Month'**
  String get perMonth;

  /// No description provided for @applicantsForJob.
  ///
  /// In en, this message translates to:
  /// **'Applicants for \"{jobTitle}\"'**
  String applicantsForJob(String jobTitle);

  /// No description provided for @noApplicantsYet.
  ///
  /// In en, this message translates to:
  /// **'No applicants yet.'**
  String get noApplicantsYet;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @workerProfileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Worker profile not found.'**
  String get workerProfileNotFound;

  /// No description provided for @unableToOpenDialer.
  ///
  /// In en, this message translates to:
  /// **'Unable to open dialer'**
  String get unableToOpenDialer;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @noAddressAvailable.
  ///
  /// In en, this message translates to:
  /// **'No address available'**
  String get noAddressAvailable;

  /// No description provided for @idProof.
  ///
  /// In en, this message translates to:
  /// **'ID Proof'**
  String get idProof;

  /// No description provided for @ratingsAndReviews.
  ///
  /// In en, this message translates to:
  /// **'Ratings & Reviews'**
  String get ratingsAndReviews;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet.'**
  String get noReviewsYet;

  /// No description provided for @averageRating.
  ///
  /// In en, this message translates to:
  /// **'⭐ Average Rating: {rating} ({count} reviews)'**
  String averageRating(String rating, int count);

  /// No description provided for @rateWorker.
  ///
  /// In en, this message translates to:
  /// **'Rate Worker'**
  String get rateWorker;

  /// No description provided for @ratingLabel.
  ///
  /// In en, this message translates to:
  /// **'Rating (1.0 - 5.0)'**
  String get ratingLabel;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @enterValidRating.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid rating (1.0 to 5.0)'**
  String get enterValidRating;

  /// No description provided for @reviewSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Review submitted'**
  String get reviewSubmitted;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'PENDING'**
  String get pending;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'ACCEPTED'**
  String get accepted;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'REJECTED'**
  String get rejected;

  /// No description provided for @rateWorkerButton.
  ///
  /// In en, this message translates to:
  /// **'Rate Worker'**
  String get rateWorkerButton;

  /// No description provided for @unnamed.
  ///
  /// In en, this message translates to:
  /// **'Unnamed'**
  String get unnamed;

  /// No description provided for @skillsLabel.
  ///
  /// In en, this message translates to:
  /// **'Skills: {skills}'**
  String skillsLabel(String skills);

  /// No description provided for @experienceLabel.
  ///
  /// In en, this message translates to:
  /// **'Experience: {experience} yrs'**
  String experienceLabel(int experience);

  /// No description provided for @employerDashboard.
  ///
  /// In en, this message translates to:
  /// **'Employer Dashboard'**
  String get employerDashboard;

  /// No description provided for @favoriteWorkers.
  ///
  /// In en, this message translates to:
  /// **'Favorite Workers'**
  String get favoriteWorkers;

  /// No description provided for @employerProfile.
  ///
  /// In en, this message translates to:
  /// **'Employer Profile'**
  String get employerProfile;

  /// No description provided for @yourJobPosts.
  ///
  /// In en, this message translates to:
  /// **'Your Job Posts'**
  String get yourJobPosts;

  /// No description provided for @noJobPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No job posts yet.'**
  String get noJobPostsYet;

  /// No description provided for @posted.
  ///
  /// In en, this message translates to:
  /// **'Posted: {date}'**
  String posted(String date);

  /// No description provided for @untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get untitled;

  /// No description provided for @postJob.
  ///
  /// In en, this message translates to:
  /// **'Post Job'**
  String get postJob;

  /// No description provided for @nearbyWorkers.
  ///
  /// In en, this message translates to:
  /// **'Nearby Workers'**
  String get nearbyWorkers;

  /// No description provided for @postAJob.
  ///
  /// In en, this message translates to:
  /// **'Post a Job'**
  String get postAJob;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get jobTitle;

  /// No description provided for @jobCategory.
  ///
  /// In en, this message translates to:
  /// **'Job Category'**
  String get jobCategory;

  /// No description provided for @contactMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact Mobile Number(+91 or +44)'**
  String get contactMobileNumber;

  /// No description provided for @jobTiming.
  ///
  /// In en, this message translates to:
  /// **'Job Timing:'**
  String get jobTiming;

  /// No description provided for @jobDescription.
  ///
  /// In en, this message translates to:
  /// **'Job Description'**
  String get jobDescription;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields and set job timing'**
  String get pleaseFillAllFields;

  /// No description provided for @jobPostedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Job posted successfully!'**
  String get jobPostedSuccessfully;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error(String message);

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not Set'**
  String get notSet;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @fetchingCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Fetching current location...'**
  String get fetchingCurrentLocation;

  /// No description provided for @locationFetchFailed.
  ///
  /// In en, this message translates to:
  /// **'Location fetch failed'**
  String get locationFetchFailed;

  /// No description provided for @businessType.
  ///
  /// In en, this message translates to:
  /// **'Business Type'**
  String get businessType;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @setupEmployerProfile.
  ///
  /// In en, this message translates to:
  /// **'Setup Employer Profile'**
  String get setupEmployerProfile;

  /// No description provided for @companyNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Company Name (optional)'**
  String get companyNameOptional;

  /// No description provided for @employerProfileSaved.
  ///
  /// In en, this message translates to:
  /// **'Employer profile saved'**
  String get employerProfileSaved;

  /// No description provided for @errorSavingEmployerProfile.
  ///
  /// In en, this message translates to:
  /// **'Error saving profile: {error}'**
  String errorSavingEmployerProfile(String error);

  /// No description provided for @noName.
  ///
  /// In en, this message translates to:
  /// **'No Name'**
  String get noName;

  /// No description provided for @notVerified.
  ///
  /// In en, this message translates to:
  /// **'Not Verified'**
  String get notVerified;

  /// No description provided for @rateTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Rate Type: {rateType}'**
  String rateTypeLabel(String rateType);

  /// No description provided for @expectedRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Expected Rate: {rate}'**
  String expectedRateLabel(String rate);

  /// No description provided for @availableNowLabel.
  ///
  /// In en, this message translates to:
  /// **'Available Now: {available}'**
  String availableNowLabel(String available);

  /// No description provided for @tapImageToViewFullSize.
  ///
  /// In en, this message translates to:
  /// **'Tap image to view full size'**
  String get tapImageToViewFullSize;

  /// No description provided for @noIdUploaded.
  ///
  /// In en, this message translates to:
  /// **'No ID uploaded.'**
  String get noIdUploaded;

  /// No description provided for @noFavoriteWorkers.
  ///
  /// In en, this message translates to:
  /// **'No favorite workers.'**
  String get noFavoriteWorkers;

  /// No description provided for @searchBySkills.
  ///
  /// In en, this message translates to:
  /// **'Search by Skills (comma separated)'**
  String get searchBySkills;

  /// No description provided for @noWorkersFoundNearby.
  ///
  /// In en, this message translates to:
  /// **'No workers found nearby.'**
  String get noWorkersFoundNearby;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @viewId.
  ///
  /// In en, this message translates to:
  /// **'View ID'**
  String get viewId;

  /// No description provided for @unfavorite.
  ///
  /// In en, this message translates to:
  /// **'Unfavorite'**
  String get unfavorite;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @deleteJob.
  ///
  /// In en, this message translates to:
  /// **'Delete Job'**
  String get deleteJob;

  /// No description provided for @deleteJobConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this job post?'**
  String get deleteJobConfirmation;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @jobDeleted.
  ///
  /// In en, this message translates to:
  /// **'Job deleted'**
  String get jobDeleted;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @jobNotFound.
  ///
  /// In en, this message translates to:
  /// **'Job not found'**
  String get jobNotFound;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @jobTimings.
  ///
  /// In en, this message translates to:
  /// **'Job Timings'**
  String get jobTimings;

  /// No description provided for @noTimingsMentioned.
  ///
  /// In en, this message translates to:
  /// **'No Timings Mentioned'**
  String get noTimingsMentioned;

  /// No description provided for @contactNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get contactNumber;

  /// No description provided for @noDescriptionProvided.
  ///
  /// In en, this message translates to:
  /// **'No description provided.'**
  String get noDescriptionProvided;

  /// No description provided for @postedAt.
  ///
  /// In en, this message translates to:
  /// **'Posted at: {date}'**
  String postedAt(String date);

  /// No description provided for @viewApplicants.
  ///
  /// In en, this message translates to:
  /// **'View Applicants'**
  String get viewApplicants;

  /// No description provided for @untitledJob.
  ///
  /// In en, this message translates to:
  /// **'Untitled Job'**
  String get untitledJob;

  /// No description provided for @editJob.
  ///
  /// In en, this message translates to:
  /// **'Edit Job'**
  String get editJob;

  /// No description provided for @pleaseCompleteAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please complete all fields and job timing'**
  String get pleaseCompleteAllFields;

  /// No description provided for @jobUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Job updated successfully!'**
  String get jobUpdatedSuccessfully;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update failed: {error}'**
  String updateFailed(String error);

  /// No description provided for @contactMobile.
  ///
  /// In en, this message translates to:
  /// **'Contact Mobile'**
  String get contactMobile;

  /// No description provided for @updateJob.
  ///
  /// In en, this message translates to:
  /// **'Update Job'**
  String get updateJob;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
    case 'te': return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
