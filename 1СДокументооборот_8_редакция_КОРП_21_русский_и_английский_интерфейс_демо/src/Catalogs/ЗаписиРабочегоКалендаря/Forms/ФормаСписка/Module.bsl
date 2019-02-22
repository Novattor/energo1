#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ДатаНачала") И Параметры.ДатаНачала <> Неопределено Тогда
		
		ДатаНачала = Параметры.ДатаНачала;
		Список.Параметры.УстановитьЗначениеПараметра("ДатаНачала", Параметры.ДатаНачала);
		
	Иначе
		
		ДатаНачала = Неопределено;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ДатаОкончания") И Параметры.ДатаОкончания <> Неопределено Тогда
		
		ДатаОкончания = Параметры.ДатаОкончания;
		Список.Параметры.УстановитьЗначениеПараметра("ДатаОкончания", Параметры.ДатаОкончания);
		
	Иначе
		
		ДатаОкончания = Неопределено;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ВесьДень") И Параметры.ВесьДень <> Неопределено Тогда
		
		ВесьДень = Параметры.ВесьДень;
		Список.Параметры.УстановитьЗначениеПараметра("ВесьДень", Параметры.ВесьДень);
		
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок") И Параметры.Заголовок <> Неопределено Тогда
		
		Заголовок = Параметры.Заголовок;
		АвтоЗаголовок = Ложь;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ВозможноеОтсутствие") И Параметры.ВозможноеОтсутствие <> Неопределено Тогда
		
		СобытияПользователя = РаботаСРабочимКалендаремСервер.ПолучитьСобытияПользователя(
			Параметры.ВозможноеОтсутствие.ДатаНачала,
			Параметры.ВозможноеОтсутствие.ДатаОкончания,
			Параметры.ВозможноеОтсутствие.Сотрудник);
		
		МассивСсылокОтбора = Новый Массив;
		Для Каждого Событие Из СобытияПользователя Цикл
			
			Если МассивСсылокОтбора.Найти(Событие.Ссылка) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			МассивСсылокОтбора.Добавить(Событие.Ссылка);
			
		КонецЦикла;
		
		Список.Параметры.УстановитьЗначениеПараметра("МассивСсылок", МассивСсылокОтбора);
		
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("Пользователь", ПользователиКлиентСервер.ТекущийПользователь());
	
	// Отображение удаленных
	ПереключитьОтображатьУдаленные();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ЗаписьКалендаря"
		ИЛИ ИмяСобытия = "Запись_Отсутствие" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	// Отображение удаленных
	ПереключитьОтображатьУдаленные();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтображатьУдаленные(Команда)
	
	ОтображатьУдаленные = Не ОтображатьУдаленные;
	ПереключитьОтображатьУдаленные();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаписьКалендаря(Команда)
	
	РаботаСРабочимКалендаремКлиент.СоздатьЗаписьКалендаря(
		, ДатаНачала, ДатаОкончания, ВесьДень);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЦветСпискаЖелтый(Команда)
	
	УстановитьЦветСписка(ПредопределенноеЗначение("Перечисление.ЦветаРабочегоКалендаря.Желтый"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЦветСпискаЗеленый(Команда)
	
	УстановитьЦветСписка(ПредопределенноеЗначение("Перечисление.ЦветаРабочегоКалендаря.Зеленый"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЦветСпискаКрасный(Команда)
	
	УстановитьЦветСписка(ПредопределенноеЗначение("Перечисление.ЦветаРабочегоКалендаря.Красный"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЦветСпискаНет(Команда)
	
	УстановитьЦветСписка(ПредопределенноеЗначение("Перечисление.ЦветаРабочегоКалендаря.Нет"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЦветСпискаОранжевый(Команда)
	
	УстановитьЦветСписка(ПредопределенноеЗначение("Перечисление.ЦветаРабочегоКалендаря.Оранжевый"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЦветСпискаСиний(Команда)
	
	УстановитьЦветСписка(ПредопределенноеЗначение("Перечисление.ЦветаРабочегоКалендаря.Синий"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьЦветСписка(Цвет)
	
	РаботаСРабочимКалендаремКлиент.УстановитьЦветЗаписейКалендаря(Элементы.Список.ТекущаяСтрока, Цвет);
	
КонецПроцедуры

&НаСервере
Процедура ПереключитьОтображатьУдаленные()
	
	Элементы.ФормаОтображатьУдаленные.Пометка = ОтображатьУдаленные;
	Список.Параметры.УстановитьЗначениеПараметра("ОтображатьУдаленные", ОтображатьУдаленные);
	
КонецПроцедуры

#КонецОбласти
