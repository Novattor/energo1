
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Добавляет запись в протокол
// Параметры
//	МобильныйКлиент - ссылка на узел плана обмена Мобильный
//	МоментВремени - момент наступлени события в миллисекундах
//	Период - дата наступления события
//	ИдентификаторОбъекта - уникальный идентификатор объекта, с которым связано произошедшее событие
//	ОписаниеСобытия - текстовое описание события
//	ТипОбъекта - имя типа объекта, с которым связано событие
//	ТиСобытия - значение перечисления ТипыСобытийПротоколаРаботыСМобильнымКлиентом
Процедура ДобавитьЗаписьВПротоколСКлиента(
	МобильныйКлиент,
	МоментВремени,
	Период,
	ИдентификаторОбъекта,
	ОписаниеСобытия,
	ТипОбъекта,
	ТипСобытия) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписиРегистра = РегистрыСведений.ПротоколРаботыСМобильнымиКлиентами.СоздатьМенеджерЗаписи();
	МенеджерЗаписиРегистра.МобильныйКлиент = МобильныйКлиент;
	МенеджерЗаписиРегистра.МоментВремени = МоментВремени;
	МенеджерЗаписиРегистра.Период = Период;
		
	МенеджерЗаписиРегистра.ИдентификаторОбъекта = ИдентификаторОбъекта;
	МенеджерЗаписиРегистра.ОписаниеСобытия = ОписаниеСобытия;
	МенеджерЗаписиРегистра.СКлиента = Истина;
	МенеджерЗаписиРегистра.ТипОбъекта = ТипОбъекта;
	МенеджерЗаписиРегистра.ТипСобытия = ТипСобытия;
	
	МенеджерЗаписиРегистра.Записать();
	
КонецПроцедуры

// Добавляет запись об ошибке, связанную с объектом данных
// Параметры:
//	Сообщение - описание ошибки
//	ТипОбъекта - имя типа объекта
//	ИдентификаторОбъекта - уникальный идентификатор объекта
//	СКлиента - флаг, показывающий, где произошло событие: на мобильном клиенте или не сервере
//	МобильныйКлиент - ссылка на узел плана обмена Мобильный
Процедура ДобавитьОшибкуПоОбъекту(Сообщение, ТипОбъекта, ИдентификаторОбъекта, СКлиента, МобильныйКлиент) Экспорт
	
	ДобавитьЗаписьВПротокол(
		Перечисления.ТипыСобытийПротоколаРаботыСМобильнымКлиентом.Ошибка,
		Сообщение,
		ТипОбъекта,
		ИдентификаторОбъекта,
		СКлиента,
		МобильныйКлиент);
	
КонецПроцедуры

// Добавляет информационную запись о событии, связанным с объектом данных
// Параметры:
//	Сообщение - описание события
//	ТипОбъекта - имя типа объекта
//	ИдентификаторОбъекта - уникальный идентификатор объекта
//	СКлиента - флаг, показывающий, где произошло событие: на мобильном клиенте или не сервере
//	МобильныйКлиент - ссылка на узел плана обмена Мобильный 
Процедура ДобавитьИнформациюПоОбъекту(Сообщение, ТипОбъекта, ИдентификаторОбъекта, СКлиента, МобильныйКлиент) Экспорт
	
	ДобавитьЗаписьВПротокол(
		Перечисления.ТипыСобытийПротоколаРаботыСМобильнымКлиентом.Информация,
		Сообщение,
		ТипОбъекта,
		ИдентификаторОбъекта,
		СКлиента,
		МобильныйКлиент);
	
КонецПроцедуры

// Добавляет информационную запись о событии
// Параметры:
//	Сообщение - описание события
//	СКлиента - флаг, показывающий, где произошло событие: на мобильном клиенте или не сервере
//	МобильныйКлиент - ссылка на узел плана обмена Мобильный 
Процедура ДобавитьИнформацию(Сообщение, СКлиента, МобильныйКлиент) Экспорт
	
	ДобавитьЗаписьВПротокол(
		Перечисления.ТипыСобытийПротоколаРаботыСМобильнымКлиентом.Информация,
		Сообщение,
		,
		,
		СКлиента,
		МобильныйКлиент);
	
