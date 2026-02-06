// Config
import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseUrl = dotenv.env['BASE_URL'].toString();
final baseApiUrl = dotenv.env['API_URL'].toString();
final purchasingApiUrl = dotenv.env['PURCHASING_API_URL'].toString();
final purchasingApiToken = dotenv.env['PURCHASING_API_TOKEN'].toString();
const notificationIcon = '@mipmap/ic_launcher';
const defaultImage = '';

// Shared Preference Name
const tokenPref = '_token';
const visitPref = '_visit';
const bookmarkCoordinatePref = '_bookmark_coordinate';
const bookmarkCoordinateEditPref = '_bookmark_coordinate_edit';
const allowNotificationPref = '_allow_notification';

// Http
const int timeoutRequest = 10; // in second
const String timeoutMessage =
    "Permintaan terlalu lama diproses. Silakan periksa internet Anda dan coba lagi.";
const String noConnectionMessage =
    "Tidak ada koneksi internet. Silakan periksa jaringan Anda dan coba lagi.";
const String errorMessage =
    "Terjadi kesalahan pada sistem. Silakan coba lagi nanti.";

// TABLE
const racksPrefix = 'RC';
const productsPrefix = 'PD';
const companyItemsPrefix = 'CI';
const variantsPrefix = 'VT';
const variantPhotosPrefix = 'VP';
const variantComponentPrefix = 'VC';
const componentsPrefix = 'CO';
const componentPhotosPrefix = 'CP';
const unitsPrefix = 'UN';

// COMPONENT TYPE
const inBoxType = 1;
const separateType = 2;

// UNIT STATUS
const deletedStatus = -1;
const activeStatus = 1;
const pendingStatus = 0;
const consumedStatus = 2;
const printedStatus = 11;
const validatedStatus = 12;

// ROLE STRING
const adminRole = 'admin';
const developerRole = 'developer';
const purchasingRole = 'purchasing';
const storekeeperRole = 'storekeeper';
