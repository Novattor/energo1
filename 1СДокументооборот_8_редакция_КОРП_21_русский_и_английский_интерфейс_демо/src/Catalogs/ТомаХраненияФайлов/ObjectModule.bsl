#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;	
	
	Если Не НомерПорядкаУникален(ПорядокЗаполнения, Ссылка, Родитель) Тогда
		Отказ = Истина;
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Порядок заполнения не уникален - в группе ""%1"" уже есть том с таким порядком'; en = 'Order of filling is not unique - group ""%1"" already has the same order'"),
			Строка(Родитель));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ПорядокЗаполнения", "Объект");
	КонецЕсли;
	
	Если ПустаяСтрока(ПолныйПутьWindows) И ПустаяСтрока(ПолныйПутьLinux) Тогда
		Отказ = Истина;
		ТекстОшибки = НСтр("ru = 'Не заполнен полный путь'; en = 'Full path is not filled'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ПолныйПутьWindows", "Объект");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ПолныйПутьLinux", "Объект");
		Возврат;
	КонецЕсли;
	
	Если Не ПустаяСтрока(ПолныйПутьWindows) И (Лев(ПолныйПутьWindows, 2) <> "\\" ИЛИ Найти(ПолныйПутьWindows, ":") <> 0) Тогда
		Отказ = Истина;
		
		ТекстОшибки = НСтр("ru = 'Путь к тому должен быть в формате UNC (\\servername\resource) '; en = 'Volume path must be in UNC format (\\servername\resource) '");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ПолныйПутьWindows", "Объект");
		
		Возврат;
	КонецЕсли;
	
	Если Не ПутьТомаУникален(ПолныйПутьWindows, ПолныйПутьLinux, Ссылка) Тогда
		Отказ = Истина;
		
		ТекстОшибки = НСтр("ru = 'Полный путь тома не уникален - уже есть том с таким путем'; en = 'The full path of the volume is not unique - there is already a volume with same path'");
		
		Если ЗначениеЗаполнено(ПолныйПутьWindows) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ПолныйПутьWindows", "Объект");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПолныйПутьLinux) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ПолныйПутьLinux", "Объект");
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Родитель) Тогда
		
		ТекстОшибки = НСтр("ru = 'Нельзя создавать том, не входящий ни в одну группу'; en = 'You cannot create a volume that is not a member of any group'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "Родитель", "Объект", Отказ);
		
	КонецЕсли;	
	
	ИмяПоляСПолнымПутем = "";
	
	Попытка
		ПолныйПутьТома = "";
		
		ТипПлатформыСервера = ОбщегоНазначенияДокументооборотПовтИсп.ТипПлатформыСервера();
		
		Если ТипПлатформыСервера = ТипПлатформы.Windows_x86 ИЛИ ТипПлатформыСервера = ТипПлатформы.Windows_x86_64 Тогда
			ПолныйПутьТома = ПолныйПутьWindows;
			ИмяПоляСПолнымПутем = "ПолныйПутьWindows";
		Иначе	
			ПолныйПутьТома = ПолныйПутьLinux;
			ИмяПоляСПолнымПутем = "ПолныйПутьLinux";
		КонецЕсли;
		
		ИмяКаталогаТестовое = ПолныйПутьТома + "ПроверкаДоступа\";
		СоздатьКаталог(ИмяКаталогаТестовое);
		УдалитьФайлы(ИмяКаталогаТестовое);
	Исключение
		Отказ = Истина;
		
		ТекстОшибки = НСтр("ru = 'Путь к тому некорректен. Возможно учетная запись, от лица которой работает сервер 1С:Предприятия, не имеет прав доступа к каталогу тома: '; en = 'Volume path is incorrect. Possibly the account of the person running the 1C:Enterprise Server does not have permission to access this directory: '");
		Информация = ИнформацияОбОшибке();
		Если Информация.Причина <> Неопределено Тогда
			ТекстОшибки = ТекстОшибки + Информация.Причина.Описание;
			
			Если Информация.Причина.Причина <> Неопределено Тогда
				ТекстОшибки = ТекстОшибки + ": " + Информация.Причина.Причина.Описание;
			КонецЕсли;
		Иначе
			ТекстОшибки = ТекстОшибки + Информация.Описание;
		КонецЕсли;
			
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , ИмяПоляСПолнымПутем, "Объект");
		
	КонецПопытки;
	
	Если МаксимальныйРазмер <> 0 Тогда
		ТекущийРазмерВБайтах = 0;
		Если Не Ссылка.Пустая() Тогда
			ТекущийРазмерВБайтах = ФайловыеФункции.ПодсчитатьРазмерФайловНаТоме(Ссылка); 
		КонецЕсли;
		ТекущийРазмер = ТекущийРазмерВБайтах / (1024 * 1024);
		
		Если МаксимальныйРазмер < ТекущийРазмер Тогда
			Отказ = Истина;
			
			ТекстОшибки = НСтр("ru = 'Максимальный размер тома меньше, чем текущий размер'; en = 'Maximum volume size is less than the current size'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "МаксимальныйРазмер", "Объект");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает Ложь, если есть том с таким порядком
Функция НомерПорядкаУникален(ПорядокЗаполнения, СсылкаНаТом, Родитель)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	КОЛИЧЕСТВО(Тома.ПорядокЗаполнения) КАК Количество
	               |ИЗ
	               |	Справочник.ТомаХраненияФайлов КАК Тома
	               |ГДЕ
	               |	Тома.ПорядокЗаполнения = &ПорядокЗаполнения
	               |	И Тома.Ссылка <> &СсылкаНаТом
	               |	И Тома.Родитель = &Родитель";
	
	Запрос.Параметры.Вставить("ПорядокЗаполнения", ПорядокЗаполнения);
	Запрос.Параметры.Вставить("СсылкаНаТом", СсылкаНаТом);
	Запрос.Параметры.Вставить("Родитель", Родитель); // только в своей группе проверяем уникальность
				   
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если Выборка.Количество = 0 Тогда
			Возврат Истина;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции // НайтиМаксимальныйНомерВерсии

// Возвращает Ложь, если есть том с таким порядком
Функция ПутьТомаУникален(ПолныйПутьWindows, ПолныйПутьLinux, СсылкаНаТом)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	КОЛИЧЕСТВО(Тома.ПорядокЗаполнения) КАК Количество
	               |ИЗ
	               |	Справочник.ТомаХраненияФайлов КАК Тома
	               |ГДЕ
	               |	Тома.ПолныйПутьWindows ПОДОБНО &ПолныйПутьWindows
	               |	И Тома.ПолныйПутьLinux ПОДОБНО &ПолныйПутьLinux
	               |	И Тома.Ссылка <> &СсылкаНаТом";
	
	Запрос.Параметры.Вставить("ПолныйПутьWindows", ПолныйПутьWindows);
	Запрос.Параметры.Вставить("ПолныйПутьLinux", ПолныйПутьLinux);
	Запрос.Параметры.Вставить("СсылкаНаТом", СсылкаНаТом);
				   
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если Выборка.Количество = 0 Тогда
			Возврат Истина;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции // НайтиМаксимальныйНомерВерсии

//// Для совместимости с БСП
//Процедура ДобавитьЗапросыНаИспользованиеВнешнихРесурсовВсехТомов(Запросы) Экспорт
//КонецПроцедуры

#КонецЕсли
