#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Записывает настройку календаря в регистр сведений
Функция УстановитьНастройку(Пользователь, Событие, Настройка, ЗначениеНастройки) Экспорт
	
	ИзмененоЗначениеНастройки = Ложь;
	
	МенеджерЗаписи = РегистрыСведений.НастройкиОтображенияЗаписейРабочегоКалендаря.СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.Пользователь = Пользователь;
	МенеджерЗаписи.Событие = Событие;
	МенеджерЗаписи.Настройка = Настройка;
	
	МенеджерЗаписи.Прочитать();
	
	Если МенеджерЗаписи.ЗначениеНастройки <> ЗначениеНастройки Тогда
		
		ИзмененоЗначениеНастройки = Истина;
		
		МенеджерЗаписи.Пользователь = Пользователь;
		МенеджерЗаписи.Событие = Событие;
		МенеджерЗаписи.Настройка = Настройка;
		МенеджерЗаписи.ЗначениеНастройки = ЗначениеНастройки;
		МенеджерЗаписи.Записать();
		
	КонецЕсли;
	
	Возврат ИзмененоЗначениеНастройки;
	
КонецФункции

// Читает настройку календаря из регистра сведений
Функция ПолучитьНастройку(Пользователь, Событие, Настройка) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Событие) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	НастройкиОтображенияЗаписейРабочегоКалендаря.ЗначениеНастройки
		|ИЗ
		|	РегистрСведений.НастройкиОтображенияЗаписейРабочегоКалендаря КАК НастройкиОтображенияЗаписейРабочегоКалендаря
		|ГДЕ
		|	НастройкиОтображенияЗаписейРабочегоКалендаря.Пользователь = &Пользователь
		|	И НастройкиОтображенияЗаписейРабочегоКалендаря.Событие = &Событие
		|	И НастройкиОтображенияЗаписейРабочегоКалендаря.Настройка = &Настройка");
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("Событие", Событие);
	Запрос.УстановитьПараметр("Настройка", Настройка);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.ЗначениеНастройки;
	
КонецФункции

#КонецОбласти

#КонецЕсли



