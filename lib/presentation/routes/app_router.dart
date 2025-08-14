import 'package:go_router/go_router.dart';
import 'package:localjobfinder/presentation/screens/auth/splash_screen.dart';
import '../screens/auth/otp_verification_screen.dart';
import '../screens/auth/phone_login_screen.dart';
import '../screens/auth/role_selections_screen.dart';
import '../screens/employer/employer_applicants_screen.dart';
import '../screens/employer/employer_edit_job_screen.dart';
import '../screens/employer/employer_job_detail_screen.dart';
import '../screens/employer/employer_nearby_workers_screen.dart';
import '../screens/employer/employer_post_job_screen.dart';
import '../screens/worker/job_detail_screen.dart';
import '../screens/worker/worker_applications_screen.dart';
import '../screens/worker/worker_notifications_screen.dart';
import 'session_router.dart';
import '../screens/employer/employer_profile_screen.dart';
import '../screens/employer/employer_profile_setup_screen.dart';
import '../screens/worker/worker_dashboard.dart';
import '../screens/employer/employer_dashboard.dart';
import '../screens/worker/worker_profile_screen.dart';
import '../screens/worker/worker_profile_setup_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/session',
        builder: (context, state) => const SessionRouter(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const PhoneLoginScreen(),
      ),
      GoRoute(
        path: '/verify-otp',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return OtpVerificationScreen(
            verificationId: data['verificationId'],
            phone: data['phone'],
          );
        },
      ),
      GoRoute(
        path: '/select-role',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/worker',
        builder: (context, state) => const WorkerDashboard(),
      ),
      GoRoute(
        path: '/worker-profile-setup',
        builder: (context, state) => const WorkerProfileSetupScreen(),
      ),
      GoRoute(
        path: '/worker-profile',
        builder: (context, state) => const WorkerProfileScreen(),
      ),
      GoRoute(
        path: '/job-details',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return JobDetailsScreen(
            jobId: extra['jobId'],
            jobData: extra['jobData'],
          );
        },
      ),
      GoRoute(
        path: '/worker-applications',
        builder: (context, state) => const WorkerApplicationsScreen(),
      ),
      GoRoute(
        path: '/worker-notifications',
        builder: (context, state) => const WorkerNotificationsScreen(),
      ),


      GoRoute(
        path: '/employer',
        builder: (context, state) => const EmployerDashboard(),
      ),
      GoRoute(
        path: '/employer-profile-setup',
        builder: (context, state) => const EmployerProfileSetupScreen(),
      ),
      GoRoute(
        path: '/employer-profile',
        builder: (context, state) => const EmployerProfileScreen(),
      ),
      GoRoute(
        path: '/employer-post-job',
        builder: (context, state) => const EmployerPostJobScreen(),
      ),
      GoRoute(
        path: '/employer-job/:jobId',
        builder: (context, state) {
          final jobId = state.pathParameters['jobId']!;
          return EmployerJobDetailScreen(jobId: jobId);
        },
      ),
      GoRoute(
        path: '/employer-edit-job/:jobId',
        builder: (context, state) {
          final jobId = state.pathParameters['jobId']!;
          return EmployerEditJobScreen(jobId: jobId);
        },
      ),
      GoRoute(
        path: '/employer-applicants/:jobId',
        builder: (context, state) {
          final jobId = state.pathParameters['jobId']!;
          final jobTitle = state.extra is String ? state.extra as String : 'Untitled Job';
          return EmployerApplicantsScreen(jobId: jobId, jobTitle: jobTitle);
        },
      ),
      GoRoute(
        path: '/employer-nearby-workers',
        builder: (context, state) => const EmployerNearbyWorkersScreen(),
      ),
    ],
  );
}
