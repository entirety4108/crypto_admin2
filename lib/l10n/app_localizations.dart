import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// Application title
  ///
  /// In ja, this message translates to:
  /// **'Crypto Admin'**
  String get appTitle;

  /// Login button text
  ///
  /// In ja, this message translates to:
  /// **'ログイン'**
  String get login;

  /// Sign up button text
  ///
  /// In ja, this message translates to:
  /// **'新規登録'**
  String get signUp;

  /// Email field label
  ///
  /// In ja, this message translates to:
  /// **'メールアドレス'**
  String get email;

  /// Password field label
  ///
  /// In ja, this message translates to:
  /// **'パスワード'**
  String get password;

  /// Confirm password field label
  ///
  /// In ja, this message translates to:
  /// **'パスワード確認'**
  String get confirmPassword;

  /// Forgot password link text
  ///
  /// In ja, this message translates to:
  /// **'パスワードを忘れた方'**
  String get forgotPassword;

  /// Reset password button text
  ///
  /// In ja, this message translates to:
  /// **'パスワードリセット'**
  String get resetPassword;

  /// Send reset link button text
  ///
  /// In ja, this message translates to:
  /// **'リセットリンクを送信'**
  String get sendResetLink;

  /// Logout button text
  ///
  /// In ja, this message translates to:
  /// **'ログアウト'**
  String get logout;

  /// Portfolio navigation label
  ///
  /// In ja, this message translates to:
  /// **'ポートフォリオ'**
  String get portfolio;

  /// Transactions navigation label
  ///
  /// In ja, this message translates to:
  /// **'取引'**
  String get transactions;

  /// Analysis navigation label
  ///
  /// In ja, this message translates to:
  /// **'分析'**
  String get analysis;

  /// Settings navigation label
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get settings;

  /// Accounts label
  ///
  /// In ja, this message translates to:
  /// **'アカウント'**
  String get accounts;

  /// Add account button text
  ///
  /// In ja, this message translates to:
  /// **'アカウント追加'**
  String get addAccount;

  /// Edit account button text
  ///
  /// In ja, this message translates to:
  /// **'アカウント編集'**
  String get editAccount;

  /// Delete account button text
  ///
  /// In ja, this message translates to:
  /// **'アカウント削除'**
  String get deleteAccount;

  /// Deposit label
  ///
  /// In ja, this message translates to:
  /// **'入金'**
  String get deposit;

  /// Sell label
  ///
  /// In ja, this message translates to:
  /// **'売却'**
  String get sell;

  /// Swap label
  ///
  /// In ja, this message translates to:
  /// **'スワップ'**
  String get swap;

  /// Transfer label
  ///
  /// In ja, this message translates to:
  /// **'振替'**
  String get transfer;

  /// Airdrop label
  ///
  /// In ja, this message translates to:
  /// **'エアドロップ'**
  String get airdrop;

  /// Staking label
  ///
  /// In ja, this message translates to:
  /// **'ステーキング'**
  String get staking;

  /// Commission label
  ///
  /// In ja, this message translates to:
  /// **'手数料'**
  String get commission;

  /// Category label
  ///
  /// In ja, this message translates to:
  /// **'カテゴリ'**
  String get category;

  /// Categories label
  ///
  /// In ja, this message translates to:
  /// **'カテゴリ一覧'**
  String get categories;

  /// Add category button text
  ///
  /// In ja, this message translates to:
  /// **'カテゴリ追加'**
  String get addCategory;

  /// Language label
  ///
  /// In ja, this message translates to:
  /// **'言語'**
  String get language;

  /// Japanese language option
  ///
  /// In ja, this message translates to:
  /// **'日本語'**
  String get japanese;

  /// English language option
  ///
  /// In ja, this message translates to:
  /// **'English'**
  String get english;

  /// Save button text
  ///
  /// In ja, this message translates to:
  /// **'保存'**
  String get save;

  /// Cancel button text
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get cancel;

  /// Delete button text
  ///
  /// In ja, this message translates to:
  /// **'削除'**
  String get delete;

  /// Edit button text
  ///
  /// In ja, this message translates to:
  /// **'編集'**
  String get edit;

  /// Confirm button text
  ///
  /// In ja, this message translates to:
  /// **'確認'**
  String get confirm;

  /// Generic error message
  ///
  /// In ja, this message translates to:
  /// **'エラーが発生しました'**
  String get errorOccurred;

  /// Invalid email error message
  ///
  /// In ja, this message translates to:
  /// **'有効なメールアドレスを入力してください'**
  String get invalidEmail;

  /// Password too short error message
  ///
  /// In ja, this message translates to:
  /// **'パスワードは6文字以上で入力してください'**
  String get passwordTooShort;

  /// Password mismatch error message
  ///
  /// In ja, this message translates to:
  /// **'パスワードが一致しません'**
  String get passwordMismatch;

  /// No account text
  ///
  /// In ja, this message translates to:
  /// **'アカウントをお持ちでない方'**
  String get noAccount;

  /// Have account text
  ///
  /// In ja, this message translates to:
  /// **'すでにアカウントをお持ちの方'**
  String get haveAccount;

  /// Reset link sent message
  ///
  /// In ja, this message translates to:
  /// **'パスワードリセットリンクを送信しました'**
  String get resetLinkSent;

  /// Total assets label
  ///
  /// In ja, this message translates to:
  /// **'総資産'**
  String get totalAssets;

  /// Profit label
  ///
  /// In ja, this message translates to:
  /// **'損益'**
  String get profit;

  /// Definite PnL label
  ///
  /// In ja, this message translates to:
  /// **'確定損益'**
  String get definitePnl;

  /// Indefinite PnL label
  ///
  /// In ja, this message translates to:
  /// **'評価損益'**
  String get indefinitePnl;

  /// Currency label
  ///
  /// In ja, this message translates to:
  /// **'通貨'**
  String get currency;

  /// Amount label
  ///
  /// In ja, this message translates to:
  /// **'数量'**
  String get amount;

  /// Unit price label
  ///
  /// In ja, this message translates to:
  /// **'単価'**
  String get unitPrice;

  /// Valuation label
  ///
  /// In ja, this message translates to:
  /// **'評価額'**
  String get valuation;

  /// Date label
  ///
  /// In ja, this message translates to:
  /// **'日時'**
  String get date;

  /// Japanese yen
  ///
  /// In ja, this message translates to:
  /// **'円'**
  String get yen;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
