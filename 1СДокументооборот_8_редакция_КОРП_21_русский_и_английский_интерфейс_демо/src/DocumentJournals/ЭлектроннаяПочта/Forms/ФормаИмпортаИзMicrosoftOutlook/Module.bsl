&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест". 
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УчетнаяЗапись = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ЭтаФорма.ИмяФормы, "УчетнаяЗапись");
	Папка = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ЭтаФорма.ИмяФормы, "Папка");
	ПапкаMicrosoftOutlook = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ЭтаФорма.ИмяФормы, "ПапкаMicrosoftOutlook");
	ПомечатьКакПрочитанные = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ЭтаФорма.ИмяФормы, "ПомечатьКакПрочитанные");
	
	МоиАдреса = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		ЭтаФорма.ИмяФормы, 
		"МоиАдреса");
		
	Если ЗначениеЗаполнено(УчетнаяЗапись) И Не ЗначениеЗаполнено(МоиАдреса) Тогда
		МоиАдреса = УчетнаяЗапись.АдресЭлектроннойПочты;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(ЭтаФорма.ИмяФормы, "УчетнаяЗапись", УчетнаяЗапись);
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(ЭтаФорма.ИмяФормы, "Папка", Папка);
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(ЭтаФорма.ИмяФормы, "ПапкаMicrosoftOutlook", ПапкаMicrosoftOutlook);
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(ЭтаФорма.ИмяФормы, "ПомечатьКакПрочитанные", ПомечатьКакПрочитанные);
		
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
		ЭтаФорма.ИмяФормы, 
		"МоиАдреса", 
		МоиАдреса);
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкаMicrosoftOutlookНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПапкаMicrosoftOutlookНачалоВыбораЗавершение", ЭтотОбъект);
	РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ОткрытьФорму("Обработка.НастройкаПочты.Форма.ЗагрузкаMSOutlook", , , , , , ОписаниеОповещения, РежимОткрытияОкна);
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкаMicrosoftOutlookНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ПапкаMicrosoftOutlook = Результат.Данные.Путь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;

	Состояние(НСтр("ru = 'Выполняется загрузка писем из Microsoft Outlook. Пожалуйста подождите...'; en = 'Loading emails from Microsoft Outlook. Please wait ...'"));
	Результат = ЗагрузитьПисьмаВПапку();
	Если ЗначениеЗаполнено(Результат.СообщениеОбОшибке) Тогда
		ПоказатьПредупреждение(, Результат.СообщениеОбОшибке);
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьЗавершение", ЭтотОбъект);
	
	СтрокаСообщения = 
		НСтр("ru = 'Загрузка писем из Microsoft Outlook завершена. Загружено исходящих - %1, входящих - %2, пропущено - %3.'; en = 'Loading emails from Microsoft Outlook completed. Loaded outgoing - %1, incoming - %2, skipped - %3.'");
	СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		СтрокаСообщения,
		Результат.ЗагруженоИсходящих,
		Результат.ЗагруженоВходящих,
		Результат.Пропущено);
	ПоказатьПредупреждение(ОписаниеОповещения, СтрокаСообщения);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьЗавершение(ДополнительныеПараметры) Экспорт
	
	Оповестить("ПисьмаИзменены",, ЭтаФорма);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Функция ЗагрузитьПисьмаВПапку()
	
	Результат = Новый Структура;
	Результат.Вставить("СообщениеОбОшибке", "");
	Результат.Вставить("ЗагруженоИсходящих", 0);
	Результат.Вставить("ЗагруженоВходящих", 0);
	Результат.Вставить("Пропущено", 0);
	
	Folder = ЛегкаяПочтаКлиент.ПолучитьПапкуMSOutlook(ПапкаMicrosoftOutlook);
	Если Folder = Неопределено Тогда
		Результат.СообщениеОбОшибке = 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Папка %1 не найдена'; en = 'The folder %1 not found'"),
		ПапкаMicrosoftOutlook);
		Возврат Результат;
	КонецЕсли;
	
	ВерсияOutlook = 12;
	
	Попытка 
		ВерсияСтрока = Folder.Application.Version;
		МассивСтрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ВерсияСтрока, ".");
		Если МассивСтрок.Количество() > 0 Тогда
			ПервоеЧислоВерсии = МассивСтрок[0];
			ВерсияOutlook = Число(ПервоеЧислоВерсии);
		КонецЕсли;
	Исключение
	КонецПопытки;
	
	ПисьмаMSOItems = Неопределено;
	
	Если ВерсияOutlook > 11 Тогда // старше чем Outlook 2003
		ПисьмаMSOItems = Folder.Items.Restrict("[UnRead] = True");
	Иначе
		ПисьмаMSOItems = Folder.Items;
	КонецЕсли;
	
	КоличествоСообщений = ПисьмаMSOItems.Count();
	ПараметрыЗагрузки = Новый Структура;		
	ПараметрыЗагрузки.Вставить("ЗагруженоИсходящих", 0);
	ПараметрыЗагрузки.Вставить("ЗагруженоВходящих", 0);
	ПараметрыЗагрузки.Вставить("Пропущено", 0);	
		
	Если КоличествоСообщений = 0 Тогда
		Результат.СообщениеОбОшибке = НСтр("ru = 'Нет писем для загрузки'; en = 'No emails to load'");
		Возврат Результат;
	КонецЕсли;
	
	Пока Истина Цикл
		ОбработкаПрерыванияПользователя();
		
		Если ВерсияOutlook > 11 Тогда // старше чем Outlook 2003
			ПисьмаMSOItems = Folder.Items.Restrict("[UnRead] = True");
		Иначе
			ПисьмаMSOItems = Folder.Items;
		КонецЕсли;
		
		ПисьмаMSO = Новый Массив;
		СообщенийВПакете = 0;
		КоличествоСообщенийВсего = ПисьмаMSOItems.Count();
		
		Если ВерсияOutlook > 11 Тогда // старше чем Outlook 2003
			ПараметрыЗагрузки.Вставить("КоличествоСообщений", КоличествоСообщенийВсего 
				+ ПараметрыЗагрузки.ЗагруженоИсходящих + ПараметрыЗагрузки.ЗагруженоВходящих + ПараметрыЗагрузки.Пропущено);
		Иначе
			ПараметрыЗагрузки.Вставить("КоличествоСообщений", КоличествоСообщенийВсего);
		КонецЕсли;
			
		Для Индекс = 1 По КоличествоСообщенийВсего Цикл
			Если ПисьмаMSOItems.Item(Индекс).Class <> 43 Тогда
				Продолжить;
			КонецЕсли;
			
			ПисьмоMSO = ПисьмаMSOItems.Item(Индекс);

			ИспользоватьПисьмо = Истина;
				
			Если ВерсияOutlook <= 11 Тогда // Outlook 2003 и раньше
				ИспользоватьПисьмо = (ПисьмоMSO.UnRead <> 0);
			КонецЕсли;

			Если Не ИспользоватьПисьмо Тогда
				Продолжить;
			КонецЕсли;

			Если СообщенийВПакете < 20 Тогда
				ПисьмаMSO.Добавить(ПисьмоMSO);
				
				СообщенийВПакете  = СообщенийВПакете + 1;
			Иначе
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ПисьмаMSO.Количество() = 0 Тогда
			Прервать;
		КонецЕсли;
		
		ЗагрузитьЧастьПисем(ПараметрыЗагрузки, ПисьмаMSO);
		ЗаписатьЧастьПисем(ПараметрыЗагрузки.Сообщения);
		ПометитьКакПрочтенные(ПараметрыЗагрузки.Сообщения);
		ОтобразитьСостояние(ПараметрыЗагрузки);
		
	КонецЦикла;
		
	Результат.ЗагруженоИсходящих = ПараметрыЗагрузки.ЗагруженоИсходящих;
	Результат.ЗагруженоВходящих = ПараметрыЗагрузки.ЗагруженоВходящих;
	Результат.Пропущено = ПараметрыЗагрузки.Пропущено;
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОтобразитьСостояние(ПараметрыЗагрузки)
	
	КоличествоСообщений = ПараметрыЗагрузки.КоличествоСообщений;
	Загружено = ПараметрыЗагрузки.ЗагруженоИсходящих + ПараметрыЗагрузки.ЗагруженоВходящих + ПараметрыЗагрузки.Пропущено;
	Прогресс = 100;
	Если КоличествоСообщений > 0 Тогда
		Прогресс = Окр(Загружено * 100 / КоличествоСообщений, 0, 1);
	КонецЕсли;
	Состояние(
		НСтр("ru = 'Выполняется загрузка писем из Microsoft Outlook...'; en = 'Loading emails from Microsoft Outlook...'"),
		Прогресс,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Обработано %1 из %2'; en = 'Processed %1 of %2'"),
			Загружено,
			КоличествоСообщений));
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьЧастьПисем(ПараметрыЗагрузки, ПисьмаMSO)
	
	Сообщения = Новый Массив;
	
	Для каждого ПисьмоMSO Из ПисьмаMSO Цикл
		
		Если ПисьмоMSO.Class <> 43 Тогда // Не OlObjectClass.olMail
			Продолжить;
		КонецЕсли;
		
		Сообщение = Почта.СформироватьСтруктуруПочтовогоСообщения();

		Сообщение.Важность = ПолучитьВажностьПисьмаИзВажностиПисьмаMSO(ПисьмоMSO);
		
		// Для некоторых писем в поле SentOn хранится недопустимая для 1С дата 01.01.4501,
		// что приводит к ошибке при записи. Поэтому все даты больше 01.01.2100
		// будем заменять на дату создания.
		ДатаОтправки = ТекущаяДата();
		Если ЗначениеЗаполнено(ПисьмоMSO.SentOn) И ПисьмоMSO.SentOn < '21000101' Тогда
			ДатаОтправки = ПисьмоMSO.SentOn;
		ИначеЕсли ЗначениеЗаполнено(ПисьмоMSO.CreationTime) И ПисьмоMSO.CreationTime < '21000101' Тогда
			ДатаОтправки = ПисьмоMSO.CreationTime;
		КонецЕсли;
		
		Сообщение.ДатаОтправки = ДатаОтправки;
		Сообщение.ДатаПолучения = ДатаОтправки;

		// Считать заголовки письма PR_TRANSPORT_MESSAGE_HEADERS
		Попытка
			PR_TRANSPORT_MESSAGE_HEADERS = "http://schemas.microsoft.com/mapi/proptag/0x007D001E";
			Сообщение.Заголовок = РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(
				ПисьмоMSO.PropertyAccessor.GetProperty(PR_TRANSPORT_MESSAGE_HEADERS));
		Исключение
			// Считывание заголовков невозможно, версия Outlook 2003 и ниже
			Сообщение.Заголовок = "";
		КонецПопытки;

		ИдентификаторыПисьма = ВстроеннаяПочтаСервер.ИдентификаторыПисьмаИзЗаголовка(Сообщение.Заголовок);

		Сообщение.Вставить("ИдентификаторОснования", ИдентификаторыПисьма.ИдентификаторОснования);
		Сообщение.ИдентификаторСообщения = ИдентификаторыПисьма.ИдентификаторСообщения;
		
		Сообщение.Вставить("ИдентификаторOutlook", 
			ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(ПисьмоMSO.EntryID));
			
		Если Сообщение.ИдентификаторСообщения = "" Тогда
			Сообщение.ИдентификаторСообщения = Строка(Новый УникальныйИдентификатор);
		КонецЕсли;
		
		Сообщение.Вставить("ЭтоИсходящееПисьмо", ЭтоИсходящееПисьмоMSO(ПисьмоMSO));
		
		Сообщение.Вставить("ЗаписыватьВБазу", Истина);
		
		// Если письмо уже загружалось или не является письмом текущего пользователя, то пропустить.
		ПисьмоЗагруженоВБазу = ВстроеннаяПочтаСервер.НайтиПисьмоПоИдентификаторуOutlook(ПисьмоMSO.EntryID) <> Неопределено;
			
		Если ПисьмоЗагруженоВБазу Или Сообщение.ЭтоИсходящееПисьмо = Неопределено Тогда
			Сообщение.ЗаписыватьВБазу = Ложь;
			Сообщения.Добавить(Сообщение);
			ПараметрыЗагрузки.Пропущено = ПараметрыЗагрузки.Пропущено + 1;
			Продолжить;
		КонецЕсли;

		ОтправительАдрес = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(ПисьмоMSO.SenderEmailAddress);
		ОтправительОтображаемоеИмя = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(ПисьмоMSO.SenderName);
		ОтправительАдресат = ВстроеннаяПочтаСерверПовтИсп.ПолучитьПочтовогоАдресата(ОтправительАдрес, ОтправительОтображаемоеИмя);
		Сообщение.Вставить("ОтправительАдресат", ОтправительАдресат);
		
		Сообщение.Размер = ПисьмоMSO.Size;
		Сообщение.Тема = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(ПисьмоMSO.Subject);
		
		ИдентификаторыКартинокHTML = Новый Массив;
		Если ПисьмоMSO.BodyFormat = 2 Тогда // OlBodyFormat.olFormatHTML
			ТипТекста = ПредопределенноеЗначение("Перечисление.ТипыТекстовПочтовыхСообщений.HTML");
			ТекстHTML = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(ПисьмоMSO.HTMLBody);
			ВстроеннаяПочтаСервер.ДобавитьНеобходимыеТэгиHTML(ТекстHTML);
			ИдентификаторыКартинокHTML = ПолучитьИдентификаторыКартинок(ТекстHTML);
			Текст = "";
		Иначе
			ТипТекста = ПредопределенноеЗначение("Перечисление.ТипыТекстовПочтовыхСообщений.ПростойТекст");
			Текст = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(ПисьмоMSO.Body);
			ТекстHTML = "";
		КонецЕсли;
		Сообщение.Вставить("ТипТекста", ТипТекста);
		Сообщение.Вставить("Текст", Текст);
		Сообщение.Вставить("ТекстHTML", ТекстHTML);
		Сообщение.Вставить("Кодировка", "");
		
		Сообщение.Вставить("ПолучателиПисьмаСтрокой", "");
		Сообщение.Вставить("ПолучателиКопийСтрокой", "");
		Сообщение.Вставить("ПолучателиПисьма", Новый Массив);
		Сообщение.Вставить("ПолучателиКопий", Новый Массив);
		Для каждого Recipient Из ПисьмоMSO.Recipients Цикл
			Address = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(Recipient.Address);
			Name = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(Recipient.Name);
			ПолучательИнфо = Новый Структура;
			ПолучательАдресат = ВстроеннаяПочтаСерверПовтИсп.ПолучитьПочтовогоАдресата(Address, Name);
			ПолучательИнфо.Вставить("Адресат", ПолучательАдресат);
			Если Recipient.Type = 1 Тогда // OlMailRecipientType.olTo
				Сообщение.ПолучателиПисьма.Добавить(ПолучательИнфо);
			ИначеЕсли Recipient.Type = 2 Тогда // OlMailRecipientType.olCC
				Сообщение.ПолучателиКопий.Добавить(ПолучательИнфо);
			ИначеЕсли Recipient.Type = 3 Тогда // OlMailRecipientType.olBCC
				
			ИначеЕсли Recipient.Type = 4 Тогда // OlMailRecipientType.olOriginator
				
			КонецЕсли;
			
		КонецЦикла;
		
		Сообщение.Вставить("ПолучателиОтвета", Новый Массив);
		Для каждого ReplyRecipient Из ПисьмоMSO.ReplyRecipients Цикл
			Address = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(ReplyRecipient.Address);
			Name = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(ReplyRecipient.Name);
			ПолучательИнфо = Новый Структура;
			ПолучательАдресат = ВстроеннаяПочтаСерверПовтИсп.ПолучитьПочтовогоАдресата(Address, Name);
			ПолучательИнфо.Вставить("Адресат", ПолучательАдресат);
			Сообщение.ПолучателиОтвета.Добавить(ПолучательИнфо);
		КонецЦикла;
		
		Сообщение.Вставить("Картинки", Новый Массив);
		Сообщение.Вставить("Вложения", Новый Массив);
		Для каждого Attachment Из ПисьмоMSO.Attachments Цикл
			AttachmentType = Attachment.Type;
			Если AttachmentType = 6 Тогда // OlAttachmentType.olOLE
				Продолжить;
			КонецЕсли;
			FileName = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(Attachment.FileName);
			DisplayName = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(Attachment.DisplayName);
			
			ПолноеИмяВременногоФайла = ПолучитьПолноеИмяВременногоФайла(FileName);
			
			Попытка
				
				Attachment.SaveAsFile(ПолноеИмяВременногоФайла);
				
				Наименование = DisplayName;
				ИмяФайла = FileName;
				
				ИдентификаторВложения = "";
				
				Если Сообщение.ТипТекста = ПредопределенноеЗначение("Перечисление.ТипыТекстовПочтовыхСообщений.HTML") Тогда
					Попытка
						// Получить cid вложения
						PR_ATTACH_CONTENT_ID = "http://schemas.microsoft.com/mapi/proptag/0x3712001E";
						ИдентификаторВложения = Attachment.PropertyAccessor.GetProperty(PR_ATTACH_CONTENT_ID);
					Исключение
						// При ошибке чтения свойства, ниже попытка найти cid по имени файла
					КонецПопытки;
					
					Если Не ЗначениеЗаполнено(ИдентификаторВложения) Тогда
						ИдентификаторВложения = НайтиИдентификаторКартинки(ИдентификаторыКартинокHTML, ИмяФайла);
					КонецЕсли;
				КонецЕсли;
				
				ПоместитьВложениеВоВременноеХранилище(
				Сообщение,
				ПолноеИмяВременногоФайла,
				ИмяФайла,
				ИдентификаторВложения);
				
				УдалитьФайлы(ПолноеИмяВременногоФайла);
				
			Исключение
				
				УдалитьФайлы(ПолноеИмяВременногоФайла);
				
				СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при загрузке вложения письма из Microsoft Outlook
				|%1
				|Письмо: %2
				|Полное имя временного файла: %3';
				|en = 'Error loading email attachment  from Microsoft Outlook
				|%1 
				|Email: %2
				|The full name of a temporary file: %3'"),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
				Сообщение.Тема,
				ПолноеИмяВременногоФайла);
				
				Почта.ЗаписатьОшибкуВЖурналРегистрации(СообщениеОбОшибке);
				
			КонецПопытки;
			
		КонецЦикла;
		
		Сообщение.Вставить("ЕстьВложения", Сообщение.Вложения.Количество() > 0);

		Сообщения.Добавить(Сообщение);

		Если Сообщение.ЭтоИсходящееПисьмо Тогда
			ПараметрыЗагрузки.ЗагруженоИсходящих = ПараметрыЗагрузки.ЗагруженоИсходящих + 1;
		Иначе 	
			ПараметрыЗагрузки.ЗагруженоВходящих = ПараметрыЗагрузки.ЗагруженоВходящих + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	ПараметрыЗагрузки.Вставить("Сообщения", Сообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьВложениеВоВременноеХранилище(Сообщение, ПолноеИмяФайла, ИмяФайла, ИдентификаторВложения)
	
	Файл = Новый Файл(ПолноеИмяФайла);
	Размер = Файл.Размер();
	
	Данные = Новый ДвоичныеДанные(ПолноеИмяФайла);
	Адрес = ПоместитьВоВременноеХранилище(Данные, ЭтаФорма.УникальныйИдентификатор);
	
	Вложение = Новый Структура;
	Вложение.Вставить("ПолноеИмяФайла", ПолноеИмяФайла);
	Вложение.Вставить("ИмяФайла", ИмяФайла);
	Вложение.Вставить("Идентификатор", ИдентификаторВложения);
	Вложение.Вставить("Размер", Размер);
	Вложение.Вставить("Адрес", Адрес);
	
	Сообщение.Вложения.Добавить(Вложение);
	
КонецПроцедуры

&НаКлиенте
Функция НайтиИдентификаторКартинки(ИдентификаторыКартинокHTML, ИмяФайла)
	
	Для каждого ИдентификаторКартинки Из ИдентификаторыКартинокHTML Цикл
		Если Найти(ИдентификаторКартинки, "cid:" + ИмяФайла + "@") > 0 Тогда
			Возврат ИдентификаторКартинки;
		КонецЕсли;
	КонецЦикла;
	
	Возврат "";
	
КонецФункции

&НаКлиенте
Функция ПолучитьПолноеИмяВременногоФайла(ИмяФайла)
	
	Возврат ПолучитьИмяВременногоКаталога() + "\" + ИмяФайла;
	
КонецФункции

&НаКлиенте
Функция ПолучитьИмяВременногоКаталога()
	
	#Если ВебКлиент Тогда
		Возврат "";
	#Иначе
		ИмяВременногоКаталога = ПолучитьИмяВременногоФайла("");
		СоздатьКаталог(ИмяВременногоКаталога);
		Возврат ИмяВременногоКаталога;
	#КонецЕсли
	
КонецФункции

&НаКлиенте
Функция ПолучитьИдентификаторыКартинок(ТекстHTML)
	
	Результат = Новый Массив;
	
	Построитель = Новый ПостроительDOM;
	ЧтениеHTML = Новый ЧтениеHTML;
	ЧтениеHTML.УстановитьСтроку(ТекстHTML);
	ДокументHTML = Построитель.Прочитать(ЧтениеHTML);
	Ссылки = ДокументHTML.Картинки;
	Для каждого Картинка Из ДокументHTML.Картинки Цикл
		Результат.Добавить(Картинка.Источник);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПометитьКакПрочтенные(Сообщения)
	
	Application = Новый COMОбъект("Outlook.Application");
	Для каждого Сообщение Из Сообщения Цикл		
		ПисьмоMSO = Application.Session.GetItemFromID(Сообщение.ИдентификаторOutlook);		
		
		Попытка
			ПисьмоMSO.UnRead = 0;
		Исключение
			// Тут всегда возникает исключение, но действие выполняется правильно.
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьЧастьПисем(Сообщения)
	
	Для каждого Сообщение Из Сообщения Цикл
		Если Сообщение.ЗаписыватьВБазу Тогда
			ЗаписатьПисьмо(УчетнаяЗапись, Папка, Сообщение);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Установить возможные связи загружаемого письма
// 
&НаСервере
Процедура УстановитьСвязиСПисьмом(Письмо)
	
	УстановитьСвязьСОснованием(Письмо);
	УстановитьСвязьСОтветами(Письмо);
	
КонецПроцедуры

// Проверяет, является ли письмо Outlook исходящим
//
// Возвращаемое значение:
//  Булево - Истина, письмо является исходящим
//  Булево - Ложь, письмо является входящим
//  Неопределено, письмо не является письмом текущего пользователя
//
&НаКлиенте
Функция ЭтоИсходящееПисьмоMSO(ПисьмоMSO)	
	
	Если ЗначениеЗаполнено(ПисьмоMSO.SenderEmailAddress) Тогда
		// Если адрес отправителя совпадает с одним из адресов (Мои адреса)
		// введенных пользователем, то письмо - исходящее.
		Если МоиАдресаСписок.НайтиПоЗначению(НРег(ПисьмоMSO.SenderEmailAddress)) <> Неопределено Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Установить возможную связь письма с основанием
// 
&НаСервере
Процедура УстановитьСвязьСОснованием(Письмо)
	
	ИдентификаторОснования = 
		РегистрыСведений.ИдентификаторыИмпортированныхПисем.ПолучитьИдентификаторОснования(Письмо);
		
	Если Не ЗначениеЗаполнено(ИдентификаторОснования) Тогда
		Возврат;
	КонецЕсли;

	Основание = ПолучитьПисьмоОснование(Письмо);
	
	// Если основание найдено и связь существует, завершить
	Если ЗначениеЗаполнено(Основание) Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоИсходящееПисьмо = ВстроеннаяПочтаКлиентСервер.ЭтоИсходящееПисьмо(Письмо);

	// Попытка найти основание по Идентификатору основания
	Если ЭтоИсходящееПисьмо Тогда
		Основание = ВстроеннаяПочтаСервер.НайтиВходящееПисьмоПоИдентификатору(
			ИдентификаторОснования);
	Иначе
			
		УчетнаяЗапись = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Письмо, "УчетнаяЗапись");
		Основание = ВстроеннаяПочтаСервер.НайтиИсходящееПисьмоПоИдентификатору(
			ИдентификаторОснования, УчетнаяЗапись);
	КонецЕсли;
	
	// Если основание не найдено, завершить
	Если Не ЗначениеЗаполнено(Основание) Тогда
		Возврат;
	КонецЕсли;
	
	// Установить связь с найденным основанием
	Если ЭтоИсходящееПисьмо Тогда
		ТипСвязиСОснованием = Справочники.ТипыСвязей.ПисьмоОтправленоВОтветНа;
	Иначе
		ТипСвязиСОснованием = Справочники.ТипыСвязей.ПолученоВОтветНаПисьмо;
	КонецЕсли;
	
	СвязиДокументов.УстановитьСвязь(
		Письмо,
		Неопределено,
		Основание,
		ТипСвязиСОснованием);	
	
	// Продолжить установку связь вверх по цепочке
	УстановитьСвязьСОснованием(Основание);
