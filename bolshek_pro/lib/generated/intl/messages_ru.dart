// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(error) => "Ошибка загрузки брендов: ${error}";

  static String m1(error) => "Ошибка загрузки категорий: ${error}";

  static String m2(error) => "Ошибка регистрации: ${error}";

  static String m3(seconds) => "Отправить повторно через ${seconds} сек.";

  static String m4(seconds) => "Отправить повторно через ${seconds} сек.";

  static String m5(phoneNumber) => "Мы отправили код на номер ${phoneNumber}.";

  static String m6(error) => "Ошибка при отправке SMS: ${error}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accept": MessageLookupByLibrary.simpleMessage("Принять"),
    "accept_return": MessageLookupByLibrary.simpleMessage("Принять"),
    "accountNotActive": MessageLookupByLibrary.simpleMessage(
      "Ваш аккаунт еще не активен. Пожалуйста, ждите ответа менеджера.",
    ),
    "active": MessageLookupByLibrary.simpleMessage("Активный"),
    "active_goods": MessageLookupByLibrary.simpleMessage("В продаже"),
    "add": MessageLookupByLibrary.simpleMessage("Добавить"),
    "addAnotherMapping": MessageLookupByLibrary.simpleMessage(
      "Добавить еще соответствие",
    ),
    "add_address": MessageLookupByLibrary.simpleMessage("Добавить склад"),
    "add_brand": MessageLookupByLibrary.simpleMessage("Добавить бренд"),
    "add_first_product": MessageLookupByLibrary.simpleMessage(
      "Добавьте первый товар",
    ),
    "add_manager_title": MessageLookupByLibrary.simpleMessage(
      "Заполните данные\nдля добавления менеджера",
    ),
    "add_manufacturer": MessageLookupByLibrary.simpleMessage(
      "Добавить производителя",
    ),
    "add_new_good": MessageLookupByLibrary.simpleMessage(
      "Добавить новый товар",
    ),
    "add_product": MessageLookupByLibrary.simpleMessage("Добавить товар"),
    "add_warehouse": MessageLookupByLibrary.simpleMessage("Добавить склад"),
    "additional_items": MessageLookupByLibrary.simpleMessage("товаров"),
    "address": MessageLookupByLibrary.simpleMessage("Адрес"),
    "addressNotSelected": MessageLookupByLibrary.simpleMessage(
      "Адрес не выбран",
    ),
    "address_add_error": MessageLookupByLibrary.simpleMessage(
      "Ошибка при добавлении адреса",
    ),
    "address_added": MessageLookupByLibrary.simpleMessage(
      "Адрес успешно добавлен",
    ),
    "address_deleted": MessageLookupByLibrary.simpleMessage(
      "Адрес успешно удалён",
    ),
    "address_label": MessageLookupByLibrary.simpleMessage("Адрес:"),
    "address_load_error": MessageLookupByLibrary.simpleMessage(
      "Ошибка загрузки адреса",
    ),
    "address_not_specified": MessageLookupByLibrary.simpleMessage(
      "Адрес не указан",
    ),
    "address_prefix": MessageLookupByLibrary.simpleMessage("Адрес:"),
    "agreementText": MessageLookupByLibrary.simpleMessage(
      "Пользуясь приложением, вы принимаете соглашение и ",
    ),
    "alternativeOEMNumbers": MessageLookupByLibrary.simpleMessage(
      "Альтернативные OEM номера",
    ),
    "alternative_oem_numbers": MessageLookupByLibrary.simpleMessage(
      "Альтернативные OEM номера:",
    ),
    "are_you_sure_accept_product": MessageLookupByLibrary.simpleMessage(
      "Подтвердите получение товара",
    ),
    "are_you_sure_accept_return": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите принять возврат?",
    ),
    "are_you_sure_cancel_return": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите отменить товар? Это действие необратимо.",
    ),
    "article": MessageLookupByLibrary.simpleMessage("Артикул"),
    "auto_disassembly": MessageLookupByLibrary.simpleMessage("Авторазбор"),
    "availableTags": MessageLookupByLibrary.simpleMessage("Доступные теги:"),
    "awaitingModeration": MessageLookupByLibrary.simpleMessage(
      "Ожидает модерации",
    ),
    "bottom_nav_goods": MessageLookupByLibrary.simpleMessage("Товары"),
    "bottom_nav_home": MessageLookupByLibrary.simpleMessage("Главная"),
    "bottom_nav_orders": MessageLookupByLibrary.simpleMessage("Заказы"),
    "bottom_nav_settings": MessageLookupByLibrary.simpleMessage("Настройки"),
    "brand": MessageLookupByLibrary.simpleMessage("Бренд"),
    "brand_search": MessageLookupByLibrary.simpleMessage("Поиск бренда"),
    "brands": MessageLookupByLibrary.simpleMessage("Бренды"),
    "buyer": MessageLookupByLibrary.simpleMessage("Покупатель"),
    "camera": MessageLookupByLibrary.simpleMessage("Камера"),
    "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
    "cancel_action": MessageLookupByLibrary.simpleMessage("Отменить"),
    "cancel_item": MessageLookupByLibrary.simpleMessage("Отменить товар"),
    "cancel_item_confirmation": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите отменить товар? Это действие необратимо.",
    ),
    "cancel_item_error": MessageLookupByLibrary.simpleMessage(
      "Ошибка отмены товара:",
    ),
    "cancelled_orders": MessageLookupByLibrary.simpleMessage(
      "Отмененные заказы",
    ),
    "cannot_launch": MessageLookupByLibrary.simpleMessage(
      "Не удалось запустить",
    ),
    "carBrand": MessageLookupByLibrary.simpleMessage("Марка автомобилей"),
    "cash_payment": MessageLookupByLibrary.simpleMessage("Наличка"),
    "cashless_payment": MessageLookupByLibrary.simpleMessage(
      "Безналичная оплата",
    ),
    "categories": MessageLookupByLibrary.simpleMessage("Категории"),
    "categories_empty": MessageLookupByLibrary.simpleMessage(
      "Список категорий пуст",
    ),
    "category": MessageLookupByLibrary.simpleMessage("Категория"),
    "category_search": MessageLookupByLibrary.simpleMessage("Поиск категории"),
    "change_item_status": MessageLookupByLibrary.simpleMessage(
      "Изменить статус товара",
    ),
    "change_language": MessageLookupByLibrary.simpleMessage("Сменить язык"),
    "change_price": MessageLookupByLibrary.simpleMessage("Изменить цену"),
    "change_price_dialog_title": MessageLookupByLibrary.simpleMessage(
      "Изменить цену",
    ),
    "change_product": MessageLookupByLibrary.simpleMessage("Изменить товар"),
    "characteristic_title_absent": MessageLookupByLibrary.simpleMessage(
      "Название отсутствует",
    ),
    "characteristic_value_absent": MessageLookupByLibrary.simpleMessage(
      "Значение отсутствует",
    ),
    "characteristics": MessageLookupByLibrary.simpleMessage("Характеристики"),
    "choose": MessageLookupByLibrary.simpleMessage("Выбрать"),
    "chooseAddress": MessageLookupByLibrary.simpleMessage("Выберите адрес"),
    "chooseAppropriateBrands": MessageLookupByLibrary.simpleMessage(
      "Выберите подходящие марки",
    ),
    "chooseBrand": MessageLookupByLibrary.simpleMessage("Выберите бренд"),
    "chooseCategory": MessageLookupByLibrary.simpleMessage(
      "Выберите категорию",
    ),
    "choose_brand": MessageLookupByLibrary.simpleMessage("Выберите бренд"),
    "choose_category": MessageLookupByLibrary.simpleMessage(
      "Выберите категорию",
    ),
    "choose_color": MessageLookupByLibrary.simpleMessage("Выберите цвет"),
    "choose_delivery_method": MessageLookupByLibrary.simpleMessage(
      "Выберите метод доставки",
    ),
    "choose_language": MessageLookupByLibrary.simpleMessage("Язык"),
    "choose_manufacturer": MessageLookupByLibrary.simpleMessage(
      "Выберите производителя",
    ),
    "choose_tags": MessageLookupByLibrary.simpleMessage("Выберите теги"),
    "choose_type": MessageLookupByLibrary.simpleMessage("Выберите тип"),
    "choose_vehicle": MessageLookupByLibrary.simpleMessage(
      "Выберите подходящие марки",
    ),
    "city_label": MessageLookupByLibrary.simpleMessage("Город:"),
    "comment": MessageLookupByLibrary.simpleMessage("Комментарий"),
    "completed": MessageLookupByLibrary.simpleMessage("Завершенные"),
    "completed_returns": MessageLookupByLibrary.simpleMessage(
      "Закрытые заявки",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("Подтвердить"),
    "confirm_action": MessageLookupByLibrary.simpleMessage(
      "Подтвердите действие",
    ),
    "confirm_cancel": MessageLookupByLibrary.simpleMessage("Отменить"),
    "confirm_product_received": MessageLookupByLibrary.simpleMessage(
      "Подтвердите получение товара",
    ),
    "confirm_return": MessageLookupByLibrary.simpleMessage(
      "Подтвердите возврат",
    ),
    "confirmation": MessageLookupByLibrary.simpleMessage("Подтверждение"),
    "continue_text": MessageLookupByLibrary.simpleMessage("Продолжить"),
    "createProduct": MessageLookupByLibrary.simpleMessage("Создать товар"),
    "create_product": MessageLookupByLibrary.simpleMessage("Создать товар"),
    "create_warehouse": MessageLookupByLibrary.simpleMessage("Создать склад"),
    "create_your_brand": MessageLookupByLibrary.simpleMessage(
      "Создать свой бренд",
    ),
    "creating_product": MessageLookupByLibrary.simpleMessage("Создание товара"),
    "creating_tags": MessageLookupByLibrary.simpleMessage("Создание теги"),
    "creating_variant": MessageLookupByLibrary.simpleMessage(
      "Создание варианта товара",
    ),
    "currency": MessageLookupByLibrary.simpleMessage("KZT"),
    "currentAddress": MessageLookupByLibrary.simpleMessage("Текущий адрес:"),
    "custom_delivery": MessageLookupByLibrary.simpleMessage("Индивидуальная"),
    "date": MessageLookupByLibrary.simpleMessage("Дата"),
    "date_not_specified": MessageLookupByLibrary.simpleMessage(
      "Дата не указана",
    ),
    "date_prefix": MessageLookupByLibrary.simpleMessage("Дата:"),
    "delete": MessageLookupByLibrary.simpleMessage("Удалить"),
    "delete_address_confirmation": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите удалить этот адрес?",
    ),
    "delete_address_title": MessageLookupByLibrary.simpleMessage(
      "Удаление адреса",
    ),
    "delete_manager_confirmation": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите удалить этого менеджера?",
    ),
    "delete_manager_title": MessageLookupByLibrary.simpleMessage(
      "Подтверждение удаления",
    ),
    "delivered_orders": MessageLookupByLibrary.simpleMessage("Доставки"),
    "delivery_amount": MessageLookupByLibrary.simpleMessage("Сумма доставки"),
    "delivery_methods": MessageLookupByLibrary.simpleMessage("Методы доставки"),
    "description": MessageLookupByLibrary.simpleMessage("Описание"),
    "description_absent": MessageLookupByLibrary.simpleMessage(
      "Описание отсутствует",
    ),
    "discount_amount": MessageLookupByLibrary.simpleMessage("Сумма скидки"),
    "discount_percent": MessageLookupByLibrary.simpleMessage("Процент скидки"),
    "edit": MessageLookupByLibrary.simpleMessage("Изменить"),
    "editOnlyAfterProductCreated": MessageLookupByLibrary.simpleMessage(
      "Изменение доступно только после создания товара",
    ),
    "edit_manager_title": MessageLookupByLibrary.simpleMessage(
      "Данные менеджера",
    ),
    "edit_product": MessageLookupByLibrary.simpleMessage("Редактировать товар"),
    "empty": MessageLookupByLibrary.simpleMessage("Список пуст"),
    "emptyBrandList": MessageLookupByLibrary.simpleMessage(
      "Список брендов пуст",
    ),
    "emptyCategoryList": MessageLookupByLibrary.simpleMessage(
      "Список категорий пуст",
    ),
    "empty_state_description": MessageLookupByLibrary.simpleMessage(
      "И начните продавать\nв Магазине на Bolshek.kz",
    ),
    "enterOEMNumber": MessageLookupByLibrary.simpleMessage("Введите OEM номер"),
    "enterPhone": MessageLookupByLibrary.simpleMessage(
      "Введите номер телефона",
    ),
    "enterPrice": MessageLookupByLibrary.simpleMessage("Введите цену"),
    "enterValidPhone": MessageLookupByLibrary.simpleMessage(
      "Введите корректный номер",
    ),
    "enter_brand_name": MessageLookupByLibrary.simpleMessage(
      "Введите название бренда",
    ),
    "enter_discount_percent": MessageLookupByLibrary.simpleMessage(
      "Введите процент скидки",
    ),
    "enter_manufacturer_name": MessageLookupByLibrary.simpleMessage(
      "Введите название",
    ),
    "enter_new_price": MessageLookupByLibrary.simpleMessage(
      "Введите новую цену",
    ),
    "enter_new_price_hint": MessageLookupByLibrary.simpleMessage(
      "Введите новую цену",
    ),
    "enter_number": MessageLookupByLibrary.simpleMessage("Введите число"),
    "enter_oem_number": MessageLookupByLibrary.simpleMessage(
      "Введите OEM номер",
    ),
    "enter_phone": MessageLookupByLibrary.simpleMessage("Введите номер"),
    "enter_price": MessageLookupByLibrary.simpleMessage("Введите цену"),
    "enter_product_name": MessageLookupByLibrary.simpleMessage(
      "Введите название товара",
    ),
    "enter_sms_code": MessageLookupByLibrary.simpleMessage("Введите SMS-код"),
    "enter_valid_price": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите корректную цену.",
    ),
    "enter_warehouse_name": MessageLookupByLibrary.simpleMessage(
      "Введите название склада",
    ),
    "error": MessageLookupByLibrary.simpleMessage("Ошибка"),
    "errorFetchingAlternatives": MessageLookupByLibrary.simpleMessage(
      "Ошибка получения альтернативных номеров",
    ),
    "errorFetchingData": MessageLookupByLibrary.simpleMessage(
      "Ошибка при получении данных",
    ),
    "errorLoadingBrands": m0,
    "errorLoadingCategories": m1,
    "error_accepting_return": MessageLookupByLibrary.simpleMessage(
      "Ошибка при принятии возврата",
    ),
    "error_canceling_return": MessageLookupByLibrary.simpleMessage(
      "Ошибка отмены возврата",
    ),
    "error_loading_brands": MessageLookupByLibrary.simpleMessage(
      "Ошибка загрузки брендов",
    ),
    "error_loading_categories": MessageLookupByLibrary.simpleMessage(
      "Ошибка загрузки категорий",
    ),
    "error_loading_properties": MessageLookupByLibrary.simpleMessage(
      "Ошибка загрузки свойств",
    ),
    "error_prefix": MessageLookupByLibrary.simpleMessage("Ошибка:"),
    "error_processing_file": MessageLookupByLibrary.simpleMessage(
      "Ошибка обработки файла",
    ),
    "error_selecting_image": MessageLookupByLibrary.simpleMessage(
      "Ошибка при выборе фото",
    ),
    "express": MessageLookupByLibrary.simpleMessage("Экспресс"),
    "failedToGetAddress": MessageLookupByLibrary.simpleMessage(
      "Не удалось получить адрес",
    ),
    "failedToGetAddressNetwork": MessageLookupByLibrary.simpleMessage(
      "Не удалось получить адрес (Ошибка сети)",
    ),
    "failedToGetCoordinates": MessageLookupByLibrary.simpleMessage(
      "Не удалось получить координаты",
    ),
    "failedToOpenLink": MessageLookupByLibrary.simpleMessage(
      "Не удалось открыть ссылку:",
    ),
    "fields_empty": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, заполните все поля",
    ),
    "file_size_exceed": MessageLookupByLibrary.simpleMessage(
      "Размер файла после сжатия всё ещё превышает 15 МБ",
    ),
    "fill_all_fields": MessageLookupByLibrary.simpleMessage(
      "Заполните все поля",
    ),
    "fill_required_fields": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, заполните все обязательные поля перед продолжением.",
    ),
    "fill_required_info": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, заполните обязательные поля на вкладке «Инфо»",
    ),
    "final_amount": MessageLookupByLibrary.simpleMessage("Итоговая сумма"),
    "firstName": MessageLookupByLibrary.simpleMessage("Имя"),
    "first_name": MessageLookupByLibrary.simpleMessage("Имя"),
    "freedom_pay": MessageLookupByLibrary.simpleMessage("Freedom Bank"),
    "from_sale": MessageLookupByLibrary.simpleMessage("Снять с продажи"),
    "gallery": MessageLookupByLibrary.simpleMessage("Галерея"),
    "goToRegister": MessageLookupByLibrary.simpleMessage("Перейти"),
    "go_to_products": MessageLookupByLibrary.simpleMessage("Перейти к товарам"),
    "goods": MessageLookupByLibrary.simpleMessage("Товары"),
    "goods_header": MessageLookupByLibrary.simpleMessage("Товары"),
    "goods_tab_active": MessageLookupByLibrary.simpleMessage("В продаже"),
    "goods_tab_awaiting": MessageLookupByLibrary.simpleMessage("Ожидает"),
    "goods_tab_inactive": MessageLookupByLibrary.simpleMessage("Неактивные"),
    "home": MessageLookupByLibrary.simpleMessage("Главная"),
    "image_compress_error": MessageLookupByLibrary.simpleMessage(
      "Не удалось сжать изображение",
    ),
    "inactive": MessageLookupByLibrary.simpleMessage("Не активный"),
    "inactive_goods": MessageLookupByLibrary.simpleMessage("Сняти с продажи"),
    "info_tab": MessageLookupByLibrary.simpleMessage("Инфо"),
    "initialization": MessageLookupByLibrary.simpleMessage("Инициализация"),
    "invalidOtp": MessageLookupByLibrary.simpleMessage(
      "Неправильный SMS-код. Попробуйте снова.",
    ),
    "invalid_date": MessageLookupByLibrary.simpleMessage("Некорректная дата"),
    "item_cancel_success": MessageLookupByLibrary.simpleMessage(
      "Товар успешно отменён",
    ),
    "item_id_null_error": MessageLookupByLibrary.simpleMessage(
      "ID товара не может быть null",
    ),
    "lastName": MessageLookupByLibrary.simpleMessage("Фамилия"),
    "last_name": MessageLookupByLibrary.simpleMessage("Фамилия"),
    "load_error": MessageLookupByLibrary.simpleMessage("Ошибка загрузки: "),
    "locationError": MessageLookupByLibrary.simpleMessage(
      "Ошибка при получении местоположения",
    ),
    "locationPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "Нет разрешений на использование геолокации",
    ),
    "locationServiceDisabled": MessageLookupByLibrary.simpleMessage(
      "Сервис геолокации отключён",
    ),
    "login": MessageLookupByLibrary.simpleMessage("У меня есть аккаунт. Войти"),
    "logout_button": MessageLookupByLibrary.simpleMessage("Выйти из аккаунта"),
    "logout_confirmation": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите выйти?",
    ),
    "logout_title": MessageLookupByLibrary.simpleMessage("Выход из аккаунта"),
    "manager_added": MessageLookupByLibrary.simpleMessage(
      "Менеджер успешно добавлен",
    ),
    "manager_data": MessageLookupByLibrary.simpleMessage("Данные менеджера"),
    "manager_delete_error": MessageLookupByLibrary.simpleMessage(
      "Не удалось удалить менеджера",
    ),
    "manager_deleted": MessageLookupByLibrary.simpleMessage(
      "Менеджер успешно удален",
    ),
    "manager_edited": MessageLookupByLibrary.simpleMessage(
      "Менеджер успешно изменен",
    ),
    "manager_load_error": MessageLookupByLibrary.simpleMessage(
      "Ошибка загрузки менеджера",
    ),
    "manager_org_title": MessageLookupByLibrary.simpleMessage(
      "Менеджер организации:",
    ),
    "manager_phone": MessageLookupByLibrary.simpleMessage("Номер:"),
    "manufacturer": MessageLookupByLibrary.simpleMessage("Производитель"),
    "manufacturer_name": MessageLookupByLibrary.simpleMessage(
      "Название производителя",
    ),
    "manufacturer_search": MessageLookupByLibrary.simpleMessage(
      "Поиск производителя",
    ),
    "max_images_exceeded": MessageLookupByLibrary.simpleMessage(
      "Можно загрузить максимум 5 фото",
    ),
    "newUser": MessageLookupByLibrary.simpleMessage("Я новый пользователь"),
    "new_orders": MessageLookupByLibrary.simpleMessage("Новые заказы"),
    "new_returns": MessageLookupByLibrary.simpleMessage("Заявки на возврат"),
    "noAvailableProperties": MessageLookupByLibrary.simpleMessage(
      "Нет доступных свойств",
    ),
    "noImage": MessageLookupByLibrary.simpleMessage("Нет изображения"),
    "noNotifications": MessageLookupByLibrary.simpleMessage("Нет уведомлений"),
    "no_access": MessageLookupByLibrary.simpleMessage("У вас нет доступа"),
    "no_address_found": MessageLookupByLibrary.simpleMessage(
      "Адреса не найдены",
    ),
    "no_available_image": MessageLookupByLibrary.simpleMessage(
      "Нет доступных изображений",
    ),
    "no_brands": MessageLookupByLibrary.simpleMessage("Нет брендов"),
    "no_managers": MessageLookupByLibrary.simpleMessage("У вас нет менеджеров"),
    "no_managers_found": MessageLookupByLibrary.simpleMessage(
      "Менеджеры не найдены",
    ),
    "no_name": MessageLookupByLibrary.simpleMessage("Без названия"),
    "no_order_data": MessageLookupByLibrary.simpleMessage(
      "Данные о заказе отсутствуют",
    ),
    "no_orders_message": MessageLookupByLibrary.simpleMessage(
      "В данном разделе нет заказов",
    ),
    "no_org_data": MessageLookupByLibrary.simpleMessage(
      "Нет данных об организации",
    ),
    "no_permission": MessageLookupByLibrary.simpleMessage(
      "У вас нет разрешения на просмотр складов",
    ),
    "no_price_variants": MessageLookupByLibrary.simpleMessage(
      "У товара нет вариантов с ценой",
    ),
    "no_products_message": MessageLookupByLibrary.simpleMessage(
      "В данном разделе\nнет товаров",
    ),
    "notSpecified": MessageLookupByLibrary.simpleMessage("Не указано"),
    "not_found_add_yourself": MessageLookupByLibrary.simpleMessage(
      "Не нашли ваш товар? Добавьте сами",
    ),
    "not_specified": MessageLookupByLibrary.simpleMessage("Не указано"),
    "notificationNotOpened": MessageLookupByLibrary.simpleMessage(
      "Уведомление не было открыто",
    ),
    "notifications": MessageLookupByLibrary.simpleMessage("Уведомления"),
    "number": MessageLookupByLibrary.simpleMessage("Номер"),
    "numberNotRegistered": MessageLookupByLibrary.simpleMessage(
      "Ваш номер не зарегистрирован.",
    ),
    "number_confirmation": MessageLookupByLibrary.simpleMessage(
      "Подтверждение номера",
    ),
    "oemNumber": MessageLookupByLibrary.simpleMessage("OEM номер"),
    "oem_number": MessageLookupByLibrary.simpleMessage("OEM номер"),
    "ok": MessageLookupByLibrary.simpleMessage("ОК"),
    "openMap": MessageLookupByLibrary.simpleMessage("Открыть карту"),
    "open_chat_with_bolshek": MessageLookupByLibrary.simpleMessage(
      "Открыть чат с Bolshek",
    ),
    "orderCanceled": MessageLookupByLibrary.simpleMessage("Заказ отменён"),
    "orderCreated": MessageLookupByLibrary.simpleMessage(
      "Поступил новый заказ",
    ),
    "orderDelivered": MessageLookupByLibrary.simpleMessage("Заказ доставлен"),
    "orderReceivedDate": MessageLookupByLibrary.simpleMessage(
      "Дата поступления заказа:",
    ),
    "orderRefunded": MessageLookupByLibrary.simpleMessage("Заказ возвращён"),
    "order_composition": MessageLookupByLibrary.simpleMessage("Состав заказа"),
    "order_data_not_found": MessageLookupByLibrary.simpleMessage(
      "Данные о заказе отсутствуют",
    ),
    "order_date": MessageLookupByLibrary.simpleMessage("Дата оформления"),
    "order_details": MessageLookupByLibrary.simpleMessage("Детали заказа"),
    "order_empty": MessageLookupByLibrary.simpleMessage("В заказе нет товаров"),
    "order_number_prefix": MessageLookupByLibrary.simpleMessage("№"),
    "order_prefix": MessageLookupByLibrary.simpleMessage("Заказ №"),
    "order_status_awaiting_confirmation": MessageLookupByLibrary.simpleMessage(
      "Ожидание подтверждения",
    ),
    "order_status_awaiting_payment": MessageLookupByLibrary.simpleMessage(
      "Ожидание оплаты",
    ),
    "order_status_awaiting_pick_up": MessageLookupByLibrary.simpleMessage(
      "Заберите товар",
    ),
    "order_status_awaiting_refund": MessageLookupByLibrary.simpleMessage(
      "Возврат средств",
    ),
    "order_status_cancelled": MessageLookupByLibrary.simpleMessage("Отменен"),
    "order_status_completed": MessageLookupByLibrary.simpleMessage("Завершен"),
    "order_status_created": MessageLookupByLibrary.simpleMessage("Создан"),
    "order_status_delivered": MessageLookupByLibrary.simpleMessage("Доставлен"),
    "order_status_new": MessageLookupByLibrary.simpleMessage("Новый"),
    "order_status_paid": MessageLookupByLibrary.simpleMessage("Оплаченный"),
    "order_status_partially_cancelled": MessageLookupByLibrary.simpleMessage(
      "Частично отменен",
    ),
    "order_status_partially_delivered": MessageLookupByLibrary.simpleMessage(
      "Частично доставлен",
    ),
    "order_status_partially_returned": MessageLookupByLibrary.simpleMessage(
      "Частично возвращен",
    ),
    "order_status_processing": MessageLookupByLibrary.simpleMessage(
      "В обработке",
    ),
    "order_status_rejected": MessageLookupByLibrary.simpleMessage(
      "Отменен продавцом",
    ),
    "order_status_returned": MessageLookupByLibrary.simpleMessage("Возвращен"),
    "order_status_shipped": MessageLookupByLibrary.simpleMessage("Отправлен"),
    "orders": MessageLookupByLibrary.simpleMessage("Заказы"),
    "orders_header": MessageLookupByLibrary.simpleMessage("Заказы"),
    "orders_tab_cancelled": MessageLookupByLibrary.simpleMessage("Отмененные"),
    "orders_tab_delivered": MessageLookupByLibrary.simpleMessage("Доставлены"),
    "orders_tab_new": MessageLookupByLibrary.simpleMessage("Новые"),
    "orders_tab_paid": MessageLookupByLibrary.simpleMessage("Оплаченный"),
    "orders_tab_processing": MessageLookupByLibrary.simpleMessage(
      "В обработке",
    ),
    "org_address_label": MessageLookupByLibrary.simpleMessage(
      "Адрес организации:",
    ),
    "org_info_missing": MessageLookupByLibrary.simpleMessage(
      "Информация об организации отсутствует",
    ),
    "org_name_label": MessageLookupByLibrary.simpleMessage("Имя организации:"),
    "original": MessageLookupByLibrary.simpleMessage("Оригинал"),
    "otpExpired": MessageLookupByLibrary.simpleMessage(
      "Слишком много попыток. Попробуйте позже.",
    ),
    "owner_label": MessageLookupByLibrary.simpleMessage("Владелец:"),
    "phone": MessageLookupByLibrary.simpleMessage("Телефон"),
    "phoneAlreadyRegistered": MessageLookupByLibrary.simpleMessage(
      "Такой номер уже был зарегистрирован",
    ),
    "phoneConfirmation": MessageLookupByLibrary.simpleMessage(
      "Подтверждение номера",
    ),
    "phoneHint": MessageLookupByLibrary.simpleMessage("+7 777 777-77-77"),
    "phoneNotification": MessageLookupByLibrary.simpleMessage(
      "Мы используем ваш номер телефона для уведомлений о заказе",
    ),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("Введите свой номер"),
    "phone_label": MessageLookupByLibrary.simpleMessage("Номер телефона"),
    "photos_uploaded": MessageLookupByLibrary.simpleMessage(
      "Фотографии загружены",
    ),
    "pick_up_item": MessageLookupByLibrary.simpleMessage("Забрать товар"),
    "please_wait_manager": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, ожидайте ответа\nот менеджера.",
    ),
    "price": MessageLookupByLibrary.simpleMessage("Цена"),
    "price_absent": MessageLookupByLibrary.simpleMessage("Цена отсутствует"),
    "price_not_specified": MessageLookupByLibrary.simpleMessage(
      "Цена не указана",
    ),
    "price_prefix": MessageLookupByLibrary.simpleMessage("Цена:"),
    "price_update_success": MessageLookupByLibrary.simpleMessage(
      "Цена успешно обновлена",
    ),
    "price_updated": MessageLookupByLibrary.simpleMessage(
      "Цена успешно обновлена",
    ),
    "primaryOEMNumber": MessageLookupByLibrary.simpleMessage(
      "Основной OEM номер",
    ),
    "primary_oem_number": MessageLookupByLibrary.simpleMessage(
      "Основной OEM номер",
    ),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage(
      "политику конфиденциальности",
    ),
    "processing_orders": MessageLookupByLibrary.simpleMessage("В обработке"),
    "productCreated": MessageLookupByLibrary.simpleMessage(
      "Товар успешно создан",
    ),
    "productEditing": MessageLookupByLibrary.simpleMessage(
      "Редактирование товара",
    ),
    "productName": MessageLookupByLibrary.simpleMessage("Наименование товара"),
    "productOutOfStock": MessageLookupByLibrary.simpleMessage(
      "Товар не в наличии",
    ),
    "productPhotos": MessageLookupByLibrary.simpleMessage("Фото товара"),
    "productProperty": MessageLookupByLibrary.simpleMessage("Свойство товара:"),
    "productStatus": MessageLookupByLibrary.simpleMessage("Статус товара"),
    "productTags": MessageLookupByLibrary.simpleMessage("Теги товара:"),
    "productUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Товар успешно обновлен",
    ),
    "product_amount": MessageLookupByLibrary.simpleMessage("Сумма товара"),
    "product_code": MessageLookupByLibrary.simpleMessage("Код товара"),
    "product_created": MessageLookupByLibrary.simpleMessage("Товар создан"),
    "product_created_successfully": MessageLookupByLibrary.simpleMessage(
      "Товар успешно создан!",
    ),
    "product_description_absent": MessageLookupByLibrary.simpleMessage(
      "Описание отсутствует",
    ),
    "product_id_cannot_be_null": MessageLookupByLibrary.simpleMessage(
      "ID товара не может быть null",
    ),
    "product_id_not_found": MessageLookupByLibrary.simpleMessage(
      "ID продукта не найден в ответе",
    ),
    "product_name": MessageLookupByLibrary.simpleMessage("Наименование товара"),
    "product_name_absent": MessageLookupByLibrary.simpleMessage(
      "Название отсутствует",
    ),
    "product_published": MessageLookupByLibrary.simpleMessage(
      "Товар отправлен на публикацию",
    ),
    "product_removed": MessageLookupByLibrary.simpleMessage(
      "Товар снят с продажи",
    ),
    "properties_not_found": MessageLookupByLibrary.simpleMessage(
      "Свойства не найдены",
    ),
    "properties_saved": MessageLookupByLibrary.simpleMessage(
      "Характеристики сохранены",
    ),
    "publish": MessageLookupByLibrary.simpleMessage("Опубликовать"),
    "publish_confirmation": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите опубликовать товар?",
    ),
    "reason": MessageLookupByLibrary.simpleMessage("Причина"),
    "reason_bad_quality": MessageLookupByLibrary.simpleMessage(
      "Товар плохого качества",
    ),
    "reason_damaged": MessageLookupByLibrary.simpleMessage(
      "Товар или упаковка повреждена",
    ),
    "reason_incomplete_set": MessageLookupByLibrary.simpleMessage(
      "Неполная комплектация",
    ),
    "reason_unknown": MessageLookupByLibrary.simpleMessage(
      "Неизвестная причина",
    ),
    "refund": MessageLookupByLibrary.simpleMessage("Возврат средств"),
    "register": MessageLookupByLibrary.simpleMessage("Зарегистрироваться"),
    "registerError": m2,
    "registration": MessageLookupByLibrary.simpleMessage("Регистрация"),
    "registrationPrompt": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, переходите на \nстраницу регистрации.",
    ),
    "registration_sent": MessageLookupByLibrary.simpleMessage(
      "Ваш запрос на\nрегистрацию отправлен!",
    ),
    "remove_sale_confirmation": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите снять товар с продажи?",
    ),
    "repeat": MessageLookupByLibrary.simpleMessage("Повторить"),
    "request_permission": MessageLookupByLibrary.simpleMessage(
      "Запросить разрешение",
    ),
    "resendText": MessageLookupByLibrary.simpleMessage("Отправить код снова"),
    "resendTimerText": m3,
    "resend_code": MessageLookupByLibrary.simpleMessage("Отправить код снова"),
    "resend_timer": m4,
    "return_canceled_successfully": MessageLookupByLibrary.simpleMessage(
      "Возврат успешно отменён",
    ),
    "return_composition": MessageLookupByLibrary.simpleMessage(
      "Состав возврата",
    ),
    "return_details": MessageLookupByLibrary.simpleMessage("Детали возврата"),
    "returns_header": MessageLookupByLibrary.simpleMessage("Возвраты"),
    "save": MessageLookupByLibrary.simpleMessage("Сохранить"),
    "saving_properties": MessageLookupByLibrary.simpleMessage(
      "Сохранение характеристик",
    ),
    "searchBrand": MessageLookupByLibrary.simpleMessage("Поиск бренда"),
    "searchByBrand": MessageLookupByLibrary.simpleMessage("Поиск по марке"),
    "searchByModel": MessageLookupByLibrary.simpleMessage("Поиск по модели"),
    "searchCategory": MessageLookupByLibrary.simpleMessage("Поиск категории"),
    "selectAddress": MessageLookupByLibrary.simpleMessage("Выбрать адрес"),
    "select_new_status": MessageLookupByLibrary.simpleMessage(
      "Выберите новый статус",
    ),
    "selectedBrands": MessageLookupByLibrary.simpleMessage("Выбрано"),
    "selectedCategories": MessageLookupByLibrary.simpleMessage("Выбрано"),
    "selected_address": MessageLookupByLibrary.simpleMessage("Адрес не выбран"),
    "selected_city": MessageLookupByLibrary.simpleMessage("Город неизвестен"),
    "selected_country": MessageLookupByLibrary.simpleMessage(
      "Страна неизвестна",
    ),
    "sendSMS": MessageLookupByLibrary.simpleMessage("Отправить SMS"),
    "sent_code_message": m5,
    "settings": MessageLookupByLibrary.simpleMessage("Настройки"),
    "shopName": MessageLookupByLibrary.simpleMessage("Название магазина"),
    "showProduct": MessageLookupByLibrary.simpleMessage("Показать товар"),
    "sku": MessageLookupByLibrary.simpleMessage("SKU"),
    "smsCodeInputTitle": MessageLookupByLibrary.simpleMessage(
      "Введите SMS-код",
    ),
    "smsSentMessageError": m6,
    "smsSentMessageSuccess": MessageLookupByLibrary.simpleMessage(
      "SMS-код успешно отправлен",
    ),
    "smsSentText": MessageLookupByLibrary.simpleMessage(
      "Мы отправили код на ваш номер телефона.",
    ),
    "standard": MessageLookupByLibrary.simpleMessage("Стандартная"),
    "status_label": MessageLookupByLibrary.simpleMessage("Статус:"),
    "status_prefix": MessageLookupByLibrary.simpleMessage("Статус:"),
    "status_update_error": MessageLookupByLibrary.simpleMessage(
      "Ошибка обновления статуса:",
    ),
    "sub_original": MessageLookupByLibrary.simpleMessage("Под оригинал"),
    "success": MessageLookupByLibrary.simpleMessage("Успешно!"),
    "support": MessageLookupByLibrary.simpleMessage("Поддержка"),
    "tag_default": MessageLookupByLibrary.simpleMessage("Тег"),
    "tags": MessageLookupByLibrary.simpleMessage("Теги"),
    "tags_empty": MessageLookupByLibrary.simpleMessage("Список тегов пуст"),
    "tags_saved": MessageLookupByLibrary.simpleMessage("Теги сохранены"),
    "total_amount": MessageLookupByLibrary.simpleMessage("Общая сумма"),
    "transactions": MessageLookupByLibrary.simpleMessage("Транзакции"),
    "type": MessageLookupByLibrary.simpleMessage("Тип"),
    "unknown": MessageLookupByLibrary.simpleMessage("неизвестен"),
    "unknown_order": MessageLookupByLibrary.simpleMessage("Неизвестно"),
    "unknown_variant": MessageLookupByLibrary.simpleMessage("Неизвестный"),
    "updateProduct": MessageLookupByLibrary.simpleMessage("Обновить товар"),
    "updateProductLoading": MessageLookupByLibrary.simpleMessage(
      "Обновление товара...",
    ),
    "upload_photos": MessageLookupByLibrary.simpleMessage(
      "Загрузите от 1 до 5 фото",
    ),
    "uploading_photos": MessageLookupByLibrary.simpleMessage(
      "Загрузка фотографий",
    ),
    "variant": MessageLookupByLibrary.simpleMessage("Вариант"),
    "variant_created": MessageLookupByLibrary.simpleMessage(
      "Вариант товара создан",
    ),
    "vehicleMapping": MessageLookupByLibrary.simpleMessage(
      "Соответствие с автомобилем",
    ),
    "vehicle_compatibility": MessageLookupByLibrary.simpleMessage(
      "Соответствие с автомобилем",
    ),
    "vendor_code": MessageLookupByLibrary.simpleMessage("Код запчасти"),
    "verifyButtonText": MessageLookupByLibrary.simpleMessage("Подтвердить"),
    "viewProduct": MessageLookupByLibrary.simpleMessage(
      "Посмотреть товар на bolshek.kz",
    ),
    "view_product": MessageLookupByLibrary.simpleMessage("Показать товар"),
    "waiting_goods": MessageLookupByLibrary.simpleMessage("Ожидает"),
    "welcomeMessage": MessageLookupByLibrary.simpleMessage("Добро пожаловать!"),
    "whatsapp_launch_error": MessageLookupByLibrary.simpleMessage(
      "Не удалось открыть WhatsApp",
    ),
    "your_warehouse": MessageLookupByLibrary.simpleMessage("Ваши склады"),
  };
}
