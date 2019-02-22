#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

//Выполняет заполнение категорий и разделов в зависимости от варианта отчета
//Параметры:КлючВариантаОтчета - Строковое название варианта отчета
//			СписокКатегорий - в список добавляются необходимые категории
//			СписокРазделов - в список добавляются необходимые категории
Процедура ЗаполнитьСписокКатегорийИРазделовОтчета(КлючВариантаОтчета, СписокКатегорий, СписокРазделов) Экспорт
	
	СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			Метаданные.Подсистемы.СовместнаяРабота));
	
	Если КлючВариантаОтчета = "СписокМероприятий" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.МероприятияСписок);
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоМероприятиям);
		
	ИначеЕсли КлючВариантаОтчета = "ДинамикаМероприятий" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.МероприятияСписок);
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоМероприятиям);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
	ИначеЕсли КлючВариантаОтчета = "СтатистикаПоВидамМероприятий" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.МероприятияСписок);
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоМероприятиям);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
	ИначеЕсли КлючВариантаОтчета = "ЗатраченноеВремяНаМероприятия" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.МероприятияСписок);
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоМероприятиям);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоИсполнителям);
		
	ИначеЕсли КлючВариантаОтчета = "АнализДлительностиМероприятий" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.МероприятияСписок);

		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоМероприятиям);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПланФакт);
		
	ИначеЕсли КлючВариантаОтчета = "ЯвкаНаМероприятия" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.МероприятияСписок);
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоМероприятиям);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоИсполнителям);
		
	ИначеЕсли КлючВариантаОтчета = "АнализВремениВыступлений" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.МероприятияСписок);
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоМероприятиям);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоИсполнителям);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПланФакт);
	
	ИначеЕсли КлючВариантаОтчета = "ПринятиеРешенийПоМероприятиям" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.МероприятияСписок);
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоМероприятиям);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
