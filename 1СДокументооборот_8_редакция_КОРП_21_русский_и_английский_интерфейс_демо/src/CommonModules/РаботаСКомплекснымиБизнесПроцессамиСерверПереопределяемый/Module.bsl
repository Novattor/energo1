Процедура ЗаполнитьПоШаблону(ПроцессОбъект, ШаблонБизнесПроцесса) Экспорт
	
	// трудозатраты
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда 
		ПроцессОбъект.ТрудозатратыПланКонтролера = ШаблонБизнесПроцесса.ТрудозатратыПланКонтролера;
	КонецЕсли;
	
	РаботаСБизнесПроцессамиВызовСервера.СкопироватьЗначенияДопРеквизитов(ШаблонБизнесПроцесса, ПроцессОбъект);
	
КонецПроцедуры

Процедура ИзменениеРеквизитовНевыполненныхЗадач(ПараметрыЗаписи, ПроцессОбъект, ЗадачаОбъект) Экспорт
	
	ЗадачаОбъект.Проект = ПроцессОбъект.Проект;
	ЗадачаОбъект.ПроектнаяЗадача = ПроцессОбъект.ПроектнаяЗадача;
	
	РаботаСБизнесПроцессамиВызовСервера.СкопироватьЗначенияДопРеквизитов(ПроцессОбъект, ЗадачаОбъект);
	
КонецПроцедуры

Процедура ЗаполнениеПроцессаПоЗадаче(ПроцессОбъект, ЗадачаСсылка) Экспорт
	
	РаботаСБизнесПроцессамиВызовСервера.СкопироватьЗначенияДопРеквизитов(ЗадачаСсылка, ПроцессОбъект);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ПроцессОбъект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	Если ПроцессОбъект.ЭтоНовый() Тогда 
		Если Не ЗначениеЗаполнено(ПроцессОбъект.Проект) Тогда 
			ПроцессОбъект.Проект = РаботаСПроектами.ПолучитьПроектПоУмолчанию();
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
			
		Если ДанныеЗаполнения.Свойство("Проект") Тогда
			ПроцессОбъект.Проект = ДанныеЗаполнения.Проект;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("АвторСобытия") Тогда
			ПроцессОбъект.Автор = ДанныеЗаполнения.АвторСобытия;
		КонецЕсли;
		
		ТипыПисем = МультипредметностьПереопределяемый.ПолучитьТипыПисем();
		ОсновныеПисьма = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(ПроцессОбъект, ТипыПисем, Истина);
		Для Каждого Письмо Из ОсновныеПисьма Цикл
			Тема = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Письмо, "Тема");
			ПроцессОбъект.Проект = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Письмо, "Проект");
			Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Обработать ""%1""'; en = 'Process ""%1""'"),
				Тема);
			Прервать;
		КонецЦикла;
			
	КонецЕсли;
	
	Если ДанныеЗаполнения <> Неопределено И ДанныеЗаполнения.Свойство("Предметы") Тогда
		СсылкаНаПроект = МультипредметностьПереопределяемый.ПолучитьОсновнойПроектПоПредметам(ДанныеЗаполнения.Предметы);
		Если ЗначениеЗаполнено(СсылкаНаПроект) Тогда
			ПроцессОбъект.Проект = СсылкаНаПроект;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура КонтролерПередСозданиемЗадач(ПроцессОбъект, Задача) Экспорт
	
	Задача.Проект = ПроцессОбъект.Проект;
	Задача.ПроектнаяЗадача = ПроцессОбъект.ПроектнаяЗадача;

	РаботаСБизнесПроцессамиВызовСервера.СкопироватьЗначенияДопРеквизитов(Задача.БизнесПроцесс, Задача);
	
КонецПроцедуры

Процедура ПередЗаписью(ПроцессОбъект) Экспорт
	
	// Обработка рабочей группы	
	РаботаСБизнесПроцессамиВызовСервера.СформироватьРабочуюГруппу(ПроцессОбъект);
	
КонецПроцедуры

Процедура СоздатьПроцессПоДействиюЗаполнениеВедущейЗадачи(КомплексныйПроцессОбъект, ВедущаяЗадачаОбъект) Экспорт
	
	ВедущаяЗадачаОбъект.Проект = КомплексныйПроцессОбъект.Проект;
	ВедущаяЗадачаОбъект.ПроектнаяЗадача = КомплексныйПроцессОбъект.ПроектнаяЗадача;
	
КонецПроцедуры

Процедура СоздатьПроцессПоДействиюДоЗаписиПроцесса(КомплексныйПроцессОбъект, СозданныйПроцессОбъект) Экспорт
	
	СозданныйПроцессОбъект.Проект = КомплексныйПроцессОбъект.Проект;
	СозданныйПроцессОбъект.ПроектнаяЗадача = КомплексныйПроцессОбъект.ПроектнаяЗадача;
	РаботаСБизнесПроцессамиВызовСервера.СкопироватьЗначенияДопРеквизитов(КомплексныйПроцессОбъект, СозданныйПроцессОбъект);
	
КонецПроцедуры

Процедура СоздатьПроцессПоДействиюПослеЗаписиПроцесса(КомплексныйПроцессОбъект, СозданныйПроцессОбъект) Экспорт
	
	// Копирование рабочей группы
	РаботаСРабочимиГруппами.ДобавитьУчастниковВРабочуюГруппуДокументаИзИсточника(
		СозданныйПроцессОбъект.Ссылка, 
		КомплексныйПроцессОбъект.Ссылка, 
		Истина);
	
	ТаблицаУчастников = РаботаСРабочимиГруппами.ПолучитьРабочуюГруппуДокумента(СозданныйПроцессОбъект.Ссылка);
	КоличествоУчастниковБыло = ТаблицаУчастников.Количество();
	РаботаСРабочимиГруппами.ДобавитьУчастниковИзИсточника(ТаблицаУчастников, КомплексныйПроцессОбъект.Ссылка);
	РаботаСРабочимиГруппами.ПерезаписатьРабочуюГруппуОбъекта(СозданныйПроцессОбъект.Ссылка, ТаблицаУчастников, Ложь);
	
КонецПроцедуры


