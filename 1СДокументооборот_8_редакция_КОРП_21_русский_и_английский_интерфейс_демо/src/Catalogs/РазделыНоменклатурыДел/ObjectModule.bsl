
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Организация) Тогда 
		Организация = РаботаСОрганизациями.ПолучитьОрганизациюПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(Родитель) Тогда 
		
		РеквизитыРодителя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Родитель, "Год, Организация, Подразделение");
		
		Если Год <> РеквизитыРодителя.Год Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(	
				НСтр("ru = 'Год раздела не совпадает с годом вышестоящего раздела'; en = 'Yead of the section does not match to that of the higher section'"),
				ЭтотОбъект,
				"Год",,
				Отказ);
		КонецЕсли;
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям")
			И Организация <> РеквизитыРодителя.Организация Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(	
				НСтр("ru = 'Организация раздела не совпадает с организацией вышестоящего раздела'; en = 'Company specified in the section does not match that of the higher section'"),
				ЭтотОбъект,
				"Организация",,
				Отказ);
		КонецЕсли;		
	
		Если Подразделение <> РеквизитыРодителя.Подразделение Тогда  
			Если Не ЗначениеЗаполнено(Подразделение) Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Вышестоящий раздел отнесен к подразделению %1, укажите подразделение текущего раздела'; en = 'Higher section is assigned to department %1, specify the department of the current section'"), 
					РеквизитыРодителя.Подразделение);	
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					ЭтотОбъект,
					"Подразделение",,
					Отказ);
			ИначеЕсли Не Делопроизводство.ЭтоДочернееПодразделение(Подразделение, РеквизитыРодителя.Подразделение) Тогда 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(	
					НСтр("ru = 'Указанное подразделение не в подчинении подразделения вышестоящего раздела'; en = 'The specified department does not belong to the department of the parent section'"),
					ЭтотОбъект,
					"Подразделение",,
					Отказ);	
			КонецЕсли;		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
	Иначе 
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "ПометкаУдаления, Подразделение, Организация");
		ДополнительныеСвойства.Вставить("ПометкаУдаления", Реквизиты.ПометкаУдаления);
		ДополнительныеСвойства.Вставить("Подразделение", Реквизиты.Подразделение);
		ДополнительныеСвойства.Вставить("Организация", Реквизиты.Организация);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ЭтоНовый") 
		И ДополнительныеСвойства.ЭтоНовый Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ПометкаУдаления") 
		И ДополнительныеСвойства.ПометкаУдаления <> ПометкаУдаления Тогда 
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	НоменклатураДел.Ссылка
		|ИЗ
		|	Справочник.НоменклатураДел КАК НоменклатураДел
		|ГДЕ
		|	НоменклатураДел.Раздел = &Ссылка";
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			Объект.Заблокировать();
			Объект.УстановитьПометкуУдаления(Ссылка.ПометкаУдаления);
		КонецЦикла;
		
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("Подразделение") 
		И ДополнительныеСвойства.Подразделение <> Подразделение Тогда 
		
		УстановитьПривилегированныйРежим(Истина);
		
		// Меняем подразделение у дел находящихся в номенклатуре дел текущего раздела
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ДелаХраненияДокументов.Ссылка
			|ИЗ
			|	Справочник.ДелаХраненияДокументов КАК ДелаХраненияДокументов
			|ГДЕ
			|	ДелаХраненияДокументов.НоменклатураДел.Раздел = &Ссылка";
		
		Запрос.Параметры.Вставить("Ссылка", Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл 
			ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
			ДелоОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ДелоОбъект.Записать();
		КонецЦикла;
		
		// Меняем подразделение у подчиненных разделов
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|	РазделыНоменклатурыДел.Ссылка
			|ИЗ
			|	Справочник.РазделыНоменклатурыДел КАК РазделыНоменклатурыДел
			|ГДЕ
			|	НЕ РазделыНоменклатурыДел.ПометкаУдаления
			|	И РазделыНоменклатурыДел.Родитель = &Ссылка
			|	И РазделыНоменклатурыДел.Подразделение <> &Подразделение";
			
		Если ЗначениеЗаполнено(Подразделение) Тогда 
			Запрос.Текст = Запрос.Текст + "
			|	И НЕ РазделыНоменклатурыДел.Подразделение В ИЕРАРХИИ (&Подразделение)";
		КонецЕсли;	
		
		Запрос.Параметры.Вставить("Ссылка", Ссылка);
		Запрос.Параметры.Вставить("Подразделение", Подразделение);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл 
			ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
			РазделНоменклатурыДелОбъект = Выборка.Ссылка.ПолучитьОбъект();
			РазделНоменклатурыДелОбъект.Подразделение = Ссылка.Подразделение;
			РазделНоменклатурыДелОбъект.Записать();
		КонецЦикла;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("Организация") 
		И ДополнительныеСвойства.Организация <> Организация 
		И ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда 
		
		УстановитьПривилегированныйРежим(Истина);
		
		// Меняем организацию у номенклатуры дел и дел находящихся в текущем разделе
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ДелаХраненияДокументов.Ссылка
			|ИЗ
			|	Справочник.ДелаХраненияДокументов КАК ДелаХраненияДокументов
			|ГДЕ
			|	ДелаХраненияДокументов.НоменклатураДел.Раздел = &Ссылка
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	НоменклатураДел.Ссылка
			|ИЗ
			|	Справочник.НоменклатураДел КАК НоменклатураДел
			|ГДЕ
			|	НоменклатураДел.Раздел = &Ссылка";
		
		Запрос.Параметры.Вставить("Ссылка", Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл 
			ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
			ВыборкаОбъект = Выборка.Ссылка.ПолучитьОбъект();
			
			Если ТипЗнч(ВыборкаОбъект) = Тип("СправочникОбъект.НоменклатураДел") Тогда 
				ВыборкаОбъект.Организация = Организация;
			КонецЕсли;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(ВыборкаОбъект);
			РазблокироватьДанныеДляРедактирования(Выборка.Ссылка);
		КонецЦикла;
		
		// Меняем организацию у подчиненных разделов
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|	РазделыНоменклатурыДел.Ссылка
			|ИЗ
			|	Справочник.РазделыНоменклатурыДел КАК РазделыНоменклатурыДел
			|ГДЕ
			|	НЕ РазделыНоменклатурыДел.ПометкаУдаления
			|	И РазделыНоменклатурыДел.Родитель = &Ссылка
			|	И РазделыНоменклатурыДел.Организация <> &Организация";
			
		
		Запрос.Параметры.Вставить("Ссылка", Ссылка);
		Запрос.Параметры.Вставить("Организация", Организация);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл 
			ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
			РазделНоменклатурыДелОбъект = Выборка.Ссылка.ПолучитьОбъект();
			РазделНоменклатурыДелОбъект.Организация = Организация;
			РазделНоменклатурыДелОбъект.Записать();
			РазблокироватьДанныеДляРедактирования(Выборка.Ссылка);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры




