// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get welcome => 'స్వాగతం';

  @override
  String get login => 'లాగిన్';

  @override
  String get selectRole => 'పాత్రను ఎంచుకోండి';

  @override
  String get worker => 'ఉద్యోగి';

  @override
  String get employer => 'నియోజకుడు';

  @override
  String get workerDashboard => 'ఉద్యోగి డాష్‌బోర్డు';

  @override
  String get confirmLogout => 'లాగ్అవుట్‌ని నిర్ధారించండి';

  @override
  String get logoutPrompt => 'మీరు నిజంగా లాగ్అవుట్ కావాలనుకుంటున్నారా?';

  @override
  String get cancel => 'రద్దు';

  @override
  String get logout => 'లాగ్అవుట్';

  @override
  String get nearbyJobs => 'సమీప ఉద్యోగాలు';

  @override
  String get electricianJobTitle => 'ఎలక్ట్రిషియన్ అవసరం';

  @override
  String get electricianJobSubtitle => '₹300/గంట • రాజమండ్రి';

  @override
  String get jobs => 'ఉద్యోగాలు';

  @override
  String get profile => 'ప్రొఫైల్';

  @override
  String get appTitle => 'లోకల్ జాబ్ ఫైండర్';

  @override
  String get youAreSigningInAs => 'మీరు ఇలా సైన్ ఇన్ అవుతున్నారు:';

  @override
  String get loginWithPhone => 'ఫోన్‌తో లాగిన్ అవ్వండి';

  @override
  String get labelPhoneExample => 'ఫోన్ (ఉదా., +9198xxxxxx)';

  @override
  String get sendOtp => 'OTP పంపండి';

  @override
  String get verifyAndContinue => 'ధృవీకరించి కొనసాగించండి';

  @override
  String get resendOtp => 'OTP మళ్లీ పంపండి';

  @override
  String get enterOtp => '6 అంకెల OTP నమోదు చేయండి';

  @override
  String get otpResent => 'OTP మళ్లీ పంపబడింది';

  @override
  String get errUserNotLoggedIn => 'వినియోగదారు లాగిన్ కాలేదు.';

  @override
  String get errPhoneRequired => 'ఫోన్ అవసరం';

  @override
  String get errPhoneCountryCode => 'దేశ కోడ్ చేర్చండి, ఉదా. +91...';

  @override
  String get errPhoneInvalid => 'సరైన ఫోన్ నంబర్ నమోదు చేయండి';

  @override
  String get errOtpSixDigits => '6 అంకెల కోడ్ నమోదు చేయండి';

  @override
  String errAutoSignInFailed(String error) {
    return 'ఆటో సైన్-ఇన్ విఫలమైంది: $error';
  }

  @override
  String errRoleLocked(String role) {
    return 'మీరు ఇప్పటికే $roleగా సైన్ ఇన్ అయ్యారు. పాత్ర మార్చడం అనుమతించబడదు.';
  }

  @override
  String errGeneric(String error) {
    return '$error';
  }

  @override
  String verifyPhone(String phone) {
    return '$phoneని ధృవీకరించండి';
  }

  @override
  String get jobNotifications => 'ఉద్యోగ ప్రకటనలు';

  @override
  String get editProfile => 'ప్రొఫైల్ సరిచేయి';

  @override
  String get jobApplications => 'ఉద్యోగ అప్లికేషన్లు';

  @override
  String get alerts => 'అలర్ట్స్';

  @override
  String get searchByTitleOrCategory => 'టైటిల్ లేదా కేటగిరీ ద్వారా వెతకండి';

  @override
  String get rateType => 'రేట్ రకం';

  @override
  String get sort => 'క్రమపరచు:';

  @override
  String get sortClosest => 'దగ్గరగా';

  @override
  String get sortHighestPay => 'అత్యధిక వేతనం';

  @override
  String get sortNewest => 'కొత్తవి';

  @override
  String get noJobsFoundMatching => 'ఎంపికలతో సరిపడే ఉద్యోగాలు లేవు.';

  @override
  String get locationPermissionRequired => 'సమీప ఉద్యోగాలు చూపించడానికి స్థానం అనుమతి అవసరం.';

  @override
  String get rateAny => 'ఏదైనా';

  @override
  String get ratePerHour => 'గంటకు';

  @override
  String get ratePerDay => 'రోజుకు';

  @override
  String get ratePerWeek => 'వారానికి';

  @override
  String get ratePerMonth => 'నెలకు';

  @override
  String get myApplications => 'నా అప్లికేషన్లు';

  @override
  String get noApplicationsFound => 'అప్లికేషన్లు లేవు.';

  @override
  String get loadingJob => 'ఉద్యోగం లోడ్ అవుతోంది...';

  @override
  String get jobDetails => 'ఉద్యోగ వివరాలు';

  @override
  String get location => 'స్థానం';

  @override
  String get category => 'కేటగిరీ';

  @override
  String get rate => 'రేట్';

  @override
  String get timing => 'సమయం';

  @override
  String get contact => 'సంప్రదింపు';

  @override
  String get description => 'వివరణ';

  @override
  String get status => 'స్థితి';

  @override
  String get close => 'మూసివేయి';

  @override
  String get applyNow => 'ఇప్పుడు దరఖాస్తు చేయండి';

  @override
  String get alreadyApplied => 'ఇప్పటికే దరఖాస్తు చేయబడింది';

  @override
  String get applicationSubmitted => 'దరఖాస్తు సమర్పించబడింది';

  @override
  String get failedToLaunchDialer => 'డయలర్ ప్రారంభించడంలో విఫలం';

  @override
  String get cannotLaunchDialer => 'డయలర్ ప్రారంభించలేము: అప్లికేషన్ లేదు';

  @override
  String get callEmployer => 'నియోక్తను కాల్ చేయండి';

  @override
  String get noNewJobsInArea => 'మీ ప్రాంతంలో కొత్త ఉద్యోగాలు లేవు.';

  @override
  String get markAsSeen => 'చూసినట్లుగా గుర్తించండి';

  @override
  String get profileInformation => 'ప్రొఫైల్ సమాచారం';

  @override
  String get noProfileDataFound => 'ప్రొఫైల్ డేటా లేదు.';

  @override
  String get name => 'పేరు';

  @override
  String get skills => 'నైపుణ్యాలు';

  @override
  String get experience => 'అనుభవం';

  @override
  String get years => 'సంవత్సరాలు';

  @override
  String get expectedRate => 'అంచనా రేట్';

  @override
  String get mobileNumber => 'మొబైల్ నంబర్';

  @override
  String get address => 'చిరునామా';

  @override
  String get availableNow => 'ఇప్పుడు అందుబాటులో';

  @override
  String get yes => 'అవును';

  @override
  String get no => 'లేదు';

  @override
  String get idVerification => 'ఐడి ధృవీకరణ';

  @override
  String get verificationStatus => 'ధృవీకరణ స్థితి';

  @override
  String get noIdProofUploaded => 'ఐడి రుజువు అప్లోడ్ చేయబడలేదు.';

  @override
  String get setupWorkerProfile => 'కార్మిక ప్రొఫైల్ సెటప్';

  @override
  String get fullName => 'పూర్తి పేరు';

  @override
  String get skillsCommaSeparated => 'నైపుణ్యాలు (కామాలతో వేరు చేయబడినవి)';

  @override
  String get experienceYears => 'అనుభవం (సంవత్సరాలు)';

  @override
  String get expectedRateAmount => 'అంచనా రేట్';

  @override
  String get uploadIdCameraGallery => 'ఐడి అప్లోడ్ చేయండి (కెమెరా / గ్యాలరీ)';

  @override
  String get chooseFromGallery => 'గ్యాలరీ నుండి ఎంచుకోండి';

  @override
  String get takePhoto => 'ఫోటో తీయండి';

  @override
  String get removeSelected => 'ఎంచుకున్నది తొలగించండి';

  @override
  String get saveProfile => 'ప్రొఫైల్ సేవ్ చేయండి';

  @override
  String get profileSavedSuccessfully => 'ప్రొఫైల్ విజయవంతంగా సేవ్ చేయబడింది';

  @override
  String errorSavingProfile(String error) {
    return 'ప్రొఫైల్ సేవ్ చేయడంలో లోపం: $error';
  }

  @override
  String get required => 'అవసరం';

  @override
  String get noTitle => 'టైటిల్ లేదు';

  @override
  String get noDescription => 'వివరణ లేదు';

  @override
  String get notSpecified => 'పేర్కొనబడలేదు';

  @override
  String get notProvided => 'అందించబడలేదు';

  @override
  String get notMentioned => 'పేర్కొనబడలేదు';

  @override
  String get noAddress => 'చిరునామా లేదు';

  @override
  String get perHour => 'గంటకు';

  @override
  String get perDay => 'రోజుకు';

  @override
  String get perWeek => 'వారానికి';

  @override
  String get perMonth => 'నెలకు';

  @override
  String applicantsForJob(String jobTitle) {
    return '\"$jobTitle\" కోసం దరఖాస్తుదారులు';
  }

  @override
  String get noApplicantsYet => 'ఇంకా దరఖాస్తుదారులు లేరు.';

  @override
  String get loading => 'లోడ్ అవుతోంది...';

  @override
  String get workerProfileNotFound => 'కార్మిక ప్రొఫైల్ కనుగొనబడలేదు.';

  @override
  String get unableToOpenDialer => 'డయలర్ తెరవలేము';

  @override
  String get verified => 'ధృవీకరించబడింది';

  @override
  String get noAddressAvailable => 'చిరునామా అందుబాటులో లేదు';

  @override
  String get idProof => 'ఐడి రుజువు';

  @override
  String get ratingsAndReviews => 'రేటింగ్లు మరియు సమీక్షలు';

  @override
  String get noReviewsYet => 'ఇంకా సమీక్షలు లేవు.';

  @override
  String averageRating(String rating, int count) {
    return '⭐ సగటు రేటింగ్: $rating ($count సమీక్షలు)';
  }

  @override
  String get rateWorker => 'కార్మికుడిని రేట్ చేయండి';

  @override
  String get ratingLabel => 'రేటింగ్ (1.0 - 5.0)';

  @override
  String get comment => 'వ్యాఖ్య';

  @override
  String get submit => 'సమర్పించండి';

  @override
  String get enterValidRating => 'చెల్లుబాటు అయ్యే రేటింగ్ నమోదు చేయండి (1.0 నుండి 5.0)';

  @override
  String get reviewSubmitted => 'సమీక్ష సమర్పించబడింది';

  @override
  String get accept => 'అంగీకరించండి';

  @override
  String get reject => 'తిరస్కరించండి';

  @override
  String get pending => 'పెండింగ్';

  @override
  String get accepted => 'అంగీకరించబడింది';

  @override
  String get rejected => 'తిరస్కరించబడింది';

  @override
  String get rateWorkerButton => 'కార్మికుడిని రేట్ చేయండి';

  @override
  String get unnamed => 'పేరు లేని';

  @override
  String skillsLabel(String skills) {
    return 'నైపుణ్యాలు: $skills';
  }

  @override
  String experienceLabel(int experience) {
    return 'అనుభవం: $experience సంవత్సరాలు';
  }

  @override
  String get employerDashboard => 'నియోక్త డాష్‌బోర్డ్';

  @override
  String get favoriteWorkers => 'ఇష్టమైన కార్మికులు';

  @override
  String get employerProfile => 'నియోక్త ప్రొఫైల్';

  @override
  String get yourJobPosts => 'మీ ఉద్యోగ పోస్ట్లు';

  @override
  String get noJobPostsYet => 'ఇంకా ఉద్యోగ పోస్ట్లు లేవు.';

  @override
  String posted(String date) {
    return 'పోస్ట్ చేయబడింది: $date';
  }

  @override
  String get untitled => 'శీర్షిక లేని';

  @override
  String get postJob => 'ఉద్యోగం పోస్ట్ చేయండి';

  @override
  String get nearbyWorkers => 'సమీప కార్మికులు';

  @override
  String get postAJob => 'ఉద్యోగం పోస్ట్ చేయండి';

  @override
  String get jobTitle => 'ఉద్యోగ శీర్షిక';

  @override
  String get jobCategory => 'ఉద్యోగ వర్గం';

  @override
  String get contactMobileNumber => 'సంప్రదింపు మొబైల్ నంబర్(+91 లేదా +44)';

  @override
  String get jobTiming => 'ఉద్యోగ సమయం:';

  @override
  String get jobDescription => 'ఉద్యోగ వివరణ';

  @override
  String get pleaseFillAllFields => 'దయచేసి అన్ని ఫీల్డ్లను నింపండి మరియు ఉద్యోగ సమయాన్ని సెట్ చేయండి';

  @override
  String get jobPostedSuccessfully => 'ఉద్యోగం విజయవంతంగా పోస్ట్ చేయబడింది!';

  @override
  String error(String message) {
    return 'లోపం: $message';
  }

  @override
  String get notSet => 'సెట్ చేయబడలేదు';

  @override
  String get startTime => 'ప్రారంభ సమయం';

  @override
  String get endTime => 'ముగింపు సమయం';

  @override
  String get fetchingCurrentLocation => 'ప్రస్తుత స్థానాన్ని పొందుతోంది...';

  @override
  String get locationFetchFailed => 'స్థానాన్ని పొందడంలో విఫలం';

  @override
  String get businessType => 'వ్యాపార రకం';

  @override
  String get company => 'కంపెనీ';

  @override
  String get setupEmployerProfile => 'నియోక్త ప్రొఫైల్ సెటప్';

  @override
  String get companyNameOptional => 'కంపెనీ పేరు (ఐచ్ఛికం)';

  @override
  String get employerProfileSaved => 'నియోక్త ప్రొఫైల్ సేవ్ చేయబడింది';

  @override
  String errorSavingEmployerProfile(String error) {
    return 'ప్రొఫైల్ సేవ్ చేయడంలో లోపం: $error';
  }

  @override
  String get noName => 'పేరు లేదు';

  @override
  String get notVerified => 'ధృవీకరించబడలేదు';

  @override
  String rateTypeLabel(String rateType) {
    return 'రేట్ రకం: $rateType';
  }

  @override
  String expectedRateLabel(String rate) {
    return 'అంచనా రేట్: $rate';
  }

  @override
  String availableNowLabel(String available) {
    return 'ఇప్పుడు అందుబాటులో: $available';
  }

  @override
  String get tapImageToViewFullSize => 'పూర్తి పరిమాణం చూడటానికి చిత్రంపై నొక్కండి';

  @override
  String get noIdUploaded => 'ఐడి అప్లోడ్ చేయబడలేదు.';

  @override
  String get noFavoriteWorkers => 'ఇష్టమైన కార్మికులు లేరు.';

  @override
  String get searchBySkills => 'నైపుణ్యాల ద్వారా వెతకండి (కామాలతో వేరు చేయబడినవి)';

  @override
  String get noWorkersFoundNearby => 'సమీపంలో కార్మికులు లేరు.';

  @override
  String get mobile => 'మొబైల్';

  @override
  String get viewId => 'ఐడి చూడండి';

  @override
  String get unfavorite => 'ఇష్టమైనది కాదు';

  @override
  String get favorite => 'ఇష్టమైనది';

  @override
  String get deleteJob => 'ఉద్యోగం తొలగించండి';

  @override
  String get deleteJobConfirmation => 'మీరు నిజంగా ఈ ఉద్యోగ పోస్ట్‌ని తొలగించాలనుకుంటున్నారా?';

  @override
  String get delete => 'తొలగించండి';

  @override
  String get jobDeleted => 'ఉద్యోగం తొలగించబడింది';

  @override
  String get edit => 'సరిచేయి';

  @override
  String get jobNotFound => 'ఉద్యోగం కనుగొనబడలేదు';

  @override
  String get title => 'శీర్షిక';

  @override
  String get jobTimings => 'ఉద్యోగ సమయాలు';

  @override
  String get noTimingsMentioned => 'సమయాలు పేర్కొనబడలేదు';

  @override
  String get contactNumber => 'సంప్రదింపు నంబర్';

  @override
  String get noDescriptionProvided => 'వివరణ అందించబడలేదు.';

  @override
  String postedAt(String date) {
    return 'పోస్ట్ చేయబడింది: $date';
  }

  @override
  String get viewApplicants => 'దరఖాస్తుదారులను చూడండి';

  @override
  String get untitledJob => 'శీర్షిక లేని ఉద్యోగం';

  @override
  String get editJob => 'ఉద్యోగం సరిచేయి';

  @override
  String get pleaseCompleteAllFields => 'దయచేసి అన్ని ఫీల్డ్లు మరియు ఉద్యోగ సమయాన్ని పూర్తి చేయండి';

  @override
  String get jobUpdatedSuccessfully => 'ఉద్యోగం విజయవంతంగా అప్డేట్ చేయబడింది!';

  @override
  String updateFailed(String error) {
    return 'అప్డేట్ విఫలం: $error';
  }

  @override
  String get contactMobile => 'సంప్రదింపు మొబైల్';

  @override
  String get updateJob => 'ఉద్యోగం అప్డేట్ చేయండి';
}