КонецПроцедуры

// Добавляет запись об ошибке
// Параметры:
//	Сообщение - описание ошибки
//	СКлиента - флаг, показывающий, где произошло событие: на мобильном клиенте или не сервере
//	МобильныйКлиент - ссылка на узел плана обмена Мобильный 
Процедура ДобавитьОшибку(Сообщение, СКлиента, МобильныйКлиент) Экспорт
	
	ДобавитьЗаписьВПротокол(
		Перечисления.ТипыСобытийПротоколаРаботыСМобильнымКлиентом.Ошибка,
		Сообщение,
		,
		,
		СКлиента,
		МобильныйКлиент);
	
КонецПроцедуры

// Добавляет предупреждение
// Параметры:
//	Сообщение - описание предупреждения
//	СКлиента - флаг, показывающий, где произошло событие: на мобильном клиенте или не сервере
//	МобильныйКлиент - ссылка на узел плана обмена Мобильный 
Процедура ДобавитьПредупреждение(Сообщение, СКлиента, МобильныйКлиент) Экспорт
	
	 ДобавитьЗаписьВПротокол(
		Перечисления.ТипыСобытийПротоколаРаботыСМобильнымКлиентом.Предупреждение,
		Сообщение,
		,
		,
		СКлиента,
		МобильныйКлиент);
	
КонецПроцедуры

// Добавляет запись с сообщением о проблеме, поступившим от пользователя
// Параметры:
//	Сообщение - описание предупреждения
//	СКлиента - флаг, показывающий, где произошло событие: на мобильном клиенте или не сервере
//	МобильныйКлиент - ссылка на узел плана обмена Мобильный 
Процедура ДобавитьСообщениеОПроблемеОтПользователя(Сообщение, СКлиента, МобильныйКлиент) Экспорт
	
	 ДобавитьЗаписьВПротокол(
		Перечисления.ТипыСобытийПротоколаРаботыСМобильнымКлиентом.СообщениеОПроблемеОтПользователя,
		Сообщение,
		,
		,
		СКлиента,
		МобильныйКлиент);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ДобавитьЗаписьВПротокол(
	ТипСобытия = Неопределено,
	Описание,
	ТипОбъекта = "",
	ИдентификаторОбъекта = Неопределено,
	СКлиента,
	МобильныйКлиент)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипСобытия = Неопределено Тогда
		ТипСобытия = Перечисления.ТипыСобытийПротоколаРаботыСМобильнымКлиентом.Информация;
	КонецЕсли;
	
	Если ИдентификаторОбъекта = Неопределено Тогда
		ИдентификаторОбъекта = УникальныйИдентификаторПустой();
	КонецЕсли;
	
	МенеджерЗаписиРегистра = РегистрыСведений.ПротоколРаботыСМобильнымиКлиентами.СоздатьМенеджерЗаписи();
	МенеджерЗаписиРегистра.МобильныйКлиент = МобильныйКлиент;
	МенеджерЗаписиРегистра.МоментВремени = ТекущаяУниверсальнаяДатаВМиллисекундах();
	МенеджерЗаписиРегистра.Период = ТекущаяДатаСеанса();
		
	МенеджерЗаписиРегистра.ИдентификаторОбъекта = ИдентификаторОбъекта;
	МенеджерЗаписиРегистра.ОписаниеСобытия = Описание;
	МенеджерЗаписиРегистра.СКлиента = СКлиента;
	МенеджерЗаписиРегистра.ТипОбъекта = ТипОбъекта;
	МенеджерЗаписиРегистра.ТипСобытия = ТипСобытия;
	
	МенеджерЗаписиРегистра.Записать();
	
КонецПроцедуры


