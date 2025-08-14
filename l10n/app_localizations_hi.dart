// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get welcome => 'स्वागत है';

  @override
  String get login => 'लॉगिन';

  @override
  String get selectRole => 'भूमिका चुनें';

  @override
  String get worker => 'कामगार';

  @override
  String get employer => 'नियोक्ता';

  @override
  String get workerDashboard => 'कामगार डैशबोर्ड';

  @override
  String get confirmLogout => 'लॉगआउट की पुष्टि करें';

  @override
  String get logoutPrompt => 'क्या आप वाकई लॉगआउट करना चाहते हैं?';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get nearbyJobs => 'नज़दीकी नौकरियां';

  @override
  String get electricianJobTitle => 'इलेक्ट्रीशियन की आवश्यकता';

  @override
  String get electricianJobSubtitle => '₹300/घंटा • राजमुंद्री';

  @override
  String get jobs => 'नौकरियां';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get appTitle => 'लोकल जॉब फाइंडर';

  @override
  String get youAreSigningInAs => 'आप इस रूप में साइन इन कर रहे हैं:';

  @override
  String get loginWithPhone => 'फोन से लॉगिन करें';

  @override
  String get labelPhoneExample => 'फ़ोन (जैसे, +9198xxxxxx)';

  @override
  String get sendOtp => 'OTP भेजें';

  @override
  String get verifyAndContinue => 'सत्यापित करें और जारी रखें';

  @override
  String get resendOtp => 'OTP दोबारा भेजें';

  @override
  String get enterOtp => '6 अंकों का OTP दर्ज करें';

  @override
  String get otpResent => 'OTP फिर से भेजा गया';

  @override
  String get errUserNotLoggedIn => 'उपयोगकर्ता लॉगिन नहीं है।';

  @override
  String get errPhoneRequired => 'फ़ोन आवश्यक है';

  @override
  String get errPhoneCountryCode => 'देश का कोड शामिल करें, जैसे +91...';

  @override
  String get errPhoneInvalid => 'मान्य फ़ोन नंबर दर्ज करें';

  @override
  String get errOtpSixDigits => '6 अंकों का कोड दर्ज करें';

  @override
  String errAutoSignInFailed(String error) {
    return 'ऑटो साइन-इन असफल: $error';
  }

  @override
  String errRoleLocked(String role) {
    return 'आप पहले ही $role के रूप में साइन इन कर चुके हैं। भूमिका बदलना अनुमति नहीं है।';
  }

  @override
  String errGeneric(String error) {
    return '$error';
  }

  @override
  String verifyPhone(String phone) {
    return '$phone सत्यापित करें';
  }

  @override
  String get jobNotifications => 'नौकरी सूचनाएँ';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get jobApplications => 'नौकरी आवेदन';

  @override
  String get alerts => 'सूचनाएँ';

  @override
  String get searchByTitleOrCategory => 'शीर्षक या श्रेणी से खोजें';

  @override
  String get rateType => 'दर प्रकार';

  @override
  String get sort => 'क्रमबद्ध करें:';

  @override
  String get sortClosest => 'सबसे नज़दीक';

  @override
  String get sortHighestPay => 'सबसे अधिक वेतन';

  @override
  String get sortNewest => 'नवीनतम';

  @override
  String get noJobsFoundMatching => 'फ़िल्टर के अनुसार कोई नौकरी नहीं मिली।';

  @override
  String get locationPermissionRequired => 'आस-पास की नौकरियाँ दिखाने के लिए स्थान अनुमति आवश्यक है।';

  @override
  String get rateAny => 'कोई भी';

  @override
  String get ratePerHour => 'प्रति घंटा';

  @override
  String get ratePerDay => 'प्रति दिन';

  @override
  String get ratePerWeek => 'प्रति सप्ताह';

  @override
  String get ratePerMonth => 'प्रति माह';

  @override
  String get myApplications => 'मेरे आवेदन';

  @override
  String get noApplicationsFound => 'कोई आवेदन नहीं मिला।';

  @override
  String get loadingJob => 'नौकरी लोड हो रही है...';

  @override
  String get jobDetails => 'नौकरी विवरण';

  @override
  String get location => 'स्थान';

  @override
  String get category => 'श्रेणी';

  @override
  String get rate => 'दर';

  @override
  String get timing => 'समय';

  @override
  String get contact => 'संपर्क';

  @override
  String get description => 'विवरण';

  @override
  String get status => 'स्थिति';

  @override
  String get close => 'बंद करें';

  @override
  String get applyNow => 'अभी आवेदन करें';

  @override
  String get alreadyApplied => 'पहले से आवेदन किया गया';

  @override
  String get applicationSubmitted => 'आवेदन जमा किया गया';

  @override
  String get failedToLaunchDialer => 'डायलर लॉन्च करने में विफल';

  @override
  String get cannotLaunchDialer => 'डायलर लॉन्च नहीं कर सकते: कोई ऐप नहीं मिला';

  @override
  String get callEmployer => 'नियोक्ता को कॉल करें';

  @override
  String get noNewJobsInArea => 'आपके क्षेत्र में कोई नई नौकरी नहीं।';

  @override
  String get markAsSeen => 'देखा गया के रूप में चिह्नित करें';

  @override
  String get profileInformation => 'प्रोफ़ाइल जानकारी';

  @override
  String get noProfileDataFound => 'कोई प्रोफ़ाइल डेटा नहीं मिला।';

  @override
  String get name => 'नाम';

  @override
  String get skills => 'कौशल';

  @override
  String get experience => 'अनुभव';

  @override
  String get years => 'वर्ष';

  @override
  String get expectedRate => 'अपेक्षित दर';

  @override
  String get mobileNumber => 'मोबाइल नंबर';

  @override
  String get address => 'पता';

  @override
  String get availableNow => 'अभी उपलब्ध';

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get idVerification => 'आईडी सत्यापन';

  @override
  String get verificationStatus => 'सत्यापन स्थिति';

  @override
  String get noIdProofUploaded => 'कोई आईडी प्रमाण अपलोड नहीं किया गया।';

  @override
  String get setupWorkerProfile => 'कार्यकर्ता प्रोफ़ाइल सेटअप';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get skillsCommaSeparated => 'कौशल (अल्पविराम से अलग)';

  @override
  String get experienceYears => 'अनुभव (वर्ष)';

  @override
  String get expectedRateAmount => 'अपेक्षित दर';

  @override
  String get uploadIdCameraGallery => 'आईडी अपलोड करें (कैमरा / गैलरी)';

  @override
  String get chooseFromGallery => 'गैलरी से चुनें';

  @override
  String get takePhoto => 'फोटो लें';

  @override
  String get removeSelected => 'चयनित हटाएँ';

  @override
  String get saveProfile => 'प्रोफ़ाइल सहेजें';

  @override
  String get profileSavedSuccessfully => 'प्रोफ़ाइल सफलतापूर्वक सहेजा गया';

  @override
  String errorSavingProfile(String error) {
    return 'प्रोफ़ाइल सहेजने में त्रुटि: $error';
  }

  @override
  String get required => 'आवश्यक';

  @override
  String get noTitle => 'कोई शीर्षक नहीं';

  @override
  String get noDescription => 'कोई विवरण नहीं';

  @override
  String get notSpecified => 'निर्दिष्ट नहीं';

  @override
  String get notProvided => 'प्रदान नहीं किया गया';

  @override
  String get notMentioned => 'उल्लेख नहीं किया गया';

  @override
  String get noAddress => 'कोई पता नहीं';

  @override
  String get perHour => 'प्रति घंटा';

  @override
  String get perDay => 'प्रति दिन';

  @override
  String get perWeek => 'प्रति सप्ताह';

  @override
  String get perMonth => 'प्रति माह';

  @override
  String applicantsForJob(String jobTitle) {
    return '\"$jobTitle\" के लिए आवेदक';
  }

  @override
  String get noApplicantsYet => 'अभी तक कोई आवेदक नहीं।';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get workerProfileNotFound => 'कार्यकर्ता प्रोफ़ाइल नहीं मिला।';

  @override
  String get unableToOpenDialer => 'डायलर खोलने में असमर्थ';

  @override
  String get verified => 'सत्यापित';

  @override
  String get noAddressAvailable => 'कोई पता उपलब्ध नहीं';

  @override
  String get idProof => 'आईडी प्रमाण';

  @override
  String get ratingsAndReviews => 'रेटिंग और समीक्षाएँ';

  @override
  String get noReviewsYet => 'अभी तक कोई समीक्षा नहीं।';

  @override
  String averageRating(String rating, int count) {
    return '⭐ औसत रेटिंग: $rating ($count समीक्षाएँ)';
  }

  @override
  String get rateWorker => 'कार्यकर्ता को रेट करें';

  @override
  String get ratingLabel => 'रेटिंग (1.0 - 5.0)';

  @override
  String get comment => 'टिप्पणी';

  @override
  String get submit => 'जमा करें';

  @override
  String get enterValidRating => 'एक वैध रेटिंग दर्ज करें (1.0 से 5.0)';

  @override
  String get reviewSubmitted => 'समीक्षा जमा की गई';

  @override
  String get accept => 'स्वीकार करें';

  @override
  String get reject => 'अस्वीकार करें';

  @override
  String get pending => 'लंबित';

  @override
  String get accepted => 'स्वीकृत';

  @override
  String get rejected => 'अस्वीकृत';

  @override
  String get rateWorkerButton => 'कार्यकर्ता को रेट करें';

  @override
  String get unnamed => 'अनाम';

  @override
  String skillsLabel(String skills) {
    return 'कौशल: $skills';
  }

  @override
  String experienceLabel(int experience) {
    return 'अनुभव: $experience वर्ष';
  }

  @override
  String get employerDashboard => 'नियोक्ता डैशबोर्ड';

  @override
  String get favoriteWorkers => 'पसंदीदा कार्यकर्ता';

  @override
  String get employerProfile => 'नियोक्ता प्रोफ़ाइल';

  @override
  String get yourJobPosts => 'आपकी नौकरी पोस्ट';

  @override
  String get noJobPostsYet => 'अभी तक कोई नौकरी पोस्ट नहीं।';

  @override
  String posted(String date) {
    return 'पोस्ट किया गया: $date';
  }

  @override
  String get untitled => 'शीर्षकहीन';

  @override
  String get postJob => 'नौकरी पोस्ट करें';

  @override
  String get nearbyWorkers => 'आस-पास के कार्यकर्ता';

  @override
  String get postAJob => 'नौकरी पोस्ट करें';

  @override
  String get jobTitle => 'नौकरी का शीर्षक';

  @override
  String get jobCategory => 'नौकरी की श्रेणी';

  @override
  String get contactMobileNumber => 'संपर्क मोबाइल नंबर(+91 या +44)';

  @override
  String get jobTiming => 'नौकरी का समय:';

  @override
  String get jobDescription => 'नौकरी का विवरण';

  @override
  String get pleaseFillAllFields => 'कृपया सभी फ़ील्ड भरें और नौकरी का समय सेट करें';

  @override
  String get jobPostedSuccessfully => 'नौकरी सफलतापूर्वक पोस्ट की गई!';

  @override
  String error(String message) {
    return 'त्रुटि: $message';
  }

  @override
  String get notSet => 'सेट नहीं';

  @override
  String get startTime => 'शुरुआती समय';

  @override
  String get endTime => 'समाप्ति समय';

  @override
  String get fetchingCurrentLocation => 'वर्तमान स्थान प्राप्त कर रहा है...';

  @override
  String get locationFetchFailed => 'स्थान प्राप्त करने में विफल';

  @override
  String get businessType => 'व्यवसाय का प्रकार';

  @override
  String get company => 'कंपनी';

  @override
  String get setupEmployerProfile => 'नियोक्ता प्रोफ़ाइल सेटअप';

  @override
  String get companyNameOptional => 'कंपनी का नाम (वैकल्पिक)';

  @override
  String get employerProfileSaved => 'नियोक्ता प्रोफ़ाइल सहेजा गया';

  @override
  String errorSavingEmployerProfile(String error) {
    return 'प्रोफ़ाइल सहेजने में त्रुटि: $error';
  }

  @override
  String get noName => 'कोई नाम नहीं';

  @override
  String get notVerified => 'सत्यापित नहीं';

  @override
  String rateTypeLabel(String rateType) {
    return 'दर प्रकार: $rateType';
  }

  @override
  String expectedRateLabel(String rate) {
    return 'अपेक्षित दर: $rate';
  }

  @override
  String availableNowLabel(String available) {
    return 'अभी उपलब्ध: $available';
  }

  @override
  String get tapImageToViewFullSize => 'पूर्ण आकार देखने के लिए छवि पर टैप करें';

  @override
  String get noIdUploaded => 'कोई आईडी अपलोड नहीं किया गया।';

  @override
  String get noFavoriteWorkers => 'कोई पसंदीदा कार्यकर्ता नहीं।';

  @override
  String get searchBySkills => 'कौशल से खोजें (अल्पविराम से अलग)';

  @override
  String get noWorkersFoundNearby => 'आस-पास कोई कार्यकर्ता नहीं मिला।';

  @override
  String get mobile => 'मोबाइल';

  @override
  String get viewId => 'आईडी देखें';

  @override
  String get unfavorite => 'पसंदीदा नहीं';

  @override
  String get favorite => 'पसंदीदा';

  @override
  String get deleteJob => 'नौकरी हटाएं';

  @override
  String get deleteJobConfirmation => 'क्या आप वाकई इस नौकरी पोस्ट को हटाना चाहते हैं?';

  @override
  String get delete => 'हटाएं';

  @override
  String get jobDeleted => 'नौकरी हटा दी गई';

  @override
  String get edit => 'संपादित करें';

  @override
  String get jobNotFound => 'नौकरी नहीं मिली';

  @override
  String get title => 'शीर्षक';

  @override
  String get jobTimings => 'नौकरी का समय';

  @override
  String get noTimingsMentioned => 'कोई समय उल्लेख नहीं किया गया';

  @override
  String get contactNumber => 'संपर्क नंबर';

  @override
  String get noDescriptionProvided => 'कोई विवरण प्रदान नहीं किया गया।';

  @override
  String postedAt(String date) {
    return 'पोस्ट किया गया: $date';
  }

  @override
  String get viewApplicants => 'आवेदक देखें';

  @override
  String get untitledJob => 'शीर्षकहीन नौकरी';

  @override
  String get editJob => 'नौकरी संपादित करें';

  @override
  String get pleaseCompleteAllFields => 'कृपया सभी फ़ील्ड और नौकरी का समय पूरा करें';

  @override
  String get jobUpdatedSuccessfully => 'नौकरी सफलतापूर्वक अपडेट की गई!';

  @override
  String updateFailed(String error) {
    return 'अपडेट विफल: $error';
  }

  @override
  String get contactMobile => 'संपर्क मोबाइल';

  @override
  String get updateJob => 'नौकरी अपडेट करें';
}
