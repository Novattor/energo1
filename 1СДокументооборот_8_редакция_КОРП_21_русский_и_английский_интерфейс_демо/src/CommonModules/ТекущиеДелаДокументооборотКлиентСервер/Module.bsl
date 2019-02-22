////////////////////////////////////////////////////////////////////////////////
// Клиентские и серверные процедуры и функции для обработки ТекущиеДела
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает структуру виджета в форме Текущие дела
//
// Возвращаемое значение:
//   Виджет
//   Показатели - Массив
//   ПапкиПисем - Массив
//
Функция СтруктураВиджетаФормы() Экспорт
	
	СтруктураВиджетаФормы = Новый Структура;
	СтруктураВиджетаФормы.Вставить("Виджет");
	СтруктураВиджетаФормы.Вставить("Показатели", Новый Массив);
	СтруктураВиджетаФормы.Вставить("ПапкиПисем", Новый Массив);
	
	Возврат СтруктураВиджетаФормы;
	
КонецФункции

// Возвращает структуру виджета в форме Текущие дела
//
// Возвращаемое значение:
//   Показатель
//   ИмяПоказателя
//   ПороговоеЗначение
//
Функция СтруктураПоказателяВиджета() Экспорт
	
	СтруктураПоказателя = Новый Структура;
	СтруктураПоказателя.Вставить("Показатель");
	СтруктураПоказателя.Вставить("ИмяПоказателя");
	СтруктураПоказателя.Вставить("ПороговоеЗначение");
	
	Возврат СтруктураПоказателя;
	
КонецФункции

#КонецОбласти
