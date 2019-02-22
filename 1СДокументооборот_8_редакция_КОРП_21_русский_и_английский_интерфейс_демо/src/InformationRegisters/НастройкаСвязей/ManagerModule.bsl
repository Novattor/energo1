#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру настроек связей
//
// Возвращаемое значение:
//   Структура
//     Наименование
//
Функция ПолучитьСтруктуруНастроекСвязей() Экспорт
	
	ПараметрыНастроекСвязей = Новый Структура;
	ПараметрыНастроекСвязей.Вставить("ТипСвязи");
	ПараметрыНастроекСвязей.Вставить("СсылкаИз");
	ПараметрыНастроекСвязей.Вставить("СсылкаНа");
	ПараметрыНастроекСвязей.Вставить("ХарактерСвязи");
	ПараметрыНастроекСвязей.Вставить("ТипОбратнойСвязи");
	ПараметрыНастроекСвязей.Вставить("ХарактерОбратнойСвязи");
	
	Возврат ПараметрыНастроекСвязей;
	
КонецФункции

// Создает и записывает в БД настройку связей
//
// Параметры:
//   СтруктураНастроекСвязи - Структура - структура настроек связи.
//
Процедура СоздатьНастройкуСвязи(СтруктураНастроекСвязи) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.НастройкаСвязей.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ТипСвязи = СтруктураНастроекСвязи.ТипСвязи;
	МенеджерЗаписи.СсылкаИз = СтруктураНастроекСвязи.СсылкаИз;
	МенеджерЗаписи.СсылкаНа = СтруктураНастроекСвязи.СсылкаНа;
	МенеджерЗаписи.ХарактерСвязи = СтруктураНастроекСвязи.ХарактерСвязи;
	МенеджерЗаписи.ТипОбратнойСвязи = СтруктураНастроекСвязи.ТипОбратнойСвязи;
	МенеджерЗаписи.ХарактерОбратнойСвязи = СтруктураНастроекСвязи.ХарактерОбратнойСвязи;
	МенеджерЗаписи.Записать();
	
	Если ЗначениеЗаполнено(СтруктураНастроекСвязи.ТипОбратнойСвязи) Тогда 
		МенеджерЗаписи = РегистрыСведений.НастройкаСвязей.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ТипСвязи = СтруктураНастроекСвязи.ТипОбратнойСвязи;
		МенеджерЗаписи.СсылкаИз = СтруктураНастроекСвязи.СсылкаНа;
		МенеджерЗаписи.СсылкаНа = СтруктураНастроекСвязи.СсылкаИз;
		МенеджерЗаписи.ХарактерСвязи = СтруктураНастроекСвязи.ХарактерОбратнойСвязи;
		МенеджерЗаписи.ТипОбратнойСвязи = СтруктураНастроекСвязи.ТипСвязи;
		МенеджерЗаписи.ХарактерОбратнойСвязи = СтруктураНастроекСвязи.ХарактерСвязи;
		МенеджерЗаписи.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
