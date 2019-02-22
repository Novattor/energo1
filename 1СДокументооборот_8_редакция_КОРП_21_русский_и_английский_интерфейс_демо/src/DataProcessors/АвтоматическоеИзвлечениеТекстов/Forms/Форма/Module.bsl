////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВключеноИзвлечениеТекста = Ложь;
	
	ИнтервалВремениВыполнения = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"АвтоматическоеИзвлечениеТекстов", "ИнтервалВремениВыполнения");
	Если ИнтервалВремениВыполнения = 0 Тогда
		ИнтервалВремениВыполнения = 60;
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"АвтоматическоеИзвлечениеТекстов", "ИнтервалВремениВыполнения",  ИнтервалВремениВыполнения);
	КонецЕсли;	
	
	КоличествоФайловСНеизвлеченнымТекстом = РаботаСФайламиВызовСервера.ПолучитьКоличествоВерсийСНеизвлеченнымТекстом();
	Если КоличествоФайловСНеизвлеченнымТекстом > 0 Тогда 
		Элементы.Старт.КнопкаПоУмолчанию = Истина;
	Иначе
		Элементы.Закрыть.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
	КоличествоФайловВПорции = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"АвтоматическоеИзвлечениеТекстов", "КоличествоФайловВПорции");
	Если КоличествоФайловВПорции = 0 Тогда
		КоличествоФайловВПорции = 100;
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"АвтоматическоеИзвлечениеТекстов", "КоличествоФайловВПорции",  КоличествоФайловВПорции);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
#Если ВебКлиент Тогда
	Отказ = Истина;
	ПоказатьПредупреждение(, НСтр("ru = 'В Веб-клиенте извлечение текстов не поддерживается.'; en = 'Extracting texts is not supported in web client.'"));
	Возврат;
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалВремениВыполненияПриИзменении(Элемент)
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
		"АвтоматическоеИзвлечениеТекстов", "ИнтервалВремениВыполнения",  ИнтервалВремениВыполнения);
	
	Если ВключеноИзвлечениеТекста Тогда
		ОтключитьОбработчикОжидания("ИзвлечениеТекстовКлиентОбработчик");
		ПрогнозируемоеВремяНачалаИзвлечения = ТекущаяДата() + ИнтервалВремениВыполнения;
		ПодключитьОбработчикОжидания("ИзвлечениеТекстовКлиентОбработчик", ИнтервалВремениВыполнения);
		ОбновлениеОбратногоОтсчета();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики команд формы
//

////////////////////////////////////////////////////////////////////////////////
// Служебные
//

&НаСервереБезКонтекста
Процедура ЗаписьЖурналаРегистрацииСервер(ТекстСообщения)
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Извлечение текста файла'; en = 'File text retrieval'", Метаданные.ОсновнойЯзык.КодЯзыка),
		УровеньЖурналаРегистрации.Ошибка, , , ТекстСообщения);
	
КонецПроцедуры

// Обновляет обратный отсчет
//
&НаКлиенте
Процедура ОбновлениеОбратногоОтсчета()
	
	Осталось = ПрогнозируемоеВремяНачалаИзвлечения - ТекущаяДата();
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'До начала извлечения текстов осталось %1 сек'; en = 'To start the extraction of texts left %1 sec'"), 
							Осталось);
	
	Если Осталось <= 1 Тогда
		ТекстСообщения = "";
	КонецЕсли;
	
	ИнтервалВремениВыполнения = Элементы.ИнтервалВремениВыполнения.ТекстРедактирования;
	Статус = ТекстСообщения;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзвлечениеТекстовКлиентОбработчик()
	
#Если НЕ ВебКлиент Тогда
	ИзвлечениеТекстовКлиент();
#КонецЕсли	

КонецПроцедуры

