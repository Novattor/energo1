
////////////////////////////////////////////////////////////////////////////////
// Обзор процессов клиент: содержит клиентские процедуры и функции по формированию
//                                HTML-обзора процессов и их шаблонов.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработчик нажатия поля ПредставлениеHTML
//
Процедура ПредставлениеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка, Форма) Экспорт
	
	Если ОбзорПроцессовКлиентПереопределяемый.ПредставлениеHTMLПриНажатии(
		Элемент, ДанныеСобытия, СтандартнаяОбработка, Форма) Тогда
		
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	Если Не ЗначениеЗаполнено(ДанныеСобытия.Href) Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Лев(ДанныеСобытия.Href, 6) = "v8doc:" Тогда 
		
		НавигационнаяСсылкаПоля = Сред(ДанныеСобытия.Href, 7);
		
		Если СтрокаНачинаетсяСПодстроки(НавигационнаяСсылкаПоля, "processnum") Тогда
			
			ПараметрыФормы = Новый Структура("ЗначениеОтбора", Форма.ТекущийШаблон);
			ОткрытьФорму("КритерийОтбора.БизнесПроцессыПоШаблону.ФормаСписка", ПараметрыФормы);
			
		Иначе
			
			ПерейтиПоНавигационнойСсылке(НавигационнаяСсылкаПоля);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Проверяет, содержит ли ссылка схему
Функция СтрокаНачинаетсяСПодстроки(Строка, Подстрока)
	
	Если Найти(НРег(СокрЛ(Строка)), НРег(Подстрока)) = 1 Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Обработчик нажатия поля ПредставлениеHTML
//
Процедура ПредставлениеПроцессаHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка, Форма) Экспорт
	
	Если ОбзорПроцессовКлиентПереопределяемый.ПредставлениеПроцессаHTMLПриНажатии(
		Элемент, ДанныеСобытия, СтандартнаяОбработка, Форма) Тогда
		
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	Если Не ЗначениеЗаполнено(ДанныеСобытия.Href) Тогда 
		Возврат;
	КонецЕсли;	
	
	ДлинаСтрокиHref = СтрДлина(ДанныеСобытия.Href);
	
	СтрСсылка = Прав(ДанныеСобытия.Href, ДлинаСтрокиHref-6);
	
	Если Лев(СтрСсылка, 9) = "Подзадачи" Тогда
		СтрСсылка = СтрЗаменить(СтрСсылка, "Подзадачи_", "");
		УникальныйИдентификаторПроцесса = Лев(СтрСсылка, 36);
		НаименованиеПроцесса = СтрЗаменить(СтрСсылка, УникальныйИдентификаторПроцесса + "_", "");
		
		СсылкаНаПроцесс = ОбзорПроцессовВызовСервера.СсылкаНаПроцессПоУникальномуИдентификатору(
			Новый УникальныйИдентификатор(УникальныйИдентификаторПроцесса),
			НаименованиеПроцесса);
		
		ОткрытьФорму("ОбщаяФорма.ПроцессыИЗадачи",
			Новый Структура("Предмет", СсылкаНаПроцесс));
			
	ИначеЕсли Лев(СтрСсылка, 9) = "Подзадача" Тогда
			
		СтрСсылка = СтрЗаменить(СтрСсылка, "Подзадача_", "");
		УникальныйИдентификаторЗадача = Лев(СтрСсылка, 36);
		
		ПараметрыЗадачи = ОбзорПроцессовВызовСервера.ПараметрыЗадачиПоУникальномуИдентификатору(
			Новый УникальныйИдентификатор(УникальныйИдентификаторЗадача));
			
		СписокЗначений = Новый СписокЗначений;
		
		СписокЗначений.Добавить("НаписатьПисьмо", НСтр("ru='Написать письмо'; en = 'Create email'"),, 
			БиблиотекаКартинок.ЭлектронноеПисьмо);
		СписокЗначений.Добавить("ЗадатьВопрос", НСтр("ru='Задать вопрос'; en = 'Raise issue'"),, 
			БиблиотекаКартинок.ВопросАвтору);
		СписокЗначений.Добавить("ОткрытьЗадачу", НСтр("ru='Открыть задачу'; en = 'Open task'"),, 
			БиблиотекаКартинок.Задача);
		СписокЗначений.Добавить("ПосмотретьПользователя", НСтр("ru='Посмотреть пользователя'; en = 'Show user'"),, 
			БиблиотекаКартинок.Пользователь);
			
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"КомандаПодзадачаВыбораЗначенияПродолжение",
			ЭтотОбъект,
			ПараметрыЗадачи);
		
		Форма.ПоказатьВыборИзМеню(ОписаниеОповещения, СписокЗначений);
			
	ИначеЕсли Найти(ДанныеСобытия.Href, "ПоказатьПерепискуПоДокументу") Тогда		
		
		ОбзорЗадачКлиент.ОткрытьПереписку(ДанныеСобытия.Href);
		
	ИначеЕсли Лев(ДанныеСобытия.Href, 6) = "v8doc:" Тогда 
		
		НавигационнаяСсылкаПоля = Сред(ДанныеСобытия.Href, 7);
		
		ПерейтиПоНавигационнойСсылке(НавигационнаяСсылкаПоля);
		
	ИначеЕсли Найти(ДанныеСобытия.Href, "ОткрытьКарточкуКонтроля") Тогда
		
		КонтрольКлиент.ОбработкаКомандыКонтроль(Форма.ТекущийПроцесс, Форма);
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик команды с подменю - продолжение
Процедура КомандаПодзадачаВыбораЗначенияПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Или ТипЗнч(Результат) <> Тип("ЭлементСпискаЗначений") Тогда
		Возврат;
	КонецЕсли;	
	
	Если Результат.Значение = "НаписатьПисьмо" Тогда
		
		АдресПочты = Параметры.Адрес;
		РаботаСПочтовымиСообщениямиКлиент.ОткрытьФормуОтправкиПочтовогоСообщения(, АдресПочты);
		
		Возврат;
		
	ИначеЕсли Результат.Значение = "ЗадатьВопрос" Тогда
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Задача", Параметры.Задача);
		ЗначенияЗаполнения.Вставить("Кому", Параметры.Исполнитель);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		ОткрытьФорму("БизнесПроцесс.РешениеВопросовВыполненияЗадач.ФормаОбъекта", ПараметрыФормы);
		
		Возврат;
	ИначеЕсли Результат.Значение = "ОткрытьЗадачу" Тогда
		ПоказатьЗначение(, Параметры.Задача);
		Возврат;
	ИначеЕсли Результат.Значение = "ПосмотретьПользователя" Тогда
		ПоказатьЗначение(, Параметры.Исполнитель);
		Возврат;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти
