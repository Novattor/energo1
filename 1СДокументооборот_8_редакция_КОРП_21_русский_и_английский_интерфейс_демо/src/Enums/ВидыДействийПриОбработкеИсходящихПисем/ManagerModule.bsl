Функция ВычислитьТекстовоеОписаниеСпискаЗначений(ВидДействия, СписокЗначений) Экспорт
	
	Представление = "";
	
	Если СписокЗначений.Количество() = 0
		Или Не ЗначениеЗаполнено(СписокЗначений[0].Значение) Тогда
		Возврат Представление;
	КонецЕсли;
	
	Если ВидДействия = Перечисления.ВидыДействийПриОбработкеИсходящихПисем.ПереместитьВУказаннуюПапку
		ИЛИ ВидДействия = Перечисления.ВидыДействийПриОбработкеИсходящихПисем.ПоместитьИсходноеПисьмоВУказаннуюПапку Тогда
		
		Представление = Справочники.ПапкиПисем.ПолучитьПолныйПутьПапки(СписокЗначений[0].Значение);
				
	ИначеЕсли ВидДействия = Перечисления.ВидыДействийПриОбработкеИсходящихПисем.УстановитьУказанныйФлаг Тогда
		
		Представление = ОбщегоНазначения.ИмяЗначенияПеречисления(СписокЗначений[0].Значение);
		
	ИначеЕсли ВидДействия = Перечисления.ВидыДействийПриОбработкеИсходящихПисем.ПрименитьКИсходномуПисьмуПравила Тогда	
		
		Представление = "";
		Для Каждого Значение Из СписокЗначений Цикл
			Представление = Представление + Строка(Значение.Значение) + "; ";
		КонецЦикла;
		
	Иначе
		
		Представление = Строка(СписокЗначений[0].Значение);
		
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

Функция ОтрицаниеДействия(ВидДействия) Экспорт
	
	Если ВидДействия = Перечисления.ВидыДействийПриОбработкеИсходящихПисем.ОстановитьПроверкуДругихПравил Тогда
		Возврат НСтр("ru = 'НЕ останавливать проверку других правил'; en = 'DO NOT stop checking other rules'");
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Нстр("ru = 'НЕ %1'; en = 'DO NOT %1'"),
		Строка(ВидДействия));
	
КонецФункции