#Если НЕ ВебКлиент Тогда
// Извлекает текст из файлов на диске на клиенте
&НаКлиенте
Процедура ИзвлечениеТекстовКлиент(РазмерПорции = Неопределено)
	
	ПрогнозируемоеВремяНачалаИзвлечения = ТекущаяДата() + ИнтервалВремениВыполнения;
	
	Состояние(НСтр("ru = 'Начато извлечение текста'; en = 'Started extracting text'"));
	
	Попытка
		
		РазмерПорцииТекущий = КоличествоФайловВПорции;
		Если РазмерПорции <> Неопределено Тогда
			РазмерПорцииТекущий = РазмерПорции;
		КонецЕсли;	
		МассивФайлов = ПолучитьФайлыДляИзвлеченияТекста(РазмерПорцииТекущий);
		
		Если МассивФайлов.Количество() = 0 Тогда
			Состояние(НСтр("ru = 'Нет файлов для извлечения текста'; en = 'No files to extract text'"));
			Возврат;
		КонецЕсли;
		
		Для Индекс = 0 По МассивФайлов.Количество() - 1 Цикл
			
			Расширение = МассивФайлов[Индекс].Расширение;
			НаименованиеФайла = МассивФайлов[Индекс].Наименование;
			ФайлИлиВерсияФайла = МассивФайлов[Индекс].Ссылка;
			Кодировка = МассивФайлов[Индекс].Кодировка;
			
			Попытка
				
				АдресФайла = ФайловыеФункцииПереопределяемый.ПолучитьНавигационнуюСсылкуФайла(ФайлИлиВерсияФайла,
					УникальныйИдентификатор);
				
				ИмяСРасширением = ФайловыеФункцииКлиентСервер.ПолучитьИмяСРасширением(НаименованиеФайла, Расширение);
				Прогресс = Индекс * 100 / МассивФайлов.Количество();
				Состояние(НСтр("ru = 'Идет извлечение текста файла'; en = 'File text extraction in progress'"), Прогресс, ИмяСРасширением);
				
				ФайловыеФункцииКлиент.ИзвлечьТекстВерсии(ФайлИлиВерсияФайла, АдресФайла, Расширение, 
					УникальныйИдентификатор, Кодировка);
				
			Исключение
				
				ОписаниеОшибкиИнфо = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
										НСтр("ru = 'Во время извлечения текста из файла ""%1"" произошла неизвестная ошибка.'; en = 'An unknown error has occurred while extracting text from file ""%1"" .'"), 
										Строка(ФайлИлиВерсияФайла));
										
				ТекстСообщения = ТекстСообщения + Строка(ОписаниеОшибкиИнфо);
				
				Состояние(ТекстСообщения);
				
				РезультатИзвлечения = "ИзвлечьНеУдалось";
				ЗаписьОшибкиИзвлечения(ФайлИлиВерсияФайла, РезультатИзвлечения, ТекстСообщения);
				
			КонецПопытки;
				
		КонецЦикла;
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								 НСтр("ru = 'Извлечение текста завершено. Обработано файлов: %1'; en = 'Text extraction is complete. Files processed: %1'"), 
								 МассивФайлов.Количество());
		Состояние(ТекстСообщения);
		
	Исключение
		
		ОписаниеОшибкиИнфо = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru = 'Во время извлечения текста из файла ""%1"" произошла неизвестная ошибка.'; en = 'An unknown error has occurred while extracting text from file ""%1"" .'"), 
								Строка(ФайлИлиВерсияФайла));
								
		ТекстСообщения = ТекстСообщения + Строка(ОписаниеОшибкиИнфо);
		
		Состояние(ТекстСообщения);
		
		// запись в журнал регистрации
		ЗаписьЖурналаРегистрацииСервер(ТекстСообщения);
		
	КонецПопытки;
	
	КоличествоФайловСНеизвлеченнымТекстом = РаботаСФайламиВызовСервера.ПолучитьКоличествоВерсийСНеизвлеченнымТекстом();
	
КонецПроцедуры
#КонецЕсли

&НаСервереБезКонтекста
Процедура ЗаписьОшибкиИзвлечения(ФайлИлиВерсияФайла, РезультатИзвлечения, ТекстСообщения)
	
	ФайловыеФункции.ЗаписатьРезультатИзвлеченияТекста(ФайлИлиВерсияФайла, РезультатИзвлечения, "");
	
	// запись в журнал регистрации
	ЗаписьЖурналаРегистрацииСервер(ТекстСообщения);
	
КонецПроцедуры	

&НаСервереБезКонтекста
Функция ПолучитьФайлыДляИзвлеченияТекста(КоличествоФайловВПорции)
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос;
	РаботаСФайламиВызовСервера.ПолучитьТекстЗапросаИзвлеченияТекста(Запрос.Текст, КоличествоФайловВПорции);
	
	Для Каждого Строка Из Запрос.Выполнить().Выгрузить() Цикл
		
        Кодировка = РаботаСФайламиВызовСервера.ПолучитьКодировкуВерсииФайла(Строка.Ссылка);
        
        Результат.Добавить(Новый Структура("Ссылка, Расширение, Наименование, Кодировка", 
            Строка.Ссылка, Строка.Расширение, Строка.Наименование, Кодировка));
			
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура Старт(Команда)
	
	ВключеноИзвлечениеТекста = Истина; 
	
	ПрогнозируемоеВремяНачалаИзвлечения = ТекущаяДата();
	ПодключитьОбработчикОжидания("ИзвлечениеТекстовКлиентОбработчик", ИнтервалВремениВыполнения);
	
#Если НЕ ВебКлиент Тогда
	ИзвлечениеТекстовКлиентОбработчик();
#КонецЕсли
	
	ПодключитьОбработчикОжидания("ОбновлениеОбратногоОтсчета", 1);
	ОбновлениеОбратногоОтсчета();
	
КонецПроцедуры

&НаКлиенте
Процедура Стоп(Команда)
	
	ВыполнитьСтоп();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСтоп()
	
	ОтключитьОбработчикОжидания("ИзвлечениеТекстовКлиентОбработчик");
	ОтключитьОбработчикОжидания("ОбновлениеОбратногоОтсчета");
	Статус = "";
	ВключеноИзвлечениеТекста = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзвлечьВсе(Команда)
	
	#Если НЕ ВебКлиент Тогда
		КоличествоФайловСНеизвлеченнымТекстомДоНачалаОперации = КоличествоФайловСНеизвлеченнымТекстом;
		Статус = "";
		РазмерПорции = 0; // извлечь все
		ИзвлечениеТекстовКлиент(РазмерПорции);
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Завершено извлечение текста из всех файлов с неизвлеченным текстом. Обработано файлов: %1.'; en = 'Completed text extraction from all files with not extracted text. Files processed: %1.'"),
			КоличествоФайловСНеизвлеченнымТекстомДоНачалаОперации);
		ПоказатьПредупреждение(, ТекстСообщения);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоФайловВПорцииПриИзменении(Элемент)
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
		"АвтоматическоеИзвлечениеТекстов", "КоличествоФайловВПорции",  КоличествоФайловВПорции);
	
КонецПроцедуры


