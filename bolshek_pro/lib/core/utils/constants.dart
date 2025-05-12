abstract class Constants {
  static const logoText = "saiman satu";
  // static const baseUrl = "https://api-stage.bolshek.com";
  static const baseUrl = "https://api.bolshek.kz";
  static const addCart = "Добавить в корзину";
  static const changeProduct = 'Редактировать';
  static const fromSale = 'Снять с продажи';
  static const newUser = 'Я новый пользователь';
  static const activeStatus = 'status=active';
  static const inactiveStatus = 'status=inactive';
  static const newOrders =
      'awaiting_confirmation&status=awaiting_payment&status=new';
  static const cancelledOrders = 'cancelled&status=partially_cancelled';
  static const createdReturn = 'created';
  static const awaitingConfirmation = 'awaiting_confirmation';
  static const awaitingPickReturn = 'awaiting_pick_up';
  static const rejectedReturn = 'rejected';

  static const completedReturn = 'completed';
  static const apiProduct = 'https://bolshek.kz/products/';
  static const awaitingRefund = 'awaiting_refund';
  static const deliveredOrders = 'delivered&status=partially_delivired';
  static const paidOrders = 'paid';
  static const newReturnTotalStatus =
      'created&status=awaiting_confirmation&status=awaiting_pick_up&status=awaiting_refund';
  static const completedReturnTotal = 'rejected&status=completed';
  static const processingOrders = 'processing';
  static const awaitingStatus = 'statuses=created&statuses=updated';  
  static const addNewGood = 'Добавить новый товар';
  static const pleaseInputPhone = "Пожалуйста, заполните телефон";
  static const orderEmpty = "У вас нет заказов";
  static const accept = "Подтвердить";
  static const status = "Статус";
  static const emptyBagLower = "Здесь будут лежать товары для покупки";
  static const emptyFavLower =
      "Добавляйте любимые товары в избранное, чтобы не искать их снова";
  static const welcome = "Добро пожаловать в Bolshek";
  static const welcome1 = "Введите номер телефона";
}