КонецПроцедуры

// Установить возможную связь письма с подчиненными письмами
// 
&НаСервере
Процедура УстановитьСвязьСОтветами(Письмо)
	
	Если Не ЗначениеЗаполнено(Письмо.ИдентификаторСообщения) Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоИсходящееПисьмо = ВстроеннаяПочтаКлиентСервер.ЭтоИсходящееПисьмо(Письмо);
	
	Если ЭтоИсходящееПисьмо Тогда
		ПодчиненныеПисьма = ВстроеннаяПочтаСервер.НайтиВходящиеПисьмаПоИдентификаторуОснования(
		Письмо.ИдентификаторСообщения);		
	Иначе
		ПодчиненныеПисьма = ВстроеннаяПочтаСервер.НайтиИсходящиеПисьмаПоИдентификаторуОснования(
		Письмо.ИдентификаторСообщения);
	КонецЕсли;
	
	Для каждого ПисьмоОтвет Из ПодчиненныеПисьма Цикл
		Если ПисьмоОтвет = Null Тогда
			Продолжить;
		КонецЕсли;
		
		// Если у письма ответа существует основание, то пропустить
		Если ЗначениеЗаполнено(ПолучитьПисьмоОснование(ПисьмоОтвет)) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЭтоИсходящееПисьмо Тогда
			ТипСвязиСОтветом = Справочники.ТипыСвязей.ПолученоОтветноеПисьмо;
		Иначе
			ТипСвязиСОтветом = Справочники.ТипыСвязей.ОтправленоОтветноеПисьмо;
		КонецЕсли;	
		
		СвязиДокументов.УстановитьСвязь(
			Письмо,
			Неопределено,
			ПисьмоОтвет,
			ТипСвязиСОтветом);
		
		УстановитьСвязьСОтветами(ПисьмоОтвет);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПисьмоОснование(Письмо)
	
	Если ВстроеннаяПочтаКлиентСервер.ЭтоИсходящееПисьмо(Письмо) Тогда
		Основание = СвязиДокументов.ПолучитьСвязанныйДокумент(
			Письмо, 
			Справочники.ТипыСвязей.ПисьмоОтправленоВОтветНа);
	Иначе		
		Основание = СвязиДокументов.ПолучитьСвязанныйДокумент(
			Письмо, 
			Справочники.ТипыСвязей.ПолученоВОтветНаПисьмо);
	КонецЕсли;
	
	Возврат Основание;

