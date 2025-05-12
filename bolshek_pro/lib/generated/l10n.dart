// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Support`
  String get support {
    return Intl.message('Support', name: 'support', desc: '', args: []);
  }

  /// `I'm a new user`
  String get newUser {
    return Intl.message('I\'m a new user', name: 'newUser', desc: '', args: []);
  }

  /// `I already have an account. Log In`
  String get login {
    return Intl.message(
      'I already have an account. Log In',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `By using the application, you agree to the terms and `
  String get agreementText {
    return Intl.message(
      'By using the application, you agree to the terms and ',
      name: 'agreementText',
      desc: '',
      args: [],
    );
  }

  /// `privacy policy`
  String get privacyPolicy {
    return Intl.message(
      'privacy policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Registration`
  String get registration {
    return Intl.message(
      'Registration',
      name: 'registration',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  /// `Last Name`
  String get lastName {
    return Intl.message('Last Name', name: 'lastName', desc: '', args: []);
  }

  /// `Shop Name`
  String get shopName {
    return Intl.message('Shop Name', name: 'shopName', desc: '', args: []);
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `Choose category`
  String get chooseCategory {
    return Intl.message(
      'Choose category',
      name: 'chooseCategory',
      desc: '',
      args: [],
    );
  }

  /// `Brands`
  String get brands {
    return Intl.message('Brands', name: 'brands', desc: '', args: []);
  }

  /// `Choose brand`
  String get chooseBrand {
    return Intl.message(
      'Choose brand',
      name: 'chooseBrand',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get phoneNumber {
    return Intl.message(
      'Enter your phone number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Search category`
  String get searchCategory {
    return Intl.message(
      'Search category',
      name: 'searchCategory',
      desc: '',
      args: [],
    );
  }

  /// `Category list is empty`
  String get emptyCategoryList {
    return Intl.message(
      'Category list is empty',
      name: 'emptyCategoryList',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Search brand`
  String get searchBrand {
    return Intl.message(
      'Search brand',
      name: 'searchBrand',
      desc: '',
      args: [],
    );
  }

  /// `Brand list is empty`
  String get emptyBrandList {
    return Intl.message(
      'Brand list is empty',
      name: 'emptyBrandList',
      desc: '',
      args: [],
    );
  }

  /// `This phone number has already been registered`
  String get phoneAlreadyRegistered {
    return Intl.message(
      'This phone number has already been registered',
      name: 'phoneAlreadyRegistered',
      desc: '',
      args: [],
    );
  }

  /// `Error loading categories: {error}`
  String errorLoadingCategories(Object error) {
    return Intl.message(
      'Error loading categories: $error',
      name: 'errorLoadingCategories',
      desc: '',
      args: [error],
    );
  }

  /// `Error loading brands: {error}`
  String errorLoadingBrands(Object error) {
    return Intl.message(
      'Error loading brands: $error',
      name: 'errorLoadingBrands',
      desc: '',
      args: [error],
    );
  }

  /// `Open map`
  String get openMap {
    return Intl.message('Open map', name: 'openMap', desc: '', args: []);
  }

  /// `Selected`
  String get selectedCategories {
    return Intl.message(
      'Selected',
      name: 'selectedCategories',
      desc: '',
      args: [],
    );
  }

  /// `Selected`
  String get selectedBrands {
    return Intl.message('Selected', name: 'selectedBrands', desc: '', args: []);
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Welcome!`
  String get welcomeMessage {
    return Intl.message('Welcome!', name: 'welcomeMessage', desc: '', args: []);
  }

  /// `We use your phone number to send order notifications`
  String get phoneNotification {
    return Intl.message(
      'We use your phone number to send order notifications',
      name: 'phoneNotification',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get enterPhone {
    return Intl.message(
      'Enter your phone number',
      name: 'enterPhone',
      desc: '',
      args: [],
    );
  }

  /// `+7 777 777-77-77`
  String get phoneHint {
    return Intl.message(
      '+7 777 777-77-77',
      name: 'phoneHint',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid phone number`
  String get enterValidPhone {
    return Intl.message(
      'Enter a valid phone number',
      name: 'enterValidPhone',
      desc: '',
      args: [],
    );
  }

  /// `Send SMS`
  String get sendSMS {
    return Intl.message('Send SMS', name: 'sendSMS', desc: '', args: []);
  }

  /// `Your number is not registered.`
  String get numberNotRegistered {
    return Intl.message(
      'Your number is not registered.',
      name: 'numberNotRegistered',
      desc: '',
      args: [],
    );
  }

  /// `Please proceed to the registration page.`
  String get registrationPrompt {
    return Intl.message(
      'Please proceed to the registration page.',
      name: 'registrationPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Go to Register`
  String get goToRegister {
    return Intl.message(
      'Go to Register',
      name: 'goToRegister',
      desc: '',
      args: [],
    );
  }

  /// `SMS code sent successfully`
  String get smsSentMessageSuccess {
    return Intl.message(
      'SMS code sent successfully',
      name: 'smsSentMessageSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Error sending SMS: {error}`
  String smsSentMessageError(Object error) {
    return Intl.message(
      'Error sending SMS: $error',
      name: 'smsSentMessageError',
      desc: '',
      args: [error],
    );
  }

  /// `Enter SMS code`
  String get smsCodeInputTitle {
    return Intl.message(
      'Enter SMS code',
      name: 'smsCodeInputTitle',
      desc: '',
      args: [],
    );
  }

  /// `Phone confirmation`
  String get phoneConfirmation {
    return Intl.message(
      'Phone confirmation',
      name: 'phoneConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `We have sent a code to your phone number.`
  String get smsSentText {
    return Intl.message(
      'We have sent a code to your phone number.',
      name: 'smsSentText',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verifyButtonText {
    return Intl.message('Verify', name: 'verifyButtonText', desc: '', args: []);
  }

  /// `Resend code in {seconds} sec.`
  String resendTimerText(Object seconds) {
    return Intl.message(
      'Resend code in $seconds sec.',
      name: 'resendTimerText',
      desc: '',
      args: [seconds],
    );
  }

  /// `Resend code`
  String get resendText {
    return Intl.message('Resend code', name: 'resendText', desc: '', args: []);
  }

  /// `Registration error: {error}`
  String registerError(Object error) {
    return Intl.message(
      'Registration error: $error',
      name: 'registerError',
      desc: '',
      args: [error],
    );
  }

  /// `Your account is not active yet. Please wait for a manager's response.`
  String get accountNotActive {
    return Intl.message(
      'Your account is not active yet. Please wait for a manager\'s response.',
      name: 'accountNotActive',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect SMS code. Please try again.`
  String get invalidOtp {
    return Intl.message(
      'Incorrect SMS code. Please try again.',
      name: 'invalidOtp',
      desc: '',
      args: [],
    );
  }

  /// `Too many attempts. Please try again later.`
  String get otpExpired {
    return Intl.message(
      'Too many attempts. Please try again later.',
      name: 'otpExpired',
      desc: '',
      args: [],
    );
  }

  /// `Enter SMS Code`
  String get enter_sms_code {
    return Intl.message(
      'Enter SMS Code',
      name: 'enter_sms_code',
      desc: '',
      args: [],
    );
  }

  /// `Number Verification`
  String get number_confirmation {
    return Intl.message(
      'Number Verification',
      name: 'number_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `We have sent the code to {phoneNumber}.`
  String sent_code_message(Object phoneNumber) {
    return Intl.message(
      'We have sent the code to $phoneNumber.',
      name: 'sent_code_message',
      desc: '',
      args: [phoneNumber],
    );
  }

  /// `Your registration request has been sent!`
  String get registration_sent {
    return Intl.message(
      'Your registration request has been sent!',
      name: 'registration_sent',
      desc: '',
      args: [],
    );
  }

  /// `Please wait for a manager's response.`
  String get please_wait_manager {
    return Intl.message(
      'Please wait for a manager\'s response.',
      name: 'please_wait_manager',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code`
  String get resend_code {
    return Intl.message('Resend Code', name: 'resend_code', desc: '', args: []);
  }

  /// `Resend in {seconds} sec.`
  String resend_timer(Object seconds) {
    return Intl.message(
      'Resend in $seconds sec.',
      name: 'resend_timer',
      desc: '',
      args: [seconds],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Goods`
  String get goods {
    return Intl.message('Goods', name: 'goods', desc: '', args: []);
  }

  /// `Orders`
  String get orders {
    return Intl.message('Orders', name: 'orders', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Phone`
  String get phone {
    return Intl.message('Phone', name: 'phone', desc: '', args: []);
  }

  /// `Address not selected`
  String get selected_address {
    return Intl.message(
      'Address not selected',
      name: 'selected_address',
      desc: '',
      args: [],
    );
  }

  /// `Country unknown`
  String get selected_country {
    return Intl.message(
      'Country unknown',
      name: 'selected_country',
      desc: '',
      args: [],
    );
  }

  /// `City unknown`
  String get selected_city {
    return Intl.message(
      'City unknown',
      name: 'selected_city',
      desc: '',
      args: [],
    );
  }

  /// `Choose language`
  String get choose_language {
    return Intl.message(
      'Choose language',
      name: 'choose_language',
      desc: '',
      args: [],
    );
  }

  /// `Change language`
  String get change_language {
    return Intl.message(
      'Change language',
      name: 'change_language',
      desc: '',
      args: [],
    );
  }

  /// `Fill in the details\nto add a manager`
  String get add_manager_title {
    return Intl.message(
      'Fill in the details\nto add a manager',
      name: 'add_manager_title',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get first_name {
    return Intl.message('First Name', name: 'first_name', desc: '', args: []);
  }

  /// `Last Name`
  String get last_name {
    return Intl.message('Last Name', name: 'last_name', desc: '', args: []);
  }

  /// `Enter phone number`
  String get enter_phone {
    return Intl.message(
      'Enter phone number',
      name: 'enter_phone',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `Manager Details`
  String get edit_manager_title {
    return Intl.message(
      'Manager Details',
      name: 'edit_manager_title',
      desc: '',
      args: [],
    );
  }

  /// `Number`
  String get number {
    return Intl.message('Number', name: 'number', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Logout`
  String get logout_title {
    return Intl.message('Logout', name: 'logout_title', desc: '', args: []);
  }

  /// `Are you sure you want to logout?`
  String get logout_confirmation {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'logout_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout_button {
    return Intl.message('Logout', name: 'logout_button', desc: '', args: []);
  }

  /// `Delete Confirmation`
  String get delete_manager_title {
    return Intl.message(
      'Delete Confirmation',
      name: 'delete_manager_title',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this manager?`
  String get delete_manager_confirmation {
    return Intl.message(
      'Are you sure you want to delete this manager?',
      name: 'delete_manager_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Delete Address`
  String get delete_address_title {
    return Intl.message(
      'Delete Address',
      name: 'delete_address_title',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this address?`
  String get delete_address_confirmation {
    return Intl.message(
      'Are you sure you want to delete this address?',
      name: 'delete_address_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Organization Name:`
  String get org_name_label {
    return Intl.message(
      'Organization Name:',
      name: 'org_name_label',
      desc: '',
      args: [],
    );
  }

  /// `Owner:`
  String get owner_label {
    return Intl.message('Owner:', name: 'owner_label', desc: '', args: []);
  }

  /// `Phone Number`
  String get phone_label {
    return Intl.message(
      'Phone Number',
      name: 'phone_label',
      desc: '',
      args: [],
    );
  }

  /// `Organization Address:`
  String get org_address_label {
    return Intl.message(
      'Organization Address:',
      name: 'org_address_label',
      desc: '',
      args: [],
    );
  }

  /// `City:`
  String get city_label {
    return Intl.message('City:', name: 'city_label', desc: '', args: []);
  }

  /// `Address:`
  String get address_label {
    return Intl.message('Address:', name: 'address_label', desc: '', args: []);
  }

  /// `Add Address`
  String get add_address {
    return Intl.message('Add Address', name: 'add_address', desc: '', args: []);
  }

  /// `Organization Manager:`
  String get manager_org_title {
    return Intl.message(
      'Organization Manager:',
      name: 'manager_org_title',
      desc: '',
      args: [],
    );
  }

  /// `unknown`
  String get unknown {
    return Intl.message('unknown', name: 'unknown', desc: '', args: []);
  }

  /// `Phone:`
  String get manager_phone {
    return Intl.message('Phone:', name: 'manager_phone', desc: '', args: []);
  }

  /// `Status:`
  String get status_label {
    return Intl.message('Status:', name: 'status_label', desc: '', args: []);
  }

  /// `Active`
  String get active {
    return Intl.message('Active', name: 'active', desc: '', args: []);
  }

  /// `Inactive`
  String get inactive {
    return Intl.message('Inactive', name: 'inactive', desc: '', args: []);
  }

  /// `No managers found`
  String get no_managers_found {
    return Intl.message(
      'No managers found',
      name: 'no_managers_found',
      desc: '',
      args: [],
    );
  }

  /// `You have no managers`
  String get no_managers {
    return Intl.message(
      'You have no managers',
      name: 'no_managers',
      desc: '',
      args: [],
    );
  }

  /// `Address added successfully`
  String get address_added {
    return Intl.message(
      'Address added successfully',
      name: 'address_added',
      desc: '',
      args: [],
    );
  }

  /// `Error adding address`
  String get address_add_error {
    return Intl.message(
      'Error adding address',
      name: 'address_add_error',
      desc: '',
      args: [],
    );
  }

  /// `Address deleted successfully`
  String get address_deleted {
    return Intl.message(
      'Address deleted successfully',
      name: 'address_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Manager added successfully`
  String get manager_added {
    return Intl.message(
      'Manager added successfully',
      name: 'manager_added',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in all fields`
  String get fields_empty {
    return Intl.message(
      'Please fill in all fields',
      name: 'fields_empty',
      desc: '',
      args: [],
    );
  }

  /// `Manager updated successfully`
  String get manager_edited {
    return Intl.message(
      'Manager updated successfully',
      name: 'manager_edited',
      desc: '',
      args: [],
    );
  }

  /// `Manager deleted successfully`
  String get manager_deleted {
    return Intl.message(
      'Manager deleted successfully',
      name: 'manager_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Failed to delete manager`
  String get manager_delete_error {
    return Intl.message(
      'Failed to delete manager',
      name: 'manager_delete_error',
      desc: '',
      args: [],
    );
  }

  /// `Organization information is missing`
  String get org_info_missing {
    return Intl.message(
      'Organization information is missing',
      name: 'org_info_missing',
      desc: '',
      args: [],
    );
  }

  /// `No organization data`
  String get no_org_data {
    return Intl.message(
      'No organization data',
      name: 'no_org_data',
      desc: '',
      args: [],
    );
  }

  /// `Error loading address`
  String get address_load_error {
    return Intl.message(
      'Error loading address',
      name: 'address_load_error',
      desc: '',
      args: [],
    );
  }

  /// `Error loading manager`
  String get manager_load_error {
    return Intl.message(
      'Error loading manager',
      name: 'manager_load_error',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get orders_header {
    return Intl.message('Orders', name: 'orders_header', desc: '', args: []);
  }

  /// `New Orders`
  String get new_orders {
    return Intl.message('New Orders', name: 'new_orders', desc: '', args: []);
  }

  /// `Processing Orders`
  String get processing_orders {
    return Intl.message(
      'Processing Orders',
      name: 'processing_orders',
      desc: '',
      args: [],
    );
  }

  /// `Delivered Orders`
  String get delivered_orders {
    return Intl.message(
      'Delivered Orders',
      name: 'delivered_orders',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled Orders`
  String get cancelled_orders {
    return Intl.message(
      'Cancelled Orders',
      name: 'cancelled_orders',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get goods_header {
    return Intl.message('Products', name: 'goods_header', desc: '', args: []);
  }

  /// `Active Products`
  String get active_goods {
    return Intl.message(
      'Active Products',
      name: 'active_goods',
      desc: '',
      args: [],
    );
  }

  /// `Inactive Products`
  String get inactive_goods {
    return Intl.message(
      'Inactive Products',
      name: 'inactive_goods',
      desc: '',
      args: [],
    );
  }

  /// `Awaiting`
  String get waiting_goods {
    return Intl.message('Awaiting', name: 'waiting_goods', desc: '', args: []);
  }

  /// `Returns`
  String get returns_header {
    return Intl.message('Returns', name: 'returns_header', desc: '', args: []);
  }

  /// `Return Requests`
  String get new_returns {
    return Intl.message(
      'Return Requests',
      name: 'new_returns',
      desc: '',
      args: [],
    );
  }

  /// `Closed Return Requests`
  String get completed_returns {
    return Intl.message(
      'Closed Return Requests',
      name: 'completed_returns',
      desc: '',
      args: [],
    );
  }

  /// `Add your first product`
  String get add_first_product {
    return Intl.message(
      'Add your first product',
      name: 'add_first_product',
      desc: '',
      args: [],
    );
  }

  /// `Open chat with Bolshek`
  String get open_chat_with_bolshek {
    return Intl.message(
      'Open chat with Bolshek',
      name: 'open_chat_with_bolshek',
      desc: '',
      args: [],
    );
  }

  /// `Failed to open WhatsApp`
  String get whatsapp_launch_error {
    return Intl.message(
      'Failed to open WhatsApp',
      name: 'whatsapp_launch_error',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get bottom_nav_home {
    return Intl.message('Home', name: 'bottom_nav_home', desc: '', args: []);
  }

  /// `Orders`
  String get bottom_nav_orders {
    return Intl.message(
      'Orders',
      name: 'bottom_nav_orders',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get bottom_nav_goods {
    return Intl.message(
      'Products',
      name: 'bottom_nav_goods',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get bottom_nav_settings {
    return Intl.message(
      'Settings',
      name: 'bottom_nav_settings',
      desc: '',
      args: [],
    );
  }

  /// `No addresses found`
  String get no_address_found {
    return Intl.message(
      'No addresses found',
      name: 'no_address_found',
      desc: '',
      args: [],
    );
  }

  /// `And start selling\nat the Store on Bolshek.kz`
  String get empty_state_description {
    return Intl.message(
      'And start selling\nat the Store on Bolshek.kz',
      name: 'empty_state_description',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get orders_tab_new {
    return Intl.message('New', name: 'orders_tab_new', desc: '', args: []);
  }

  /// `Paid`
  String get orders_tab_paid {
    return Intl.message('Paid', name: 'orders_tab_paid', desc: '', args: []);
  }

  /// `Processing`
  String get orders_tab_processing {
    return Intl.message(
      'Processing',
      name: 'orders_tab_processing',
      desc: '',
      args: [],
    );
  }

  /// `Delivered`
  String get orders_tab_delivered {
    return Intl.message(
      'Delivered',
      name: 'orders_tab_delivered',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled`
  String get orders_tab_cancelled {
    return Intl.message(
      'Cancelled',
      name: 'orders_tab_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get goods_tab_active {
    return Intl.message('Active', name: 'goods_tab_active', desc: '', args: []);
  }

  /// `Awaiting`
  String get goods_tab_awaiting {
    return Intl.message(
      'Awaiting',
      name: 'goods_tab_awaiting',
      desc: '',
      args: [],
    );
  }

  /// `Inactive`
  String get goods_tab_inactive {
    return Intl.message(
      'Inactive',
      name: 'goods_tab_inactive',
      desc: '',
      args: [],
    );
  }

  /// `Change Price`
  String get change_price_dialog_title {
    return Intl.message(
      'Change Price',
      name: 'change_price_dialog_title',
      desc: '',
      args: [],
    );
  }

  /// `Enter new price`
  String get enter_new_price_hint {
    return Intl.message(
      'Enter new price',
      name: 'enter_new_price_hint',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Price updated successfully`
  String get price_update_success {
    return Intl.message(
      'Price updated successfully',
      name: 'price_update_success',
      desc: '',
      args: [],
    );
  }

  /// `Load error: `
  String get load_error {
    return Intl.message('Load error: ', name: 'load_error', desc: '', args: []);
  }

  /// `No price variants available for the product`
  String get no_price_variants {
    return Intl.message(
      'No price variants available for the product',
      name: 'no_price_variants',
      desc: '',
      args: [],
    );
  }

  /// `There are no products\nin this section`
  String get no_products_message {
    return Intl.message(
      'There are no products\nin this section',
      name: 'no_products_message',
      desc: '',
      args: [],
    );
  }

  /// `View Product`
  String get view_product {
    return Intl.message(
      'View Product',
      name: 'view_product',
      desc: '',
      args: [],
    );
  }

  /// `Change price`
  String get change_price {
    return Intl.message(
      'Change price',
      name: 'change_price',
      desc: '',
      args: [],
    );
  }

  /// `Edit Product`
  String get edit_product {
    return Intl.message(
      'Edit Product',
      name: 'edit_product',
      desc: '',
      args: [],
    );
  }

  /// `No name`
  String get no_name {
    return Intl.message('No name', name: 'no_name', desc: '', args: []);
  }

  /// `Price not specified`
  String get price_not_specified {
    return Intl.message(
      'Price not specified',
      name: 'price_not_specified',
      desc: '',
      args: [],
    );
  }

  /// `Add new product`
  String get add_new_good {
    return Intl.message(
      'Add new product',
      name: 'add_new_good',
      desc: '',
      args: [],
    );
  }

  /// `There are no orders in this section`
  String get no_orders_message {
    return Intl.message(
      'There are no orders in this section',
      name: 'no_orders_message',
      desc: '',
      args: [],
    );
  }

  /// `Invalid date`
  String get invalid_date {
    return Intl.message(
      'Invalid date',
      name: 'invalid_date',
      desc: '',
      args: [],
    );
  }

  /// `Address not specified`
  String get address_not_specified {
    return Intl.message(
      'Address not specified',
      name: 'address_not_specified',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown_order {
    return Intl.message('Unknown', name: 'unknown_order', desc: '', args: []);
  }

  /// `Date not specified`
  String get date_not_specified {
    return Intl.message(
      'Date not specified',
      name: 'date_not_specified',
      desc: '',
      args: [],
    );
  }

  /// `#`
  String get order_number_prefix {
    return Intl.message('#', name: 'order_number_prefix', desc: '', args: []);
  }

  /// `more items`
  String get additional_items {
    return Intl.message(
      'more items',
      name: 'additional_items',
      desc: '',
      args: [],
    );
  }

  /// `Address:`
  String get address_prefix {
    return Intl.message('Address:', name: 'address_prefix', desc: '', args: []);
  }

  /// `Status:`
  String get status_prefix {
    return Intl.message('Status:', name: 'status_prefix', desc: '', args: []);
  }

  /// `Date:`
  String get date_prefix {
    return Intl.message('Date:', name: 'date_prefix', desc: '', args: []);
  }

  /// `Order Details`
  String get order_details {
    return Intl.message(
      'Order Details',
      name: 'order_details',
      desc: '',
      args: [],
    );
  }

  /// `Order №`
  String get order_prefix {
    return Intl.message('Order №', name: 'order_prefix', desc: '', args: []);
  }

  /// `Error:`
  String get error_prefix {
    return Intl.message('Error:', name: 'error_prefix', desc: '', args: []);
  }

  /// `Order data not found`
  String get order_data_not_found {
    return Intl.message(
      'Order data not found',
      name: 'order_data_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Order Composition`
  String get order_composition {
    return Intl.message(
      'Order Composition',
      name: 'order_composition',
      desc: '',
      args: [],
    );
  }

  /// `No items in the order`
  String get order_empty {
    return Intl.message(
      'No items in the order',
      name: 'order_empty',
      desc: '',
      args: [],
    );
  }

  /// `Total amount`
  String get total_amount {
    return Intl.message(
      'Total amount',
      name: 'total_amount',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Fee`
  String get delivery_amount {
    return Intl.message(
      'Delivery Fee',
      name: 'delivery_amount',
      desc: '',
      args: [],
    );
  }

  /// `Final Amount`
  String get final_amount {
    return Intl.message(
      'Final Amount',
      name: 'final_amount',
      desc: '',
      args: [],
    );
  }

  /// `Order Date`
  String get order_date {
    return Intl.message('Order Date', name: 'order_date', desc: '', args: []);
  }

  /// `Buyer`
  String get buyer {
    return Intl.message('Buyer', name: 'buyer', desc: '', args: []);
  }

  /// `Transactions`
  String get transactions {
    return Intl.message(
      'Transactions',
      name: 'transactions',
      desc: '',
      args: [],
    );
  }

  /// `Cashless Payment`
  String get cashless_payment {
    return Intl.message(
      'Cashless Payment',
      name: 'cashless_payment',
      desc: '',
      args: [],
    );
  }

  /// `Cash`
  String get cash_payment {
    return Intl.message('Cash', name: 'cash_payment', desc: '', args: []);
  }

  /// `Freedom Bank`
  String get freedom_pay {
    return Intl.message(
      'Freedom Bank',
      name: 'freedom_pay',
      desc: '',
      args: [],
    );
  }

  /// `Not specified`
  String get not_specified {
    return Intl.message(
      'Not specified',
      name: 'not_specified',
      desc: '',
      args: [],
    );
  }

  /// `Cannot launch`
  String get cannot_launch {
    return Intl.message(
      'Cannot launch',
      name: 'cannot_launch',
      desc: '',
      args: [],
    );
  }

  /// `Status update error:`
  String get status_update_error {
    return Intl.message(
      'Status update error:',
      name: 'status_update_error',
      desc: '',
      args: [],
    );
  }

  /// `Confirm action`
  String get confirm_action {
    return Intl.message(
      'Confirm action',
      name: 'confirm_action',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to cancel the item? This action is irreversible.`
  String get cancel_item_confirmation {
    return Intl.message(
      'Are you sure you want to cancel the item? This action is irreversible.',
      name: 'cancel_item_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel_action {
    return Intl.message('Cancel', name: 'cancel_action', desc: '', args: []);
  }

  /// `Item canceled successfully`
  String get item_cancel_success {
    return Intl.message(
      'Item canceled successfully',
      name: 'item_cancel_success',
      desc: '',
      args: [],
    );
  }

  /// `Item ID cannot be null`
  String get item_id_null_error {
    return Intl.message(
      'Item ID cannot be null',
      name: 'item_id_null_error',
      desc: '',
      args: [],
    );
  }

  /// `Item cancellation error:`
  String get cancel_item_error {
    return Intl.message(
      'Item cancellation error:',
      name: 'cancel_item_error',
      desc: '',
      args: [],
    );
  }

  /// `Select new status`
  String get select_new_status {
    return Intl.message(
      'Select new status',
      name: 'select_new_status',
      desc: '',
      args: [],
    );
  }

  /// `Price:`
  String get price_prefix {
    return Intl.message('Price:', name: 'price_prefix', desc: '', args: []);
  }

  /// `Change item status`
  String get change_item_status {
    return Intl.message(
      'Change item status',
      name: 'change_item_status',
      desc: '',
      args: [],
    );
  }

  /// `Cancel item`
  String get cancel_item {
    return Intl.message('Cancel item', name: 'cancel_item', desc: '', args: []);
  }

  /// `New`
  String get order_status_new {
    return Intl.message('New', name: 'order_status_new', desc: '', args: []);
  }

  /// `Awaiting Payment`
  String get order_status_awaiting_payment {
    return Intl.message(
      'Awaiting Payment',
      name: 'order_status_awaiting_payment',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get order_status_paid {
    return Intl.message('Paid', name: 'order_status_paid', desc: '', args: []);
  }

  /// `Awaiting Confirmation`
  String get order_status_awaiting_confirmation {
    return Intl.message(
      'Awaiting Confirmation',
      name: 'order_status_awaiting_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Processing`
  String get order_status_processing {
    return Intl.message(
      'Processing',
      name: 'order_status_processing',
      desc: '',
      args: [],
    );
  }

  /// `Created`
  String get order_status_created {
    return Intl.message(
      'Created',
      name: 'order_status_created',
      desc: '',
      args: [],
    );
  }

  /// `Partially Delivered`
  String get order_status_partially_delivered {
    return Intl.message(
      'Partially Delivered',
      name: 'order_status_partially_delivered',
      desc: '',
      args: [],
    );
  }

  /// `Delivered`
  String get order_status_delivered {
    return Intl.message(
      'Delivered',
      name: 'order_status_delivered',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get order_status_completed {
    return Intl.message(
      'Completed',
      name: 'order_status_completed',
      desc: '',
      args: [],
    );
  }

  /// `Partially Cancelled`
  String get order_status_partially_cancelled {
    return Intl.message(
      'Partially Cancelled',
      name: 'order_status_partially_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Partially Returned`
  String get order_status_partially_returned {
    return Intl.message(
      'Partially Returned',
      name: 'order_status_partially_returned',
      desc: '',
      args: [],
    );
  }

  /// `Returned`
  String get order_status_returned {
    return Intl.message(
      'Returned',
      name: 'order_status_returned',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled`
  String get order_status_cancelled {
    return Intl.message(
      'Cancelled',
      name: 'order_status_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Shipped`
  String get order_status_shipped {
    return Intl.message(
      'Shipped',
      name: 'order_status_shipped',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled by Seller`
  String get order_status_rejected {
    return Intl.message(
      'Cancelled by Seller',
      name: 'order_status_rejected',
      desc: '',
      args: [],
    );
  }

  /// `Awaiting Pick Up`
  String get order_status_awaiting_pick_up {
    return Intl.message(
      'Awaiting Pick Up',
      name: 'order_status_awaiting_pick_up',
      desc: '',
      args: [],
    );
  }

  /// `Awaiting Refund`
  String get order_status_awaiting_refund {
    return Intl.message(
      'Awaiting Refund',
      name: 'order_status_awaiting_refund',
      desc: '',
      args: [],
    );
  }

  /// `Product name is missing`
  String get product_name_absent {
    return Intl.message(
      'Product name is missing',
      name: 'product_name_absent',
      desc: '',
      args: [],
    );
  }

  /// `Product description is missing`
  String get product_description_absent {
    return Intl.message(
      'Product description is missing',
      name: 'product_description_absent',
      desc: '',
      args: [],
    );
  }

  /// `No available image`
  String get no_available_image {
    return Intl.message(
      'No available image',
      name: 'no_available_image',
      desc: '',
      args: [],
    );
  }

  /// `Price not available`
  String get price_absent {
    return Intl.message(
      'Price not available',
      name: 'price_absent',
      desc: '',
      args: [],
    );
  }

  /// `Product amount`
  String get product_amount {
    return Intl.message(
      'Product amount',
      name: 'product_amount',
      desc: '',
      args: [],
    );
  }

  /// `Enter new price`
  String get enter_new_price {
    return Intl.message(
      'Enter new price',
      name: 'enter_new_price',
      desc: '',
      args: [],
    );
  }

  /// `Discount percent`
  String get discount_percent {
    return Intl.message(
      'Discount percent',
      name: 'discount_percent',
      desc: '',
      args: [],
    );
  }

  /// `Enter discount percent`
  String get enter_discount_percent {
    return Intl.message(
      'Enter discount percent',
      name: 'enter_discount_percent',
      desc: '',
      args: [],
    );
  }

  /// `Discount amount`
  String get discount_amount {
    return Intl.message(
      'Discount amount',
      name: 'discount_amount',
      desc: '',
      args: [],
    );
  }

  /// `Price updated successfully`
  String get price_updated {
    return Intl.message(
      'Price updated successfully',
      name: 'price_updated',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Description is missing`
  String get description_absent {
    return Intl.message(
      'Description is missing',
      name: 'description_absent',
      desc: '',
      args: [],
    );
  }

  /// `Title missing`
  String get characteristic_title_absent {
    return Intl.message(
      'Title missing',
      name: 'characteristic_title_absent',
      desc: '',
      args: [],
    );
  }

  /// `Value missing`
  String get characteristic_value_absent {
    return Intl.message(
      'Value missing',
      name: 'characteristic_value_absent',
      desc: '',
      args: [],
    );
  }

  /// `Product code`
  String get product_code {
    return Intl.message(
      'Product code',
      name: 'product_code',
      desc: '',
      args: [],
    );
  }

  /// `Manufacturer`
  String get manufacturer {
    return Intl.message(
      'Manufacturer',
      name: 'manufacturer',
      desc: '',
      args: [],
    );
  }

  /// `Characteristics`
  String get characteristics {
    return Intl.message(
      'Characteristics',
      name: 'characteristics',
      desc: '',
      args: [],
    );
  }

  /// `Publish`
  String get publish {
    return Intl.message('Publish', name: 'publish', desc: '', args: []);
  }

  /// `Remove from sale`
  String get from_sale {
    return Intl.message(
      'Remove from sale',
      name: 'from_sale',
      desc: '',
      args: [],
    );
  }

  /// `Edit product`
  String get change_product {
    return Intl.message(
      'Edit product',
      name: 'change_product',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation`
  String get confirmation {
    return Intl.message(
      'Confirmation',
      name: 'confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to publish the product?`
  String get publish_confirmation {
    return Intl.message(
      'Are you sure you want to publish the product?',
      name: 'publish_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove the product from sale?`
  String get remove_sale_confirmation {
    return Intl.message(
      'Are you sure you want to remove the product from sale?',
      name: 'remove_sale_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Product submitted for publication`
  String get product_published {
    return Intl.message(
      'Product submitted for publication',
      name: 'product_published',
      desc: '',
      args: [],
    );
  }

  /// `Product removed from sale`
  String get product_removed {
    return Intl.message(
      'Product removed from sale',
      name: 'product_removed',
      desc: '',
      args: [],
    );
  }

  /// `Original`
  String get original {
    return Intl.message('Original', name: 'original', desc: '', args: []);
  }

  /// `Sub-original`
  String get sub_original {
    return Intl.message(
      'Sub-original',
      name: 'sub_original',
      desc: '',
      args: [],
    );
  }

  /// `Auto disassembly`
  String get auto_disassembly {
    return Intl.message(
      'Auto disassembly',
      name: 'auto_disassembly',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown_variant {
    return Intl.message('Unknown', name: 'unknown_variant', desc: '', args: []);
  }

  /// `Article`
  String get article {
    return Intl.message('Article', name: 'article', desc: '', args: []);
  }

  /// `Tag`
  String get tag_default {
    return Intl.message('Tag', name: 'tag_default', desc: '', args: []);
  }

  /// `Enter product name`
  String get enter_product_name {
    return Intl.message(
      'Enter product name',
      name: 'enter_product_name',
      desc: '',
      args: [],
    );
  }

  /// `Didn't find your product? Add it yourself`
  String get not_found_add_yourself {
    return Intl.message(
      'Didn\'t find your product? Add it yourself',
      name: 'not_found_add_yourself',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get choose {
    return Intl.message('Choose', name: 'choose', desc: '', args: []);
  }

  /// `Upload 1 to 5 photos`
  String get upload_photos {
    return Intl.message(
      'Upload 1 to 5 photos',
      name: 'upload_photos',
      desc: '',
      args: [],
    );
  }

  /// `Product Name`
  String get product_name {
    return Intl.message(
      'Product Name',
      name: 'product_name',
      desc: '',
      args: [],
    );
  }

  /// `Brand`
  String get brand {
    return Intl.message('Brand', name: 'brand', desc: '', args: []);
  }

  /// `Category`
  String get category {
    return Intl.message('Category', name: 'category', desc: '', args: []);
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `Enter price`
  String get enter_price {
    return Intl.message('Enter price', name: 'enter_price', desc: '', args: []);
  }

  /// `KZT`
  String get currency {
    return Intl.message('KZT', name: 'currency', desc: '', args: []);
  }

  /// `Continue`
  String get continue_text {
    return Intl.message('Continue', name: 'continue_text', desc: '', args: []);
  }

  /// `Please enter a valid price.`
  String get enter_valid_price {
    return Intl.message(
      'Please enter a valid price.',
      name: 'enter_valid_price',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in all required fields before continuing.`
  String get fill_required_fields {
    return Intl.message(
      'Please fill in all required fields before continuing.',
      name: 'fill_required_fields',
      desc: '',
      args: [],
    );
  }

  /// `Choose a brand`
  String get choose_brand {
    return Intl.message(
      'Choose a brand',
      name: 'choose_brand',
      desc: '',
      args: [],
    );
  }

  /// `Choose a category`
  String get choose_category {
    return Intl.message(
      'Choose a category',
      name: 'choose_category',
      desc: '',
      args: [],
    );
  }

  /// `The category list is empty`
  String get categories_empty {
    return Intl.message(
      'The category list is empty',
      name: 'categories_empty',
      desc: '',
      args: [],
    );
  }

  /// `Search category`
  String get category_search {
    return Intl.message(
      'Search category',
      name: 'category_search',
      desc: '',
      args: [],
    );
  }

  /// `Search brand`
  String get brand_search {
    return Intl.message(
      'Search brand',
      name: 'brand_search',
      desc: '',
      args: [],
    );
  }

  /// `No brands`
  String get no_brands {
    return Intl.message('No brands', name: 'no_brands', desc: '', args: []);
  }

  /// `Create your own brand`
  String get create_your_brand {
    return Intl.message(
      'Create your own brand',
      name: 'create_your_brand',
      desc: '',
      args: [],
    );
  }

  /// `Add brand`
  String get add_brand {
    return Intl.message('Add brand', name: 'add_brand', desc: '', args: []);
  }

  /// `Enter brand name`
  String get enter_brand_name {
    return Intl.message(
      'Enter brand name',
      name: 'enter_brand_name',
      desc: '',
      args: [],
    );
  }

  /// `Error loading categories`
  String get error_loading_categories {
    return Intl.message(
      'Error loading categories',
      name: 'error_loading_categories',
      desc: '',
      args: [],
    );
  }

  /// `Error loading brands`
  String get error_loading_brands {
    return Intl.message(
      'Error loading brands',
      name: 'error_loading_brands',
      desc: '',
      args: [],
    );
  }

  /// `Failed to compress image`
  String get image_compress_error {
    return Intl.message(
      'Failed to compress image',
      name: 'image_compress_error',
      desc: '',
      args: [],
    );
  }

  /// `File size still exceeds 15 MB after compression`
  String get file_size_exceed {
    return Intl.message(
      'File size still exceeds 15 MB after compression',
      name: 'file_size_exceed',
      desc: '',
      args: [],
    );
  }

  /// `Maximum 5 photos allowed`
  String get max_images_exceeded {
    return Intl.message(
      'Maximum 5 photos allowed',
      name: 'max_images_exceeded',
      desc: '',
      args: [],
    );
  }

  /// `Error selecting image`
  String get error_selecting_image {
    return Intl.message(
      'Error selecting image',
      name: 'error_selecting_image',
      desc: '',
      args: [],
    );
  }

  /// `Error processing file`
  String get error_processing_file {
    return Intl.message(
      'Error processing file',
      name: 'error_processing_file',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message('Camera', name: 'camera', desc: '', args: []);
  }

  /// `Gallery`
  String get gallery {
    return Intl.message('Gallery', name: 'gallery', desc: '', args: []);
  }

  /// `Add Product`
  String get add_product {
    return Intl.message('Add Product', name: 'add_product', desc: '', args: []);
  }

  /// `Info`
  String get info_tab {
    return Intl.message('Info', name: 'info_tab', desc: '', args: []);
  }

  /// `Please fill in all required fields on the Info tab`
  String get fill_required_info {
    return Intl.message(
      'Please fill in all required fields on the Info tab',
      name: 'fill_required_info',
      desc: '',
      args: [],
    );
  }

  /// `Error loading properties`
  String get error_loading_properties {
    return Intl.message(
      'Error loading properties',
      name: 'error_loading_properties',
      desc: '',
      args: [],
    );
  }

  /// `Fill in all fields`
  String get fill_all_fields {
    return Intl.message(
      'Fill in all fields',
      name: 'fill_all_fields',
      desc: '',
      args: [],
    );
  }

  /// `Initialization`
  String get initialization {
    return Intl.message(
      'Initialization',
      name: 'initialization',
      desc: '',
      args: [],
    );
  }

  /// `Creating product`
  String get creating_product {
    return Intl.message(
      'Creating product',
      name: 'creating_product',
      desc: '',
      args: [],
    );
  }

  /// `Product ID not found in response`
  String get product_id_not_found {
    return Intl.message(
      'Product ID not found in response',
      name: 'product_id_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Product created`
  String get product_created {
    return Intl.message(
      'Product created',
      name: 'product_created',
      desc: '',
      args: [],
    );
  }

  /// `Uploading photos`
  String get uploading_photos {
    return Intl.message(
      'Uploading photos',
      name: 'uploading_photos',
      desc: '',
      args: [],
    );
  }

  /// `Photos uploaded`
  String get photos_uploaded {
    return Intl.message(
      'Photos uploaded',
      name: 'photos_uploaded',
      desc: '',
      args: [],
    );
  }

  /// `Creating product variant`
  String get creating_variant {
    return Intl.message(
      'Creating product variant',
      name: 'creating_variant',
      desc: '',
      args: [],
    );
  }

  /// `Product variant created`
  String get variant_created {
    return Intl.message(
      'Product variant created',
      name: 'variant_created',
      desc: '',
      args: [],
    );
  }

  /// `Creating tags`
  String get creating_tags {
    return Intl.message(
      'Creating tags',
      name: 'creating_tags',
      desc: '',
      args: [],
    );
  }

  /// `Tags saved`
  String get tags_saved {
    return Intl.message('Tags saved', name: 'tags_saved', desc: '', args: []);
  }

  /// `Tag list is empty`
  String get tags_empty {
    return Intl.message(
      'Tag list is empty',
      name: 'tags_empty',
      desc: '',
      args: [],
    );
  }

  /// `Saving properties`
  String get saving_properties {
    return Intl.message(
      'Saving properties',
      name: 'saving_properties',
      desc: '',
      args: [],
    );
  }

  /// `Properties saved`
  String get properties_saved {
    return Intl.message(
      'Properties saved',
      name: 'properties_saved',
      desc: '',
      args: [],
    );
  }

  /// `Product successfully created!`
  String get product_created_successfully {
    return Intl.message(
      'Product successfully created!',
      name: 'product_created_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Go to products`
  String get go_to_products {
    return Intl.message(
      'Go to products',
      name: 'go_to_products',
      desc: '',
      args: [],
    );
  }

  /// `Enter number`
  String get enter_number {
    return Intl.message(
      'Enter number',
      name: 'enter_number',
      desc: '',
      args: [],
    );
  }

  /// `Choose color`
  String get choose_color {
    return Intl.message(
      'Choose color',
      name: 'choose_color',
      desc: '',
      args: [],
    );
  }

  /// `Create product`
  String get create_product {
    return Intl.message(
      'Create product',
      name: 'create_product',
      desc: '',
      args: [],
    );
  }

  /// `Variant`
  String get variant {
    return Intl.message('Variant', name: 'variant', desc: '', args: []);
  }

  /// `Choose type`
  String get choose_type {
    return Intl.message('Choose type', name: 'choose_type', desc: '', args: []);
  }

  /// `Delivery methods`
  String get delivery_methods {
    return Intl.message(
      'Delivery methods',
      name: 'delivery_methods',
      desc: '',
      args: [],
    );
  }

  /// `Choose delivery method`
  String get choose_delivery_method {
    return Intl.message(
      'Choose delivery method',
      name: 'choose_delivery_method',
      desc: '',
      args: [],
    );
  }

  /// `Express`
  String get express {
    return Intl.message('Express', name: 'express', desc: '', args: []);
  }

  /// `Standard`
  String get standard {
    return Intl.message('Standard', name: 'standard', desc: '', args: []);
  }

  /// `Custom`
  String get custom_delivery {
    return Intl.message('Custom', name: 'custom_delivery', desc: '', args: []);
  }

  /// `Choose manufacturer`
  String get choose_manufacturer {
    return Intl.message(
      'Choose manufacturer',
      name: 'choose_manufacturer',
      desc: '',
      args: [],
    );
  }

  /// `Tags`
  String get tags {
    return Intl.message('Tags', name: 'tags', desc: '', args: []);
  }

  /// `Choose tags`
  String get choose_tags {
    return Intl.message('Choose tags', name: 'choose_tags', desc: '', args: []);
  }

  /// `SKU`
  String get sku {
    return Intl.message('SKU', name: 'sku', desc: '', args: []);
  }

  /// `Vendor Code`
  String get vendor_code {
    return Intl.message('Vendor Code', name: 'vendor_code', desc: '', args: []);
  }

  /// `Search manufacturer`
  String get manufacturer_search {
    return Intl.message(
      'Search manufacturer',
      name: 'manufacturer_search',
      desc: '',
      args: [],
    );
  }

  /// `Add manufacturer`
  String get add_manufacturer {
    return Intl.message(
      'Add manufacturer',
      name: 'add_manufacturer',
      desc: '',
      args: [],
    );
  }

  /// `Manufacturer name`
  String get manufacturer_name {
    return Intl.message(
      'Manufacturer name',
      name: 'manufacturer_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter name`
  String get enter_manufacturer_name {
    return Intl.message(
      'Enter name',
      name: 'enter_manufacturer_name',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle compatibility`
  String get vehicle_compatibility {
    return Intl.message(
      'Vehicle compatibility',
      name: 'vehicle_compatibility',
      desc: '',
      args: [],
    );
  }

  /// `Choose suitable brands`
  String get choose_vehicle {
    return Intl.message(
      'Choose suitable brands',
      name: 'choose_vehicle',
      desc: '',
      args: [],
    );
  }

  /// `Properties not found`
  String get properties_not_found {
    return Intl.message(
      'Properties not found',
      name: 'properties_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching data`
  String get errorFetchingData {
    return Intl.message(
      'Error fetching data',
      name: 'errorFetchingData',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching alternative numbers`
  String get errorFetchingAlternatives {
    return Intl.message(
      'Error fetching alternative numbers',
      name: 'errorFetchingAlternatives',
      desc: '',
      args: [],
    );
  }

  /// `Choose appropriate brands`
  String get chooseAppropriateBrands {
    return Intl.message(
      'Choose appropriate brands',
      name: 'chooseAppropriateBrands',
      desc: '',
      args: [],
    );
  }

  /// `Enter OEM number`
  String get enterOEMNumber {
    return Intl.message(
      'Enter OEM number',
      name: 'enterOEMNumber',
      desc: '',
      args: [],
    );
  }

  /// `Alternative OEM numbers`
  String get alternativeOEMNumbers {
    return Intl.message(
      'Alternative OEM numbers',
      name: 'alternativeOEMNumbers',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle mapping`
  String get vehicleMapping {
    return Intl.message(
      'Vehicle mapping',
      name: 'vehicleMapping',
      desc: '',
      args: [],
    );
  }

  /// `Primary OEM number`
  String get primaryOEMNumber {
    return Intl.message(
      'Primary OEM number',
      name: 'primaryOEMNumber',
      desc: '',
      args: [],
    );
  }

  /// `OEM number`
  String get oemNumber {
    return Intl.message('OEM number', name: 'oemNumber', desc: '', args: []);
  }

  /// `Add another mapping`
  String get addAnotherMapping {
    return Intl.message(
      'Add another mapping',
      name: 'addAnotherMapping',
      desc: '',
      args: [],
    );
  }

  /// `Car brand`
  String get carBrand {
    return Intl.message('Car brand', name: 'carBrand', desc: '', args: []);
  }

  /// `Search by brand`
  String get searchByBrand {
    return Intl.message(
      'Search by brand',
      name: 'searchByBrand',
      desc: '',
      args: [],
    );
  }

  /// `Search by model`
  String get searchByModel {
    return Intl.message(
      'Search by model',
      name: 'searchByModel',
      desc: '',
      args: [],
    );
  }

  /// `Success!`
  String get success {
    return Intl.message('Success!', name: 'success', desc: '', args: []);
  }

  /// `Product successfully created`
  String get productCreated {
    return Intl.message(
      'Product successfully created',
      name: 'productCreated',
      desc: '',
      args: [],
    );
  }

  /// `Failed to open link:`
  String get failedToOpenLink {
    return Intl.message(
      'Failed to open link:',
      name: 'failedToOpenLink',
      desc: '',
      args: [],
    );
  }

  /// `Product photos`
  String get productPhotos {
    return Intl.message(
      'Product photos',
      name: 'productPhotos',
      desc: '',
      args: [],
    );
  }

  /// `No image`
  String get noImage {
    return Intl.message('No image', name: 'noImage', desc: '', args: []);
  }

  /// `View product on bolshek.kz`
  String get viewProduct {
    return Intl.message(
      'View product on bolshek.kz',
      name: 'viewProduct',
      desc: '',
      args: [],
    );
  }

  /// `Product name`
  String get productName {
    return Intl.message(
      'Product name',
      name: 'productName',
      desc: '',
      args: [],
    );
  }

  /// `Not specified`
  String get notSpecified {
    return Intl.message(
      'Not specified',
      name: 'notSpecified',
      desc: '',
      args: [],
    );
  }

  /// `Enter price`
  String get enterPrice {
    return Intl.message('Enter price', name: 'enterPrice', desc: '', args: []);
  }

  /// `Create product`
  String get createProduct {
    return Intl.message(
      'Create product',
      name: 'createProduct',
      desc: '',
      args: [],
    );
  }

  /// `Editing is available only after the product is created`
  String get editOnlyAfterProductCreated {
    return Intl.message(
      'Editing is available only after the product is created',
      name: 'editOnlyAfterProductCreated',
      desc: '',
      args: [],
    );
  }

  /// `Product is out of stock`
  String get productOutOfStock {
    return Intl.message(
      'Product is out of stock',
      name: 'productOutOfStock',
      desc: '',
      args: [],
    );
  }

  /// `New order received`
  String get orderCreated {
    return Intl.message(
      'New order received',
      name: 'orderCreated',
      desc: '',
      args: [],
    );
  }

  /// `Order delivered`
  String get orderDelivered {
    return Intl.message(
      'Order delivered',
      name: 'orderDelivered',
      desc: '',
      args: [],
    );
  }

  /// `Order canceled`
  String get orderCanceled {
    return Intl.message(
      'Order canceled',
      name: 'orderCanceled',
      desc: '',
      args: [],
    );
  }

  /// `Order refunded`
  String get orderRefunded {
    return Intl.message(
      'Order refunded',
      name: 'orderRefunded',
      desc: '',
      args: [],
    );
  }

  /// `Order received date:`
  String get orderReceivedDate {
    return Intl.message(
      'Order received date:',
      name: 'orderReceivedDate',
      desc: '',
      args: [],
    );
  }

  /// `Notification not opened`
  String get notificationNotOpened {
    return Intl.message(
      'Notification not opened',
      name: 'notificationNotOpened',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `No notifications`
  String get noNotifications {
    return Intl.message(
      'No notifications',
      name: 'noNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Choose address`
  String get chooseAddress {
    return Intl.message(
      'Choose address',
      name: 'chooseAddress',
      desc: '',
      args: [],
    );
  }

  /// `Address not selected`
  String get addressNotSelected {
    return Intl.message(
      'Address not selected',
      name: 'addressNotSelected',
      desc: '',
      args: [],
    );
  }

  /// `Current address:`
  String get currentAddress {
    return Intl.message(
      'Current address:',
      name: 'currentAddress',
      desc: '',
      args: [],
    );
  }

  /// `Select address`
  String get selectAddress {
    return Intl.message(
      'Select address',
      name: 'selectAddress',
      desc: '',
      args: [],
    );
  }

  /// `Failed to get address`
  String get failedToGetAddress {
    return Intl.message(
      'Failed to get address',
      name: 'failedToGetAddress',
      desc: '',
      args: [],
    );
  }

  /// `Failed to get address (Network error)`
  String get failedToGetAddressNetwork {
    return Intl.message(
      'Failed to get address (Network error)',
      name: 'failedToGetAddressNetwork',
      desc: '',
      args: [],
    );
  }

  /// `Location service disabled`
  String get locationServiceDisabled {
    return Intl.message(
      'Location service disabled',
      name: 'locationServiceDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Location permission denied`
  String get locationPermissionDenied {
    return Intl.message(
      'Location permission denied',
      name: 'locationPermissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `Failed to get coordinates`
  String get failedToGetCoordinates {
    return Intl.message(
      'Failed to get coordinates',
      name: 'failedToGetCoordinates',
      desc: '',
      args: [],
    );
  }

  /// `Error obtaining location`
  String get locationError {
    return Intl.message(
      'Error obtaining location',
      name: 'locationError',
      desc: '',
      args: [],
    );
  }

  /// `Empty list`
  String get empty {
    return Intl.message('Empty list', name: 'empty', desc: '', args: []);
  }

  /// `Product tags:`
  String get productTags {
    return Intl.message(
      'Product tags:',
      name: 'productTags',
      desc: '',
      args: [],
    );
  }

  /// `Available tags:`
  String get availableTags {
    return Intl.message(
      'Available tags:',
      name: 'availableTags',
      desc: '',
      args: [],
    );
  }

  /// `Product successfully updated`
  String get productUpdatedSuccessfully {
    return Intl.message(
      'Product successfully updated',
      name: 'productUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Show product`
  String get showProduct {
    return Intl.message(
      'Show product',
      name: 'showProduct',
      desc: '',
      args: [],
    );
  }

  /// `Product editing`
  String get productEditing {
    return Intl.message(
      'Product editing',
      name: 'productEditing',
      desc: '',
      args: [],
    );
  }

  /// `Repeat`
  String get repeat {
    return Intl.message('Repeat', name: 'repeat', desc: '', args: []);
  }

  /// `Product status`
  String get productStatus {
    return Intl.message(
      'Product status',
      name: 'productStatus',
      desc: '',
      args: [],
    );
  }

  /// `Awaiting moderation`
  String get awaitingModeration {
    return Intl.message(
      'Awaiting moderation',
      name: 'awaitingModeration',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message('Type', name: 'type', desc: '', args: []);
  }

  /// `Product property:`
  String get productProperty {
    return Intl.message(
      'Product property:',
      name: 'productProperty',
      desc: '',
      args: [],
    );
  }

  /// `No available properties`
  String get noAvailableProperties {
    return Intl.message(
      'No available properties',
      name: 'noAvailableProperties',
      desc: '',
      args: [],
    );
  }

  /// `Update product`
  String get updateProduct {
    return Intl.message(
      'Update product',
      name: 'updateProduct',
      desc: '',
      args: [],
    );
  }

  /// `Product update...`
  String get updateProductLoading {
    return Intl.message(
      'Product update...',
      name: 'updateProductLoading',
      desc: '',
      args: [],
    );
  }

  /// `Enter OEM number`
  String get enter_oem_number {
    return Intl.message(
      'Enter OEM number',
      name: 'enter_oem_number',
      desc: '',
      args: [],
    );
  }

  /// `Alternative OEM numbers:`
  String get alternative_oem_numbers {
    return Intl.message(
      'Alternative OEM numbers:',
      name: 'alternative_oem_numbers',
      desc: '',
      args: [],
    );
  }

  /// `Primary OEM number`
  String get primary_oem_number {
    return Intl.message(
      'Primary OEM number',
      name: 'primary_oem_number',
      desc: '',
      args: [],
    );
  }

  /// `OEM number`
  String get oem_number {
    return Intl.message('OEM number', name: 'oem_number', desc: '', args: []);
  }

  /// `Return composition`
  String get return_composition {
    return Intl.message(
      'Return composition',
      name: 'return_composition',
      desc: '',
      args: [],
    );
  }

  /// `Return details`
  String get return_details {
    return Intl.message(
      'Return details',
      name: 'return_details',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Comment`
  String get comment {
    return Intl.message('Comment', name: 'comment', desc: '', args: []);
  }

  /// `Reason`
  String get reason {
    return Intl.message('Reason', name: 'reason', desc: '', args: []);
  }

  /// `Poor quality product`
  String get reason_bad_quality {
    return Intl.message(
      'Poor quality product',
      name: 'reason_bad_quality',
      desc: '',
      args: [],
    );
  }

  /// `Product or packaging damaged`
  String get reason_damaged {
    return Intl.message(
      'Product or packaging damaged',
      name: 'reason_damaged',
      desc: '',
      args: [],
    );
  }

  /// `Incomplete set`
  String get reason_incomplete_set {
    return Intl.message(
      'Incomplete set',
      name: 'reason_incomplete_set',
      desc: '',
      args: [],
    );
  }

  /// `Unknown reason`
  String get reason_unknown {
    return Intl.message(
      'Unknown reason',
      name: 'reason_unknown',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to cancel the return? This action is irreversible.`
  String get are_you_sure_cancel_return {
    return Intl.message(
      'Are you sure you want to cancel the return? This action is irreversible.',
      name: 'are_you_sure_cancel_return',
      desc: '',
      args: [],
    );
  }

  /// `Confirm cancellation`
  String get confirm_cancel {
    return Intl.message(
      'Confirm cancellation',
      name: 'confirm_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Return successfully canceled`
  String get return_canceled_successfully {
    return Intl.message(
      'Return successfully canceled',
      name: 'return_canceled_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Confirm return`
  String get confirm_return {
    return Intl.message(
      'Confirm return',
      name: 'confirm_return',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to accept the return?`
  String get are_you_sure_accept_return {
    return Intl.message(
      'Are you sure you want to accept the return?',
      name: 'are_you_sure_accept_return',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept_return {
    return Intl.message('Accept', name: 'accept_return', desc: '', args: []);
  }

  /// `Error accepting return`
  String get error_accepting_return {
    return Intl.message(
      'Error accepting return',
      name: 'error_accepting_return',
      desc: '',
      args: [],
    );
  }

  /// `Confirm product receipt`
  String get confirm_product_received {
    return Intl.message(
      'Confirm product receipt',
      name: 'confirm_product_received',
      desc: '',
      args: [],
    );
  }

  /// `Confirm product receipt`
  String get are_you_sure_accept_product {
    return Intl.message(
      'Confirm product receipt',
      name: 'are_you_sure_accept_product',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message('Accept', name: 'accept', desc: '', args: []);
  }

  /// `No order data available`
  String get no_order_data {
    return Intl.message(
      'No order data available',
      name: 'no_order_data',
      desc: '',
      args: [],
    );
  }

  /// `Error canceling return`
  String get error_canceling_return {
    return Intl.message(
      'Error canceling return',
      name: 'error_canceling_return',
      desc: '',
      args: [],
    );
  }

  /// `Product ID cannot be null`
  String get product_id_cannot_be_null {
    return Intl.message(
      'Product ID cannot be null',
      name: 'product_id_cannot_be_null',
      desc: '',
      args: [],
    );
  }

  /// `Pick up item`
  String get pick_up_item {
    return Intl.message(
      'Pick up item',
      name: 'pick_up_item',
      desc: '',
      args: [],
    );
  }

  /// `Refund`
  String get refund {
    return Intl.message('Refund', name: 'refund', desc: '', args: []);
  }

  /// `Completed`
  String get completed {
    return Intl.message('Completed', name: 'completed', desc: '', args: []);
  }

  /// `Add Warehouse`
  String get add_warehouse {
    return Intl.message(
      'Add Warehouse',
      name: 'add_warehouse',
      desc: '',
      args: [],
    );
  }

  /// `Manager Data`
  String get manager_data {
    return Intl.message(
      'Manager Data',
      name: 'manager_data',
      desc: '',
      args: [],
    );
  }

  /// `Enter warehouse name`
  String get enter_warehouse_name {
    return Intl.message(
      'Enter warehouse name',
      name: 'enter_warehouse_name',
      desc: '',
      args: [],
    );
  }

  /// `Create Warehouse`
  String get create_warehouse {
    return Intl.message(
      'Create Warehouse',
      name: 'create_warehouse',
      desc: '',
      args: [],
    );
  }

  /// `Your warehouses`
  String get your_warehouse {
    return Intl.message(
      'Your warehouses',
      name: 'your_warehouse',
      desc: '',
      args: [],
    );
  }

  /// `You do not have access`
  String get no_access {
    return Intl.message(
      'You do not have access',
      name: 'no_access',
      desc: '',
      args: [],
    );
  }

  /// `Request permission`
  String get request_permission {
    return Intl.message(
      'Request permission',
      name: 'request_permission',
      desc: '',
      args: [],
    );
  }

  /// `You do not have permission to view warehouses`
  String get no_permission {
    return Intl.message(
      'You do not have permission to view warehouses',
      name: 'no_permission',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'kk'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
