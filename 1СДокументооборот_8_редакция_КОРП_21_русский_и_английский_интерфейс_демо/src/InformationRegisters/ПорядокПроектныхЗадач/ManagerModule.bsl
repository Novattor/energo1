// Устанавливает признак Прочтен для объекта у Пользователя (ТекущегоПользователя).
Процедура УстановитьПорядокПроектнойЗадачи(ПроектнаяЗадача, НомерПорядка) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
		
	Запись = РегистрыСведений.ПорядокПроектныхЗадач.СоздатьМенеджерЗаписи();
	Запись.ПроектнаяЗадача = ПроектнаяЗадача;
	Запись.Прочитать();
	
	Запись.ПроектнаяЗадача = ПроектнаяЗадача;
	Запись.Порядок = НомерПорядка;
	Запись.Записать(Истина);
	
КонецПроцедуры


