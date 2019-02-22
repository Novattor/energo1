#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Формирует событие из переданного текста.
//
// Параметры:
//  Текст - Строка - Обрабатываемый текст.
//  ДатаТекста - Дата - Дата, к которой относится текст.
// 
// Возвращаемое значение:
//  Структура - Событие в тексте.
//   * Тип - Строка - Тип найденного в тексте события.
//   * Дата - Строка - Дата события.
//   * Время - Строка - Время события.
//   * Начало - Дата - Дата начала события.
//   * Конец - Дата - Дата окончания события.
//   * Место - Строка - Место проведения события.
//   * Email - Строка - Email для связи.
//   * Текст - Строка - Часть текста, соответсвующая событию.
//
Функция Событие(Текст, ДатаТекста = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Обработка = Обработки.АнализТекста.Создать();
	Обработка.ИсходныйТекст = Текст;
	Обработка.ДатаИсходногоТекста = ДатаТекста;
	Событие = Обработка.Событие();
	
	Возврат Событие;
	
КонецФункции

#КонецОбласти

#КонецЕсли



