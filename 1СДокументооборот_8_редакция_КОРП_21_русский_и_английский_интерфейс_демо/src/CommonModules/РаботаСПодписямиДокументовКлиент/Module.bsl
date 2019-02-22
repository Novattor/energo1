Процедура СтороныКонтактноеЛицоНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка, ЭлементСтороныКонтактноеЛицо) Экспорт

	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Форма.Элементы.Стороны.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Сторона)
		И РаботаСПодписямиДокументовКлиентСервер.ЭтоКонтрагент(ТекущиеДанные.Сторона) Тогда
		
			Отбор = Новый Структура;
			Отбор.Вставить("Владелец", ТекущиеДанные.Сторона);
			Отбор.Вставить("ПометкаУдаления", Ложь);
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Отбор", Отбор);
			ПараметрыФормы.Вставить("ТекущаяСтрока", ТекущиеДанные.КонтактноеЛицо);
			
			ОткрытьФорму("Справочник.КонтактныеЛица.ФормаВыбора", ПараметрыФормы, Элемент,,,,,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
	Иначе
	
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимРаботыФормы", 1);
		ПараметрыФормы.Вставить("УпрощенныйИнтерфейс", Истина);
		Если РаботаСПодписямиДокументовКлиентСервер.ЭтоОрганизация(ТекущиеДанные.Сторона) Тогда
			ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
		Иначе
			ПараметрыФормы.Вставить("ОтображатьКонтрагентов", Истина);
		КонецЕсли;
		ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Выбор контактного лица стороны'; en = 'Select contact of the side'"));
		
		Если ЗначениеЗаполнено(ТекущиеДанные.КонтактноеЛицо) Тогда
			ПараметрыФормы.Вставить("ВыбранныеАдресаты", ТекущиеДанные.КонтактноеЛицо);
		ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.Сторона) Тогда
			ПараметрыФормы.Вставить("ВыбранныеАдресаты", ТекущиеДанные.Сторона);
		КонецЕсли;
		
		ОткрытьФорму("Справочник.АдреснаяКнига.Форма.ФормаСписка",
			ПараметрыФормы,
			ЭлементСтороныКонтактноеЛицо,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
		
КонецПроцедуры

Процедура СтороныПодписалНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка, ЭлементСтороныПодписал, ИмяРеквизита = "Подписал") Экспорт

	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Форма.Элементы.Стороны.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Сторона)
		И РаботаСПодписямиДокументовКлиентСервер.ЭтоКонтрагент(ТекущиеДанные.Сторона) Тогда
		
			Отбор = Новый Структура;
			Отбор.Вставить("Владелец", ТекущиеДанные.Сторона);
			Отбор.Вставить("ПометкаУдаления", Ложь);
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Отбор", Отбор);
			ПараметрыФормы.Вставить("ТекущаяСтрока", ТекущиеДанные.КонтактноеЛицо);
			
			ОткрытьФорму("Справочник.КонтактныеЛица.ФормаВыбора", ПараметрыФормы, Элемент,,,,,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
				
	Иначе
				
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимРаботыФормы", 1);
		ПараметрыФормы.Вставить("УпрощенныйИнтерфейс", Истина);
		Если РаботаСПодписямиДокументовКлиентСервер.ЭтоОрганизация(ТекущиеДанные.Сторона) Тогда
			ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
		Иначе
			ПараметрыФормы.Вставить("ОтображатьКонтрагентов", Истина);
		КонецЕсли;
		ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Выбор подписанта стороны'; en = 'Select the signatory of the party'"));
		
		Если ЗначениеЗаполнено(ТекущиеДанные[ИмяРеквизита]) Тогда
			ПараметрыФормы.Вставить("ВыбранныеАдресаты", ТекущиеДанные[ИмяРеквизита]);
		ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.Сторона) Тогда
			ПараметрыФормы.Вставить("ВыбранныеАдресаты", ТекущиеДанные.Сторона);
		КонецЕсли;
		
		ОткрытьФорму("Справочник.АдреснаяКнига.Форма.ФормаСписка",
			ПараметрыФормы,
			ЭлементСтороныПодписал,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
	КонецЕсли;

КонецПроцедуры

Процедура СтороныПриАктивизацииЯчейки(Форма, Элементы, ТекущиеДанные) Экспорт

	Если Форма.ЭтоПолноправныйПользователь Тогда
		Возврат;
	КонецЕсли;
	
	// доступность по запрету
	МассивПолей = Новый Массив;
	МассивПолей.Добавить("Сторона");
	МассивПолей.Добавить("Наименование");
	МассивПолей.Добавить("КонтактноеЛицо");
	МассивПолей.Добавить("Подписал");
	
	Для Каждого Поле Из МассивПолей Цикл
		Элементы["Стороны"+Поле].ТолькоПросмотр = ЗапрещеноРедактироватьПолеСтороныПоШаблону(Форма.СтороныШаблона, ТекущиеДанные, Поле);
		
	КонецЦикла;
	
	// доступность ранее установленной подписи
	МассивПолей = Новый Массив;
	МассивПолей.Добавить("Подписан");
	МассивПолей.Добавить("ДатаПодписи");
	МассивПолей.Добавить("Комментарий");
	МассивПолей.Добавить("Подписал");
	
	ТекущийПользовательПодписант = ТекущиеДанные.Подписал = Форма.ТекущийПользователь;
	ТекущийПользовательУстановилПодпись = ТекущиеДанные.Установил = Форма.ТекущийПользователь;
	
	Для Каждого Поле Из МассивПолей Цикл
		Если РаботаСПодписямиДокументовКлиентСервер.ЭтоОрганизация(ТекущиеДанные.Сторона)
			И ТекущиеДанные.Подписан = Истина
			И ЗначениеЗаполнено(ТекущиеДанные.Подписал)
			И ЗначениеЗаполнено(ТекущиеДанные.Установил)
			И (Не ТекущийПользовательПодписант
				И Не ТекущийПользовательУстановилПодпись) Тогда
					
					Элементы["Стороны"+Поле].ТолькоПросмотр = Истина;
					
		Иначе
			
			Если Не ЗапрещеноРедактироватьПолеСтороныПоШаблону(Форма.СтороныШаблона, ТекущиеДанные, Поле) Тогда
				Элементы["Стороны"+Поле].ТолькоПросмотр = Ложь;
			КонецЕсли;
		КонецЕсли;
			
	КонецЦикла;
	
КонецПроцедуры

Функция ЗапрещеноРедактироватьПолеСтороныПоШаблону(СтороныШаблона, ТекущиеДанные, Поле)
	
	Если ЗначениеЗаполнено(ТекущиеДанные[Поле]) Тогда
		
		Попытка
			Если СтороныШаблона.НайтиСтроки(Новый Структура(Поле, ТекущиеДанные[Поле])).Количество() > 0 Тогда
				Возврат Истина;
			Иначе
				Возврат Ложь;
			КонецЕсли;
		Исключение
			// поле отсутствует в таблице сторон шаблона
			Возврат Ложь;
		КонецПопытки;
		
	Иначе
		Возврат Ложь;
	КонецЕсли;

КонецФункции


