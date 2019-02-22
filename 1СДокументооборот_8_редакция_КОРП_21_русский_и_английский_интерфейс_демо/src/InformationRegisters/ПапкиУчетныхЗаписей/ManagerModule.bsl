// Добавляет запись.
//
Процедура УстановитьПапку(УчетнаяЗапись, ВидПапки, Папка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		ВызватьИсключение НСтр("ru = 'Не выбрана учетная запись'; en = 'The account is not selected'");
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ВидПапки) Тогда
		ВызватьИсключение НСтр("ru = 'Не выбран вид папки'; en = 'You have not selected folder type'");
	КонецЕсли;
	
	Запись = РегистрыСведений.ПапкиУчетныхЗаписей.СоздатьМенеджерЗаписи();
	Запись.УчетнаяЗапись = УчетнаяЗапись;
	Запись.ВидПапки = ВидПапки;
	Запись.Прочитать();
	
	Если Запись.Выбран() И Не ЗначениеЗаполнено(Папка) Тогда
		Запись.Удалить();
		Возврат;
	КонецЕсли;
	
	Запись.УчетнаяЗапись = УчетнаяЗапись;
	Запись.ВидПапки = ВидПапки;
	Запись.Папка = Папка;
	Запись.Записать(Истина);
	
КонецПроцедуры

// Возвращает папку необходимого вида для учетной записи.
//
Функция ПолучитьПапку(УчетнаяЗапись, ВидПапки) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		ВызватьИсключение НСтр("ru = 'Не выбрана учетная запись'; en = 'The account is not selected'");
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ВидПапки) Тогда
		ВызватьИсключение НСтр("ru = 'Не выбран вид папки'; en = 'You have not selected folder type'");
	КонецЕсли;
	
	Запись = РегистрыСведений.ПапкиУчетныхЗаписей.СоздатьМенеджерЗаписи();
	Запись.УчетнаяЗапись = УчетнаяЗапись;
	Запись.ВидПапки = ВидПапки;
	Запись.Прочитать();
	
	Если Не Запись.Выбран() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Запись.Папка;
	
КонецФункции

