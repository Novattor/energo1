
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.РежимВыбора = "ИзПередачиДелВАрхив" 
	 Или Параметры.РежимВыбора = "ИзУничтоженияДел" Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ДелоЗакрыто", Истина);
		
		Состояния = Новый Массив;
		Состояния.Добавить(Перечисления.СостоянияДелХраненияДокументов.ПустаяСсылка());
		Если Параметры.РежимВыбора = "ИзУничтоженияДел" Тогда 
			Состояния.Добавить(Перечисления.СостоянияДелХраненияДокументов.ПереданоВАрхив);
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
				"КатегорияДела", 
				Перечисления.КатегорииДел.Постоянное,
				ВидСравненияКомпоновкиДанных.НеРавно);
		КонецЕсли; 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"Состояние", 
			Состояния,
			ВидСравненияКомпоновкиДанных.ВСписке); 
				
		АдресВременногоХранилища = Параметры.АдресВременногоХранилища;
		Если ЗначениеЗаполнено(АдресВременногоХранилища) Тогда 
			Выбранные.Загрузить(ПолучитьИзВременногоХранилища(АдресВременногоХранилища));
		КонецЕсли;	
		
		Список.Параметры.УстановитьЗначениеПараметра("НаДату", Параметры.СостояниеНаДату);
	КонецЕсли;	
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") И ЗначениеЗаполнено(Параметры.Организация) Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Организация", Параметры.Организация);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборДела(ВыбранноеЗначение)
	
	ПараметрыОтбора = Новый Структура("ДелоХраненияДокументов", ВыбранноеЗначение);
	Если Выбранные.НайтиСтроки(ПараметрыОтбора).Количество() > 0 Тогда
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Дело (том) ""%1"" уже выбран!'; en = 'Case (dossier) ""%1"" is already selected!'"),
			Строка(ВыбранноеЗначение));
		
		ПоказатьПредупреждение(, ТекстСообщения);
		
	Иначе
		НоваяСтрока = Выбранные.Добавить();
		НоваяСтрока.ДелоХраненияДокументов = ВыбранноеЗначение;
		
		Элементы.Выбранные.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборДела(Значение);
	
КонецПроцедуры

&НаСервере
Процедура ПоместитьДелаВоВременноеХранилище()

	ПоместитьВоВременноеХранилище(Выбранные.Выгрузить(), АдресВременногоХранилища);
	
КонецПроцедуры	

&НаКлиенте
Процедура Включить(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда 
		ВыборДела(ТекущаяСтрока);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Исключить(Команда)
	
	ТекущаяСтрока = Элементы.Выбранные.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	СтрокаПоИдентификатору = Выбранные.НайтиПоИдентификатору(ТекущаяСтрока);
	Выбранные.Удалить(СтрокаПоИдентификатору);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	ВыборДела(ПараметрыПеретаскивания.Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	ПоместитьДелаВоВременноеХранилище();
	ОповеститьОВыборе(АдресВременногоХранилища);
	
КонецПроцедуры


