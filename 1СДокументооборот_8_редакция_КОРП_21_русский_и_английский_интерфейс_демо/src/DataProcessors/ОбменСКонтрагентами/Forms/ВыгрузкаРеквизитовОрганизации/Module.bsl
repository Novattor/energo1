
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Организация = Параметры.Организация;
	СтруктураДанных = ИнициализироватьРеквизиты();
	ОбменСКонтрагентамиПереопределяемый.ПолучитьРеквизитыОрганизацииДляВыгрузкиВФайл(Организация, СтруктураДанных);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураДанных);
	
	ТаблБанковскиеСчета = ОбменСКонтрагентамиПереопределяемый.ПолучитьБанковскиеСчета(Организация);
	БанковскиеСчета.Загрузить(ТаблБанковскиеСчета);
	
	Если СпособВыгрузки = Перечисления.СпособыОбменаЭД.ЧерезЭлектроннуюПочту Тогда
		АдресВыгрузки = ПолучитьУчетнуюЗапись();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ЗначениеЗаполнено(СпособВыгрузки) Тогда
		СпособВыгрузки = ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезКаталог");
	КонецЕсли;
	
	Если СпособВыгрузки = ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезЭлектроннуюПочту")
		И НЕ ЗначениеЗаполнено(АдресВыгрузки) Тогда
		АдресВыгрузки = ПолучитьУчетнуюЗапись();
	КонецЕсли;
		
	ОбновитьФорму();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособВыгрузкиПриИзменении(Элемент)
	
	АдресВыгрузки = "";
	Если СпособВыгрузки = ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезЭлектроннуюПочту") Тогда
		АдресВыгрузки = ПолучитьУчетнуюЗапись();
	КонецЕсли;
	ОбновитьФорму();
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура УчетнаяЗаписьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	АдресВыгрузки = ПредопределенноеЗначение("Справочник.УчетныеЗаписиЭлектроннойПочты.ПустаяСсылка");
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскиеСчетаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "БанковскийСчет" Тогда
		ПоказатьЗначение(, Элемент.ТекущиеДанные.БанковскийСчет);
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскиеСчетаВыбранПриИзменении(Элемент)
	
	Если Элементы.БанковскиеСчета.ТекущиеДанные.Выбран Тогда
		НомерСтроки = 0;
		ТекущийНомер = Элементы.БанковскиеСчета.ТекущаяСтрока + 1;
		Для Каждого Строка Из БанковскиеСчета Цикл
			НомерСтроки = НомерСтроки + 1;
			Если НомерСтроки <> ТекущийНомер Тогда
				Строка.Выбран = Ложь;
			КонецЕсли;
		КонецЦикла
	КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыгрузитьРеквизиты(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если СпособВыгрузки = ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезЭлектроннуюПочту") Тогда
		Если НЕ ЗначениеЗаполнено(АдресВыгрузки) Тогда
			ТекстСообщения = НСтр("ru = 'Не выбрана учетная запись электронной почты.'; en = 'Email account is not selected.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	АдресХранилища = Неопределено;
	ВыгрузитьРеквизитыОрганизации(АдресХранилища, УникальныйИдентификатор);
	Если АдресХранилища = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СпособВыгрузки = ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезКаталог") Тогда
		
		ИмяФайлаПоУмолчанию = Наименование;
		ИмяФайлаПоУмолчанию = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайлаПоУмолчанию, "");
		
		ПолучитьФайл(АдресХранилища, ИмяФайлаПоУмолчанию + ".xml");

	ИначеЕсли СпособВыгрузки = ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезЭлектроннуюПочту") Тогда
		ИмяФайлаДанных = Наименование + ".xml";
		ИмяФайлаДанных = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайлаДанных, "");
	
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Тема", "Реквизиты " + Наименование);
		ПараметрыФормы.Вставить("УчетнаяЗапись", АдресВыгрузки);
		ИмяФайла = ИмяФайлаДанных;
		Пока Истина Цикл
			Поз = Макс(Найти(ИмяФайла, "\"), СтрНайти(ИмяФайла, "/"));
			Если Поз = 0 Тогда
				Прервать;
			КонецЕсли;
			ИмяФайла = Сред(ИмяФайла, Поз + 1);
		КонецЦикла;
		Вложения = Новый СписокЗначений;
		НовыйЭлемент = Вложения.Добавить(АдресХранилища, ИмяФайла);
		ПараметрыФормы.Вставить("Вложения", Вложения);
		Форма = ОткрытьФорму("ОбщаяФорма.ОтправкаСообщения", ПараметрыФормы);
	КонецЕсли;
	
	Закрыть();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВыгрузитьРеквизитыОрганизации(АдресХранилища, УникальныйИдентификатор)
	
	ТекстОшибки = "";
	
	Попытка
		
		КонтрагентXDTO = ОбменСКонтрагентамиВнутренний.ПолучитьОбъектТипаCML("Контрагент", "4.02");
		ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(КонтрагентXDTO, "ИД", ИНН + "_" + КПП, Истина, ТекстОшибки);
		ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(КонтрагентXDTO, "Наименование", Наименование, Истина, ТекстОшибки);
		
		Если НЕ ОбменСКонтрагентамиПереопределяемый.ЭтоФизЛицо(Организация) Тогда
			РеквизитыКонтрагентаXDTO = ОбменСКонтрагентамиВнутренний.ПолучитьОбъектТипаCML("РеквизитыЮрЛица", "4.02");
			ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(
				РеквизитыКонтрагентаXDTO, "ОфициальноеНаименование", НаименованиеПолное, Истина, ТекстОшибки);
			ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(РеквизитыКонтрагентаXDTO, "КПП", КПП, , ТекстОшибки);
			
			Если ЗначениеЗаполнено(Руководитель) Тогда
				РуководительXDTO = ОбменСКонтрагентамиВнутренний.ПолучитьОбъектТипаCML("Контрагент", "4.02");
				ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(РуководительXDTO, "ИД", Руководитель, Истина, ТекстОшибки);
				ФизЛицоРуководительXDTO = ОбменСКонтрагентамиВнутренний.ПолучитьОбъектТипаCML("Контрагент.ФизЛицо", "4.02");
				ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(
					ФизЛицоРуководительXDTO, "ПолноеНаименование", Руководитель, Истина, ТекстОшибки);
				ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(
					ФизЛицоРуководительXDTO, "Должность", ДолжностьРуководителя, Истина, ТекстОшибки);
				ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(
					РуководительXDTO, "ФизЛицо", ФизЛицоРуководительXDTO, Истина, ТекстОшибки);
				ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(
					РеквизитыКонтрагентаXDTO, "Руководитель", РуководительXDTO, Истина, ТекстОшибки);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ЮридическийАдрес) Тогда
				АдресXDTO = ОбменСКонтрагентамиВнутренний.ПолучитьОбъектТипаCML("Адрес", "4.02");
				ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(АдресXDTO, "Представление", ЮридическийАдрес, Истина, ТекстОшибки);
				Если ЗначениеЗаполнено(ЗначенияПолейЮридическийАдрес) Тогда
					РазобратьАдрес(АдресXDTO, ЗначенияПолейЮридическийАдрес, ТекстОшибки);
				КонецЕсли;
				ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(РеквизитыКонтрагентаXDTO, "ЮридическийАдрес", АдресXDTO, Истина, ТекстОшибки);
			КонецЕсли;
			
			ИмяСвойства = "ЮрЛицо";
		Иначе
			РеквизитыКонтрагентаXDTO = ОбменСКонтрагентамиВнутренний.ПолучитьОбъектТипаCML("РеквизитыФизЛица", "4.02");
			ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(РеквизитыКонтрагентаXDTO, "ПолноеНаименование", НаименованиеПолное, Истина, ТекстОшибки);
			
			Если ЗначениеЗаполнено(ЮридическийАдрес) Тогда
				АдресXDTO = ОбменСКонтрагентамиВнутренний.ПолучитьОбъектТипаCML("Адрес", "4.02");
				ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(АдресXDTO, "Представление", ЮридическийАдрес, Истина, ТекстОшибки);
				Если ЗначениеЗаполнено(ЗначенияПолейЮридическийАдрес) Тогда
					РазобратьАдрес(АдресXDTO, ЗначенияПолейЮридическийАдрес, ТекстОшибки);
				КонецЕсли;
				ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(РеквизитыКонтрагентаXDTO, "АдресРегистрации", АдресXDTO, Истина, ТекстОшибки);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СвидетельствоДата) И ЗначениеЗаполнено(СвидетельствоНомер) Тогда
				СвидетельствоXDTO = ОбменСКонтрагентамиВнутренний.ПолучитьОбъектТипаCML("РеквизитыФизЛица.Свидетельство", "4.02");
				ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(
					СвидетельствоXDTO, "Номер", СвидетельствоНомер, Истина, ТекстОшибки);
				ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(
					СвидетельствоXDTO, "ДатаВыдачи", СвидетельствоДата, Истина, ТекстОшибки);
				ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(
					РеквизитыКонтрагентаXDTO, "Свидетельство", СвидетельствоXDTO, Истина, ТекстОшибки);
			КонецЕсли;
			ИмяСвойства = "ФизЛицо";
		КонецЕсли;
		
		ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(РеквизитыКонтрагентаXDTO, "ИНН", ИНН, Истина, ТекстОшибки);
		ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(РеквизитыКонтрагентаXDTO, "ОКПО", ОКПО, , ТекстОшибки);
		
		Если ЗначениеЗаполнено(ФактическийАдрес) Тогда
			АдресXDTO = ОбменСКонтрагентамиВнутренний.ПолучитьОбъектТипаCML("Адрес", "4.02");
			ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(АдресXDTO, "Представление", ФактическийАдрес, Истина, ТекстОшибки);
			Если ЗначениеЗаполнено(ЗначенияПолейФактАдрес) Тогда
				РазобратьАдрес(АдресXDTO, ЗначенияПолейФактАдрес, ТекстОшибки);
			КонецЕсли;
			ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(КонтрагентXDTO, "Адрес", АдресXDTO, Истина, ТекстОшибки);
		КонецЕсли;
		
		ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(КонтрагентXDTO, ИмяСвойства, РеквизитыКонтрагентаXDTO, Истина, ТекстОшибки);
		
		ТЗБанковскиеСчета = БанковскиеСчета.Выгрузить(Новый Структура("Выбран", Истина));
		БанковскиеРеквизиты = ОбменСКонтрагентамиПереопределяемый.ПолучитьБанковскиеРеквизиты(
			ТЗБанковскиеСчета.ВыгрузитьКолонку("БанковскийСчет"));
		
		Если БанковскиеРеквизиты.Количество() > 0 Тогда
			
			РасчетныеСчетаXDTO = ОбменСКонтрагентамиВнутренний.ПолучитьОбъектТипаCML("Контрагент.РасчетныеСчета", "4.02");
			
			Для Каждого Счет Из БанковскиеРеквизиты Цикл
				РасчетныйСчетXDTO = ОбменСКонтрагентамиВнутренний.ПолучитьОбъектТипаCML("РасчетныйСчет", "4.02");
				ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(
					РасчетныйСчетXDTO, "НомерСчета", Счет.РасчетныйСчет, Истина, ТекстОшибки);
				БанкXDTO = ОбменСКонтрагентамиВнутренний.ПолучитьОбъектТипаCML("Банк", "4.02");
				ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(БанкXDTO, "БИК", Счет.БИК, Истина, ТекстОшибки);
				ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(
					БанкXDTO, "СчетКорреспондентский", Счет.КорреспондентскийСчет, Истина, ТекстОшибки);
				ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(БанкXDTO, "Наименование", Счет.Банк, Истина, ТекстОшибки);
				ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(РасчетныйСчетXDTO, "Банк",БанкXDTO, Истина, ТекстОшибки);
				
				Если ЗначениеЗаполнено(Счет.БанкДляРасчетов) Тогда
					БанкXDTO = ОбменСКонтрагентамиВнутренний.ПолучитьОбъектТипаCML("Банк", "4.02");
					ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(БанкXDTO, "БИК", Счет.БанкДляРасчетовБИК, Истина, ТекстОшибки);
					ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(
						БанкXDTO, "СчетКорреспондентский", Счет.БанкДляРасчетовКоррСчет, Истина, ТекстОшибки);
					ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(
						БанкXDTO, "Наименование", Счет.БанкДляРасчетов, Истина, ТекстОшибки);
					ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(
						РасчетныйСчетXDTO, "БанкКорреспондент", БанкXDTO, Истина, ТекстОшибки);
				КонецЕсли;
					
				РасчетныеСчетаXDTO.РасчетныйСчет.Добавить(РасчетныйСчетXDTO);
			КонецЦикла;
			
			ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(
				КонтрагентXDTO, "РасчетныеСчета", РасчетныеСчетаXDTO, Истина, ТекстОшибки);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Телефон) Тогда
			КонтактнаяИнформацияXDTO = ОбменСКонтрагентамиВнутренний.ПолучитьОбъектТипаCML("КонтактнаяИнформация", "4.02");
			ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(
				КонтактнаяИнформацияXDTO, "Тип", НСтр("ru = 'Телефон рабочий'; en = 'Business phone'"), Истина, ТекстОшибки);
			ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(КонтактнаяИнформацияXDTO, "Значение", Телефон, Истина, ТекстОшибки);
			
			КонтактыXDTO = ОбменСКонтрагентамиВнутренний.ПолучитьОбъектТипаCML("Контрагент.Контакты", "4.02");
			КонтактыXDTO.Контакт.Добавить(КонтактнаяИнформацияXDTO);
			ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(КонтрагентXDTO, "Контакты", КонтактыXDTO, Истина, ТекстОшибки);
		КонецЕсли;
		
		КонтрагентXDTO.Проверить();
		
		Если ТекстОшибки = "" Тогда
			ИмяФайла = ОбменСКонтрагентамиСлужебный.ТекущееИмяВременногоФайла("xml");
			НоваяЗаписьXML = Новый ЗаписьXML;
			НоваяЗаписьXML.ОткрытьФайл(ИмяФайла, "UTF-8");
			НоваяЗаписьXML.ЗаписатьОбъявлениеXML();
			ФабрикаXDTO.ЗаписатьXML(НоваяЗаписьXML, КонтрагентXDTO, , , , НазначениеТипаXML.Явное);
			НоваяЗаписьXML.Закрыть();
			ДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайла);
			ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ИмяФайла);
			
			АдресХранилища = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
		Иначе
			ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(НСтр("ru = 'Формирование ЭД'; en = 'Generating ED'"),
																						ТекстОшибки,
																						ТекстОшибки);
		КонецЕсли;
		
	Исключение
		ТекстСообщения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(НСтр("ru = 'Формирование ЭД'; en = 'Generating ED'"),
																					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
																					ТекстСообщения);
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура РазобратьАдрес(ОбъектXDTO, Значение, ТекстОшибки)

	Значение = СтрЗаменить(Значение, "Индекс", НСтр("ru = 'Почтовый индекс'; en = 'Zip code'"));
	Значение = СтрЗаменить(Значение, "НаселенныйПункт", НСтр("ru = 'Населенный пункт'; en = 'Settlement'"));
	ДопустимыеТипы = "Почтовый индекс, Страна, Регион, Район, Населенный пункт, Город, Улица, Дом, Корпус, Квартира";
	
	Для Индекс=1 По СтрЧислоСтрок(Значение) Цикл
		ТекСтрока = СтрПолучитьСтроку(Значение, Индекс);
		Тип = Сред(ТекСтрока, 1, СтрНайти(ТекСтрока, "=") - 1);
		Если СтрНайти(ДопустимыеТипы, Тип) > 0 Тогда
			АдресноеПоле = ОбменСКонтрагентамиВнутренний.ПолучитьОбъектТипаCML("Адрес.АдресноеПоле", "4.02");
			ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(АдресноеПоле, "Тип", Тип, Истина, ТекстОшибки);
			ОбменСКонтрагентамиВнутренний.ЗаполнитьСвойствоXDTO(АдресноеПоле, "Значение", Сред(ТекСтрока,Найти(ТекСтрока, "=") + 1), Истина, ТекстОшибки);
			ОбъектXDTO.АдресноеПоле.Добавить(АдресноеПоле);
		КонецЕсли;
	КонецЦикла
	
