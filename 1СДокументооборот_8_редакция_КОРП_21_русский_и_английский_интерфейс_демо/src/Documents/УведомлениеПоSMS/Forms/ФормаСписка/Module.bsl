#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Ограничения количества SMS.
	ОграничениеКоличестваВДеньSMS = Константы.ОграничениеКоличестваВДеньSMS.Получить();
	ОграничениеКоличестваВМесяцSMS = Константы.ОграничениеКоличестваВМесяцSMS.Получить();
	ОграничениеКоличестваВсегоВДеньSMS = Константы.ОграничениеКоличестваВсегоВДеньSMS.Получить();
	ОграничениеКоличестваВсегоВМесяцSMS = Константы.ОграничениеКоличестваВсегоВМесяцSMS.Получить();
	ОбновитьОграничения();
	
	// Показывать удаленные.
	ОбщегоНазначенияДокументооборотКлиентСервер.УстановитьОтборПоказыватьУдаленные(
		Список,
		ПоказыватьУдаленные,
		Элементы.ПоказыватьУдаленные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтборПользовательПриИзменении(Элемент)
	
	ОтборПользовательПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПользовательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСПользователямиКлиент.ВыбратьПользователя(Элемент, ОтборПользователь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьСтатус(Команда)
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	ОбновитьСтатусНаСервере(ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	ОбщегоНазначенияДокументооборотКлиентСервер.УстановитьОтборПоказыватьУдаленные(
		Список,
		ПоказыватьУдаленные,
		Элементы.ПоказыватьУдаленные);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтборПользовательПриИзмененииНаСервере()
	
	ОбщегоНазначенияДокументооборотКлиентСервер.УстановитьОтборСписка(
		Список,
		"Пользователь",
		ОтборПользователь,
		Элементы.ОтборПользователь);
	ОбновитьОграничения();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОграничения()
	
	МассивСостояниеЗаДень = Новый Массив;
	МассивСостояниеЗаМесяц = Новый Массив;
	
	МассивСостояниеЗаДень.Добавить(Документы.УведомлениеПоSMS.КоличествоЗаДень(ОтборПользователь));
	МассивСостояниеЗаМесяц.Добавить(Документы.УведомлениеПоSMS.КоличествоЗаМесяц(ОтборПользователь));
	
	Если ЗначениеЗаполнено(ОтборПользователь) Тогда
		ОграничениеКоличестваВДень = ОграничениеКоличестваВДеньSMS;
		ОграничениеКоличестваВМесяц = ОграничениеКоличестваВМесяцSMS;
	Иначе
		ОграничениеКоличестваВДень = ОграничениеКоличестваВсегоВДеньSMS;
		ОграничениеКоличестваВМесяц = ОграничениеКоличестваВсегоВМесяцSMS;
	КонецЕсли;
	Если ОграничениеКоличестваВДень <> 0 Тогда
		МассивСостояниеЗаДень.Добавить(ОграничениеКоличестваВДень);
	КонецЕсли;
	Если ОграничениеКоличестваВМесяц <> 0 Тогда
		МассивСостояниеЗаМесяц.Добавить(ОграничениеКоличестваВМесяц);
	КонецЕсли;
	
	СостояниеЗаДень = СтрСоединить(МассивСостояниеЗаДень, " / ");
	СостояниеЗаМесяц = СтрСоединить(МассивСостояниеЗаМесяц, " / ");
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатусНаСервере(ВыделенныеСтроки)
	
	Для Каждого Строка Из ВыделенныеСтроки Цикл
		Документы.УведомлениеПоSMS.ОбновитьСтатусДоставки(Строка);
	КонецЦикла;
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти
