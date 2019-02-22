Функция ВычислитьТекстовоеОписаниеСпискаЗначений(ВидДействия, СписокЗначений) Экспорт
	
	Представление = "";
	
	Если СписокЗначений.Количество() = 0
		Или Не ЗначениеЗаполнено(СписокЗначений[0].Значение) Тогда
		Возврат Представление;
	КонецЕсли;
	
	Если ВидДействия = Перечисления.ВидыДействийПриОбработкеВходящихПисем.ПереместитьВУказаннуюПапку Тогда
		Представление = Справочники.ПапкиПисем.ПолучитьПолныйПутьПапки(СписокЗначений[0].Значение);
	ИначеЕсли ВидДействия = Перечисления.ВидыДействийПриОбработкеВходящихПисем.УстановитьУказанныйФлаг Тогда
		Если ЗначениеЗаполнено(СписокЗначений[0].Значение) Тогда
			Представление = ОбщегоНазначения.ИмяЗначенияПеречисления(СписокЗначений[0].Значение);
		КонецЕсли;
	Иначе
		Представление = Строка(СписокЗначений[0].Значение);
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

Функция ОтрицаниеДействия(ВидДействия) Экспорт
	
	Если ВидДействия = Перечисления.ВидыДействийПриОбработкеВходящихПисем.УстановитьПометкуПрочтения Тогда
		Возврат НСтр("ru = 'НЕ устанавливать пометку прочтения'; en = 'DO NOT mark as read'");
	ИначеЕсли ВидДействия = Перечисления.ВидыДействийПриОбработкеВходящихПисем.ОстановитьПроверкуДругихПравил Тогда
		Возврат НСтр("ru = 'НЕ останавливать проверку других правил'; en = 'DO NOT stop checking other rules'");
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Нстр("ru = 'НЕ %1'; en = 'DO NOT %1'"),
		Строка(ВидДействия));
	
КонецФункции