КонецПроцедуры

&НаСервере
Функция ПолучитьУчетнуюЗапись()
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УчетныеЗаписиЭлектроннойПочты.Ссылка
	|ИЗ
	|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	|ГДЕ
	|	УчетныеЗаписиЭлектроннойПочты.ПометкаУдаления = ЛОЖЬ
	|	И УчетныеЗаписиЭлектроннойПочты.ИспользоватьДляОтправки = ИСТИНА";
		
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Количество() = 1 Тогда
		Результат.Следующий();
		Возврат Результат.Ссылка;
	КонецЕсли;
	
	Возврат Справочники.УчетныеЗаписиЭлектроннойПочты.ПустаяСсылка();

КонецФункции

&НаСервере
Функция ИнициализироватьРеквизиты()
	
	СтруктураВозврата = Новый Структура();
	СтруктураВозврата.Вставить("Наименование");
	СтруктураВозврата.Вставить("НаименованиеПолное");
	СтруктураВозврата.Вставить("ИНН");
	СтруктураВозврата.Вставить("КПП");
	СтруктураВозврата.Вставить("ОКПО");
	СтруктураВозврата.Вставить("ДолжностьРуководителя");
	СтруктураВозврата.Вставить("Руководитель");
	СтруктураВозврата.Вставить("ЮрФизЛицо");
	СтруктураВозврата.Вставить("СвидетельствоДата");
	СтруктураВозврата.Вставить("СвидетельствоНомер");
	СтруктураВозврата.Вставить("ЮридическийАдрес");
	СтруктураВозврата.Вставить("ЗначенияПолейЮрАдрес");
	СтруктураВозврата.Вставить("ФактическийАдрес");
	СтруктураВозврата.Вставить("ЗначенияПолейФактАдрес");
	СтруктураВозврата.Вставить("Телефон");
	
	Возврат СтруктураВозврата;

