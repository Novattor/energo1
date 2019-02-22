
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ОбновитьВсе() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Удаление всех записей регистра
	НаборЗаписей = РегистрыСведений.ДокументооборотПользователиГруппДоступа.СоздатьНаборЗаписей();
	НаборЗаписей.Записать();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ГруппыДоступа.Ссылка
		|ИЗ
		|	Справочник.ГруппыДоступа КАК ГруппыДоступа";

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ОбновитьПоГруппеДоступа(ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;

КонецПроцедуры

Процедура ОбновитьПоГруппеДоступа(ГруппаДоступа) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.ДокументооборотПользователиГруппДоступа.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ГруппаДоступа.Установить(ГруппаДоступа);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	&ГруппаДоступа,
		|	СоставыГруппПользователей.Пользователь
		|ИЗ
		|	Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
		|		ПО ГруппыДоступаПользователи.Пользователь = СоставыГруппПользователей.ГруппаПользователей
		|ГДЕ
		|	ГруппыДоступаПользователи.Ссылка = &ГруппаДоступа");
	
	Запрос.УстановитьПараметр("ГруппаДоступа", ГруппаДоступа);
	НаборЗаписей.Загрузить(Запрос.Выполнить().Выгрузить());
	НаборЗаписей.Записать();
	
КонецПроцедуры

Процедура ДобавитьНовогоПользователя(Пользователь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ГруппыДоступаПользователи.Ссылка
		|ИЗ
		|	Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|ГДЕ
		|	ГруппыДоступаПользователи.Пользователь = ЗНАЧЕНИЕ(Справочник.РабочиеГруппы.ВсеПользователи)");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Запись = РегистрыСведений.ДокументооборотПользователиГруппДоступа.СоздатьМенеджерЗаписи();
		Запись.ГруппаДоступа = Выборка.Ссылка;
		Запись.Пользователь = Пользователь;
		Запись.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьПоРабочейГруппе(РабочаяГруппа) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ГруппаИРодители = Новый Массив;
	ГруппаИРодители.Добавить(РабочаяГруппа);
	
	Родитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РабочаяГруппа, "Родитель");
	Пока ЗначениеЗаполнено(Родитель) Цикл
		ГруппаИРодители.Добавить(Родитель);
		Родитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Родитель, "Родитель");
	КонецЦикла;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ГруппыДоступаПользователи.Ссылка
		|ИЗ
		|	Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|ГДЕ
		|	ГруппыДоступаПользователи.Пользователь В (&РабочиеГруппы)");
	
	Запрос.УстановитьПараметр("РабочиеГруппы", ГруппаИРодители);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбновитьПоГруппеДоступа(Выборка.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