КонецФункции

&НаСервере
Функция ЗаписатьПисьмо(УчетнаяЗапись, Папка, Сообщение)
	
	НачатьТранзакцию();
	
	Попытка
		Если Сообщение.ЭтоИсходящееПисьмо Тогда
			ПисьмоОбъект = Документы.ИсходящееПисьмо.СоздатьДокумент();
		Иначе
			ПисьмоОбъект = Документы.ВходящееПисьмо.СоздатьДокумент();
		КонецЕсли;
		
		ПисьмоОбъект.УчетнаяЗапись = УчетнаяЗапись;
		ПисьмоОбъект.Папка = Папка;

		ЗаполнитьПисьмо(ПисьмоОбъект, Сообщение);

		Если ЗначениеЗаполнено(Сообщение.ИдентификаторОснования) Тогда
			Если Сообщение.ЭтоИсходящееПисьмо Тогда
				Основание = ВстроеннаяПочтаСервер.НайтиВходящееПисьмоПоИдентификатору(
					Сообщение.ИдентификаторОснования);
			Иначе
				Основание = ВстроеннаяПочтаСервер.НайтиИсходящееПисьмоПоИдентификатору(
					Сообщение.ИдентификаторОснования, УчетнаяЗапись);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Основание) Тогда
				ВстроеннаяПочтаСервер.ЗаполнитьРеквизитыПисьмаИзОснования(ПисьмоОбъект, Основание);
			КонецЕсли;
		КонецЕсли;

		ПисьмоОбъект.Записать();
		
		РегистрыСведений.ИдентификаторыИмпортированныхПисем.ДобавитьЗапись(
			ПисьмоОбъект.Ссылка, 
			Сообщение.ИдентификаторOutlook, 
			Сообщение.ИдентификаторОснования);
				
		Если ЗначениеЗаполнено(Сообщение.ИдентификаторСообщения) Тогда
			УстановитьСвязиСПисьмом(ПисьмоОбъект.Ссылка);
		КонецЕсли;
			
		//Запишем вложения.
		Для каждого Вложение Из Сообщение.Вложения Цикл
			ДвоичныеДанные = ПолучитьИзВременногоХранилища(Вложение.Адрес);
			ВстроеннаяПочтаСервер.ДобавитьВложениеПисьмаИзДвоичныхДанных(
				ПисьмоОбъект.Ссылка, // ДокументСсылка.ВходящееПисьмо, ДокументСсылка.ИсходящееПисьмо
				ДвоичныеДанные, // ДвоичныеДанные
				Вложение.ИмяФайла,
				Сообщение.ДатаПолучения, // ВремяИзменения
				Вложение.Идентификатор); // ИдентификаторПочтовогоВложения
		КонецЦикла;
				
		// Запишем идентификатор.
		Если ЗначениеЗаполнено(ПисьмоОбъект.ИдентификаторСообщения) Тогда
			РегистрыСведений.ИдентификаторыПолученныхПисем.ДобавитьЗапись(
				УчетнаяЗапись,
				ПисьмоОбъект.ИдентификаторСообщения);
		КонецЕсли;
			
		// Установка пометки о прочтении
		Если ПомечатьКакПрочитанные Тогда
			РаботаСПрочтениями.УстановитьСвойствоПрочтен(ПисьмоОбъект.Ссылка, Истина, Ложь);
		КонецЕсли;

		ЗафиксироватьТранзакцию();
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение ОписаниеОшибки();
		
	КонецПопытки;
	
	Возврат ПисьмоОбъект.Ссылка;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПисьмо(ПисьмоОбъект, Сообщение)	
	ПисьмоОбъект.Важность = Сообщение.Важность;
	ПисьмоОбъект.Дата = Сообщение.ДатаОтправки;
	ПисьмоОбъект.ДатаОтправки = Сообщение.ДатаОтправки;
		
	Если Не Сообщение.ЭтоИсходящееПисьмо Тогда
		ПисьмоОбъект.ДатаПолучения = Сообщение.ДатаПолучения;
		ПисьмоОбъект.ОтправительАдресат = Сообщение.ОтправительАдресат;
	КонецЕсли;
	
	ПисьмоОбъект.ИдентификаторСообщения = Сообщение.ИдентификаторСообщения;	
	
	ПисьмоОбъект.Размер = Сообщение.Размер;
	ПисьмоОбъект.Тема = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(Сообщение.Тема);
	
	СтруктураТекста = Новый Структура;
	СтруктураТекста.Вставить("ТипТекста", Сообщение.ТипТекста);
	СтруктураТекста.Вставить("Текст", Сообщение.Текст);
	СтруктураТекста.Вставить("ТекстHTML", Сообщение.ТекстHTML);
	СтруктураТекста.Вставить("Кодировка", "");
	
	ВстроеннаяПочтаСервер.УстановитьСодержаниеПисьмаИзСтруктурыТекстаПочтовогоСообщения(
	ПисьмоОбъект,
	СтруктураТекста);
	
	ЗаполнитьИнтернетПочтовыеАдреса(ПисьмоОбъект.ПолучателиПисьма, Сообщение.ПолучателиПисьма);
		
	Если Сообщение.ЭтоИсходящееПисьмо Тогда
		ПолучателиПисьмаСтрокой = ВстроеннаяПочтаСервер.ТаблицаПолучателейВСтроку(
			ПисьмоОбъект.ПолучателиПисьма);
		
		ПоследнийСимвол = Прав(ПолучателиПисьмаСтрокой, 1);
		Если ПоследнийСимвол = ";" Тогда
			ПолучателиПисьмаСтрокой = Лев(ПолучателиПисьмаСтрокой, СтрДлина(ПолучателиПисьмаСтрокой) - 1);
		КонецЕсли;	
		ПисьмоОбъект.ПолучателиПисьмаСтрокой = ПолучателиПисьмаСтрокой;
	КонецЕсли;
		
	ЗаполнитьИнтернетПочтовыеАдреса(ПисьмоОбъект.ПолучателиКопий, Сообщение.ПолучателиКопий);
	ЗаполнитьИнтернетПочтовыеАдреса(ПисьмоОбъект.ПолучателиОтвета, Сообщение.ПолучателиОтвета);
	
	ПисьмоОбъект.ЕстьВложения = Сообщение.ЕстьВложения;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнтернетПочтовыеАдреса(ТаблицаАдресов, Адреса)
	
	Для Каждого АдресаСтрока Из Адреса Цикл
		ТаблицаАдресовСтрока = ТаблицаАдресов.Добавить();
		ТаблицаАдресовСтрока.Адресат = АдресаСтрока.Адресат;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьВажностьПисьмаИзВажностиПисьмаMSO(ПисьмоMSO)
	
	Если ПисьмоMSO.Importance = 0 Тогда // OlImportance.olImportanceLow
		Важность = ПредопределенноеЗначение("Перечисление.ВажностьПисем.Низкая");
	ИначеЕсли ПисьмоMSO.Importance = 2 Тогда // OlImportance.olImportanceHigh
		Важность = ПредопределенноеЗначение("Перечисление.ВажностьПисем.Высокая");
	ИначеЕсли ПисьмоMSO.Importance = 1 Тогда //  OlImportance.olImportanceNormal
		Важность = ПредопределенноеЗначение("Перечисление.ВажностьПисем.Обычная");
	Иначе
		Важность = ПредопределенноеЗначение("Перечисление.ВажностьПисем.Обычная");
	КонецЕсли;
	
	Возврат Важность;
	
КонецФункции

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	МоиАдресаСписок.Очистить();
	
	Если ЗначениеЗаполнено(МоиАдреса) Тогда
		Попытка
			Результат = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(МоиАдреса);
			Для каждого Элемент Из Результат Цикл
				Если ЗначениеЗаполнено(Элемент.Адрес) Тогда
					МоиАдресаСписок.Добавить(НРег(Элемент.Адрес));
				КонецЕсли;
			КонецЦикла;
		Исключение
			СообщениеОбОшибке = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, , "МоиАдреса", , Отказ);
		КонецПопытки;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УчетнаяЗаписьПриИзменении(Элемент)
	Если ЗначениеЗаполнено(УчетнаяЗапись) Тогда		
		МоиАдреса = ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(УчетнаяЗапись, "АдресЭлектроннойПочты");
	КонецЕсли;	
КонецПроцедуры