КонецФункции

&НаКлиенте
Процедура ОбновитьФорму()
	
	Если СпособВыгрузки = ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезЭлектроннуюПочту") Тогда
		Элементы.СтраницыПолучателей.ТекущаяСтраница = Элементы.СтраницаПисьмо;
	ИначеЕсли СпособВыгрузки = ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезКаталог") Тогда
		Элементы.СтраницыПолучателей.ТекущаяСтраница = Элементы.СтраницаКаталог;
	КонецЕсли;
	Если ТипУчастника = ИндивидуальныйПредприниматель Тогда
		Элементы.ГруппаРуководитель.Видимость = Ложь;
		Элементы.КПП.Видимость = Ложь;
		
		НадписьСвидетельство = НСтр("ru ='Свидетельство №%1 от %2'; en = 'Certificate №%1 of %2'");
		НадписьСвидетельство = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НадписьСвидетельство,
			СвидетельствоНомер, Формат(СвидетельствоДата, "ДЛФ=D"));
	Иначе
		Элементы.Свидетельство.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	ИндивидуальныйПредприниматель = ОбменСКонтрагентамиПовтИсп.НайтиПеречисление("ЮрФизЛицо", "ИндивидуальныйПредприниматель");
	
	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ГруппаРуководитель.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЮрФизЛицо");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = ИндивидуальныйПредприниматель;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

КонецПроцедуры

#КонецОбласти
