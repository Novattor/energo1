#Область СлужебныеПроцедурыИФункции

// Возвращает массив поддерживаемых подсистемой InterfaceName названий номеров версий.
//
// Параметры:
// InterfaceName - Строка - Имя подсистемы.
//
// Возвращаемое значение:
// Массив строк.
//
// Пример использования:
//
// 	// Возвращает объект WSПрокси передачи файлов заданной версии.
// 	// Если ВерсияПередачи = Неопределено, возвращает Прокси базовой версии "1.0.1.1".
//  //
//	Функция ПолучитьПроксиПередачиФайлов(Знач ПараметрыПодключения, Знач ВерсияПередачи = Неопределено)
//		// …………………………………………………
//	КонецФункции
//
//	Функция ПолучитьИзХранилища(Знач ИдентификаторФайла, Знач ПараметрыПодключения) Экспорт
//
//		// Общая для всех версий функциональность.
//		// …………………………………………………
//
//		// Учесть версионирование.
//		МассивПоддерживаемыхВерсий = СтандартныеПодсистемыСервер.ПолучитьМассивВерсийПодсистемы(
//			ПараметрыПодключения, "СервисПередачиФайлов");
//		Если МассивПоддерживаемыхВерсий.Найти("1.0.2.1") = Неопределено Тогда
//			ЕстьПоддержка2йВерсии = Ложь;
//			Прокси = ПолучитьПроксиПередачиФайлов(ПараметрыПодключения);
//		Иначе
//			ЕстьПоддержка2йВерсии = Истина;
//			Прокси = ПолучитьПроксиПередачиФайлов(ПараметрыПодключения, "1.0.2.1");
//		КонецЕсли;
//
//		КоличествоЧастей = Неопределено;
//		РазмерЧасти = 20 * 1024; // Кб
//		Если ЕстьПоддержка2йВерсии Тогда
//	   		ИдентификаторПередачи = Прокси.PrepareGetFile(ИдентификаторФайла, РазмерЧасти, КоличествоЧастей);
//		Иначе
//			ИдентификаторПередачи = Неопределено;
//			Прокси.PrepareGetFile(ИдентификаторФайла, РазмерЧасти, ИдентификаторПередачи, КоличествоЧастей);
//		КонецЕсли;
//
//		// Общая для всех версий функциональность.
//		// …………………………………………………	
//
//	КонецФункции
//
Функция GetVersions(InterfaceName)
	
	МассивВерсий = Неопределено;
	
	СтруктураПоддерживаемыхВерсий = Новый Структура;
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(СтруктураПоддерживаемыхВерсий);
	КонецЦикла;
	
	ОбщегоНазначенияПереопределяемый.ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(СтруктураПоддерживаемыхВерсий);
	
	СтруктураПоддерживаемыхВерсий.Свойство(InterfaceName, МассивВерсий);
	
	Если МассивВерсий = Неопределено Тогда
		Возврат СериализаторXDTO.ЗаписатьXDTO(Новый Массив);
	Иначе
		Возврат СериализаторXDTO.ЗаписатьXDTO(МассивВерсий);
	КонецЕсли;
	
КонецФункции

#КонецОбласти
