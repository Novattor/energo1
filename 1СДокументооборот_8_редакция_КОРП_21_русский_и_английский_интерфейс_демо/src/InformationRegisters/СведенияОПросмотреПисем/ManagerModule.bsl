
Процедура УстановитьПризнакПросмотрено(Письмо) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.СведенияОПросмотреПисем.СоздатьМенеджерЗаписи();
	Запись.Письмо = Письмо;
	Запись.Прочитать();
	
	Если Запись.Просмотрено Тогда 
		Возврат;
	КонецЕсли;	
	
	Запись.Письмо = Письмо;
	Запись.Просмотрено = Истина;
	Запись.Записать();
	
КонецПроцедуры

Функция ПолучитьПризнакПросмотрено(Письмо) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.СведенияОПросмотреПисем.СоздатьМенеджерЗаписи();
	Запись.Письмо = Письмо;
	Запись.Прочитать();
	
	Возврат Запись.Просмотрено;
	
КонецФункции


