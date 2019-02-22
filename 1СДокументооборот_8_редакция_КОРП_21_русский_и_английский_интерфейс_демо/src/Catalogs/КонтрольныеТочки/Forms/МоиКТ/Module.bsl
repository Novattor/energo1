#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Настройка списка НаИсполнение
	НаИсполнение.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДатаСеанса());
	НаИсполнение.Параметры.УстановитьЗначениеПараметра("НачалоНедели", НачалоНедели(ТекущаяДатаСеанса()));
	
	НаИсполнение.Параметры.УстановитьЗначениеПараметра("Ответственный", Пользователи.ТекущийПользователь());
	
	Элементы.НаИсполнениеКомандаПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		НаИсполнение, "ПометкаУдаления", Ложь,
		ВидСравненияКомпоновкиДанных.Равно, , Истина);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		НаИсполнение, "Исполнено", Ложь,
		ВидСравненияКомпоновкиДанных.Равно, , Истина);
		
	// Настройка списка НаПроверку
	НаПроверку.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДатаСеанса());
	НаПроверку.Параметры.УстановитьЗначениеПараметра("Проверяющий", Пользователи.ТекущийПользователь());
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		НаПроверку, "ПометкаУдаления", Ложь,
		ВидСравненияКомпоновкиДанных.Равно, , Истина);
		
	// Настройка списка НаКонтроль	
	НаКонтроль.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДатаСеанса());
	НаКонтроль.Параметры.УстановитьЗначениеПараметра("НачалоНедели", НачалоНедели(ТекущаяДатаСеанса()));
	НаКонтроль.Параметры.УстановитьЗначениеПараметра("Проверяющий", Пользователи.ТекущийПользователь());
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		НаКонтроль, "ПометкаУдаления", Ложь,
		ВидСравненияКомпоновкиДанных.Равно, , Истина);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		НаКонтроль, "Пройдена", Ложь,
		ВидСравненияКомпоновкиДанных.Равно, , Истина);
		
	СпискиВыборка = Новый СписокЗначений;
	СпискиВыборка.Добавить("ОбъектКТНаИспонение");
	СпискиВыборка.Добавить("ОбъектКТНаПроверку");
	СпискиВыборка.Добавить("ОбъектКТНаКонтроль"); 
	СформироватьСпискиВыбораОбъектовКТ(СпискиВыборка);	
		
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ПараметрыОтбора = Новый Соответствие;
	ПараметрыОтбора.Вставить("УровеньКонтроля", Настройки.Получить("УровеньКонтроля"));
	ПараметрыОтбора.Вставить("Ответственный", Настройки.Получить("ОтветственныйНаКонтроль"));
	ПараметрыОтбора.Вставить("ОбъектКТ", Настройки.Получить("ОбъектКТНаКонтроль"));
	УстановитьОтборСписка(НаКонтроль, ПараметрыОтбора);
	
	ПараметрыОтбора = Новый Соответствие;
	ПараметрыОтбора.Вставить("УровеньКонтроля", Настройки.Получить("УровеньКонтроляНаПроверку"));
	ПараметрыОтбора.Вставить("Ответственный", Настройки.Получить("ОтветственныйНаПроверку"));
	ПараметрыОтбора.Вставить("ОбъектКТ", Настройки.Получить("ОбъектКТНаПроверку"));
	УстановитьОтборСписка(НаПроверку, ПараметрыОтбора);
	
	ПараметрыОтбора = Новый Соответствие;
	ПараметрыОтбора.Вставить("УровеньКонтроля", Настройки.Получить("УровеньКонтроляНаИсполнение"));
	ПараметрыОтбора.Вставить("ОбъектКТ", Настройки.Получить("ОбъектКТНаИспонение"));
	УстановитьОтборСписка(НаИсполнение, ПараметрыОтбора);
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.УровеньКонтроляНаИсполнение, УровеньКонтроляНаИсполнение);
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.УровеньКонтроляНаПроверку, УровеньКонтроляНаПроверку);
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.УровеньКонтроля, УровеньКонтроля);
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ОтветственныйНаПроверку, ОтветственныйНаПроверку);
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ОтветственныйНаКонтроль, ОтветственныйНаКонтроль);	
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ОбъектКТНаИспонение, ОбъектКТНаИспонение);	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ОбъектКТНаПроверку, ОбъектКТНаПроверку);
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ОбъектКТНаКонтроль, ОбъектКТНаКонтроль);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НаИсполнениеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Поле = Элементы.НаИсполнениеИндексКартинкиОценки Тогда
		ОценитьВыбранныеКТ();
	ИначеЕсли Поле = Элементы.НаИсполнениеОбъектКТ Тогда
		ПоказатьЗначение(,Элементы.НаИсполнение.ТекущиеДанные.ОбъектКТ);
	Иначе
		ПоказатьЗначение(,Элементы.НаИсполнение.ТекущиеДанные.Ссылка);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура УровеньКонтроляПриИзменении(Элемент)
	
	ПараметрыОтбора = Новый Соответствие;
	Параметрыотбора.Вставить("УровеньКонтроля", УровеньКонтроля);
	
	УстановитьОтборСписка(НаКонтроль, ПараметрыОтбора);		
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, УровеньКонтроля);	
	
КонецПроцедуры

&НаКлиенте
Процедура УровеньКонтроляНаПроверкуПриИзменении(Элемент)
	
	ПараметрыОтбора = Новый Соответствие;
	Параметрыотбора.Вставить("УровеньКонтроля", УровеньКонтроляНаПроверку);
	
	УстановитьОтборСписка(НаПроверку, ПараметрыОтбора);		
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, УровеньКонтроляНаПроверку);
	
КонецПроцедуры

&НаКлиенте
Процедура УровеньКонтроляНаИсполнениеПриИзменении(Элемент)
	
	ПараметрыОтбора = Новый Соответствие;
	Параметрыотбора.Вставить("УровеньКонтроля", УровеньКонтроляНаИсполнение);
	
	УстановитьОтборСписка(НаИсполнение, ПараметрыОтбора);		
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, УровеньКонтроляНаИсполнение);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйНаПроверкуПриИзменении(Элемент)
	
	ПараметрыОтбора = Новый Соответствие;
	Параметрыотбора.Вставить("Ответственный", ОтветственныйНаПроверку);
	
	УстановитьОтборСписка(НаПроверку, ПараметрыОтбора);		
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ОтветственныйНаПроверку);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйНаКонтрольПриИзменении(Элемент)
	
	ПараметрыОтбора = Новый Соответствие;
	Параметрыотбора.Вставить("Ответственный", ОтветственныйНаКонтроль);
	
	УстановитьОтборСписка(НаКонтроль, ПараметрыОтбора);		
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ОтветственныйНаКонтроль);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектКТНаИспонениеПриИзменении(Элемент)
	
	ПараметрыОтбора = Новый Соответствие;
	Параметрыотбора.Вставить("ОбъектКТ", ?(ОбъектКТНаИспонение = Неопределено,
										ПредопределенноеЗначение("Справочник.Проекты.ПустаяСсылка"),
										ОбъектКТНаИспонение));
	
	УстановитьОтборСписка(НаИсполнение, ПараметрыОтбора);		
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ОбъектКТНаИспонение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектКТНаПроверкуПриИзменении(Элемент)
	
	ПараметрыОтбора = Новый Соответствие;
	Параметрыотбора.Вставить("ОбъектКТ", ?(ОбъектКТНаПроверку = Неопределено,
										ПредопределенноеЗначение("Справочник.Проекты.ПустаяСсылка"),
										ОбъектКТНаПроверку));
	
	УстановитьОтборСписка(НаПроверку, ПараметрыОтбора);		
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ОбъектКТНаПроверку);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектКТНаКонтрольПриИзменении(Элемент)
	
	ПараметрыОтбора = Новый Соответствие;
	Параметрыотбора.Вставить("ОбъектКТ", ?(ОбъектКТНаКонтроль = Неопределено,
										ПредопределенноеЗначение("Справочник.Проекты.ПустаяСсылка"),
										ОбъектКТНаКонтроль));
	
	УстановитьОтборСписка(НаКонтроль, ПараметрыОтбора);		
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ОбъектКТНаКонтроль);	
	
КонецПроцедуры

&НаКлиенте
Процедура НаПроверкуВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Поле = Элементы.НаПроверкуОбъектКТ Тогда
		ПоказатьЗначение(,Элементы.НаПроверку.ТекущиеДанные.ОбъектКТ);
	Иначе
		ПоказатьЗначение(,Элементы.НаПроверку.ТекущиеДанные.Ссылка);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура НаКонтрольВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Поле = Элементы.НаКонтрольОбъектКТ Тогда
		ПоказатьЗначение(,Элементы.НаКонтроль.ТекущиеДанные.ОбъектКТ);
	Иначе
		ПоказатьЗначение(,Элементы.НаКонтроль.ТекущиеДанные.Ссылка);
	КонецЕсли;		
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОценить(Команда)
	
	ОценитьВыбранныеКТ();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаИсполнено(Команда)
	
	КомандаИсполненоНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	Элементы.НаИсполнениеКомандаПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
	Если Не ПоказыватьУдаленные Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			НаИсполнение, "ПометкаУдаления", Ложь,
			ВидСравненияКомпоновкиДанных.Равно, , Истина);
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			НаПроверку, "ПометкаУдаления", Ложь,
			ВидСравненияКомпоновкиДанных.Равно, , Истина);
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			НаКонтроль, "ПометкаУдаления", Ложь,
			ВидСравненияКомпоновкиДанных.Равно, , Истина);
			
	Иначе		
			
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(НаИсполнение, "ПометкаУдаления");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(НаПроверку, "ПометкаУдаления");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(НаКонтроль, "ПометкаУдаления");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПроверено(Команда)
	
	КомандаПровереноНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗапроситьОценки(Команда)
	
	СтрокаСостояния = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Пожалуйста, подождите!%1Идет запрос оценок...'; en = 'Please, wait!%1Requesting estimates...'"),
		Символы.ПС);
	Состояние(СтрокаСостояния);	
	
	СписокКТ = Новый Массив;
	Для Каждого Элемент Из Элементы.НаКонтроль.ВыделенныеСтроки Цикл
		СписокКТ.Добавить(Элемент);	
	КонецЦикла;
	
	Если СписокКТ.Количество() > 0 Тогда
		КоличествоЗапрошенныхОценок = 0;
		ЗапроситьОценкиНаСервере(СписокКТ, КоличествоЗапрошенныхОценок);
		
		Состояние();	
		
		Если КоличествоЗапрошенныхОценок > 0 Тогда
			ПоказатьПредупреждение(,НСтр("ru = 'Оценки запрошены у ответственных за контрольные точки.'; en = 'Estimates requested from the responsible for milestones.'"));
		Иначе
			ПоказатьПредупреждение(,НСтр("ru = 'Нет контрольных точек нуждающихся в оценке ответственными.'; en = 'No milestones to be estimated by responsible employees.'"));
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокНаИспонение(Команда)
	
	Элементы.НаИсполнение.Обновить();
	
	СпискиВыборка = Новый СписокЗначений;
	СпискиВыборка.Добавить("ОбъектКТНаИспонение");
	СформироватьСпискиВыбораОбъектовКТ(СпискиВыборка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокНаПроверку(Команда)
	
	Элементы.НаПроверку.Обновить();
	
	СпискиВыборка = Новый СписокЗначений;
	СпискиВыборка.Добавить("ОбъектКТНаПроверку");
	СформироватьСпискиВыбораОбъектовКТ(СпискиВыборка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокНаКонтроль(Команда)
	
	Элементы.НаКонтроль.Обновить();
	
	СпискиВыборка = Новый СписокЗначений;
	СпискиВыборка.Добавить("ОбъектКТНаКонтроль");
	СформироватьСпискиВыбораОбъектовКТ(СпискиВыборка);	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОценитьВыбранныеКТ()

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ВыбранныеКТ", Элементы.НаИсполнение.ВыделенныеСтроки);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавлениеОценкиКТПродолжение", ЭтотОбъект, ДополнительныеПараметры);
	ПараметрыФормы = Новый Структура;

	ОткрытьФорму("Справочник.КонтрольныеТочки.Форма.ДобавлениеОценкиКТ", ПараметрыФормы, ЭтаФорма,,,, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавлениеОценкиКТПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = "Отмена" ИЛИ Результат = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Если ДополнительныеПараметры.ВыбранныеКТ.Количество() > 5 Тогда
		СтрокаСостояние = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Идет установка оценок контрольных точек (%1). Пожалуйста, подождите'; en = 'Setting estimates for milestones (%1). Please wait'"),
			Строка(ДополнительныеПараметры.ВыбранныеКТ.Количество()));
		Состояние(СтрокаСостояние);
	КонецЕсли;	
	
	УстановитьОценкуСервер(
		Результат.Оценка, 
		Результат.Дата, 
		Результат.Автор, 
		Результат.Комментарий, 
		ДополнительныеПараметры.ВыбранныеКТ);
	
	Если ДополнительныеПараметры.ВыбранныеКТ.Количество() > 5 Тогда
		СтрокаСостояние = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Установка оценок контрольных точек завершена (%1).'; en = 'Setting estimates for milestones completed (%1).'"),
			Строка(ДополнительныеПараметры.ВыбранныеКТ.Количество()));
		Состояние(СтрокаСостояние);
	КонецЕсли;	
	
	Элементы.НаИсполнение.Обновить();

КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьОценкуСервер(Оценка, Дата, Автор, Комментарий, СписокКТ)
	
	КонтрольныеТочки.УстановитьОценку(Оценка, Дата, Автор, Комментарий, СписокКТ);	
	
КонецПроцедуры	
	
&НаСервере
Процедура КомандаИсполненоНаСервере()
	
	Схема = Элементы.НаИсполнение.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.НаИсполнение.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	ДанныеНаФорме = Новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(ДанныеНаФорме); 
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);	
	
	ИндексПоследнейОбработаннойСтроки = -1;
	
	НачатьТранзакцию();
	
	Попытка
		
		Для каждого Эл Из Элементы.НаИсполнение.ВыделенныеСтроки Цикл
			ЗаблокироватьДанныеДляРедактирования(Эл.Ссылка);			
			КТОбъект = Эл.Ссылка.ПолучитьОбъект();
			КТОбъект.Исполнено = Истина;
			КТОбъект.ФактическийСрок = ТекущаяДатаСеанса();
			КТОбъект.Записать();
			
		КонецЦикла;
		
		Если ЗначениеЗаполнено(Эл) Тогда
			ИндексПоследнейОбработаннойСтроки = ДанныеНаФорме.Индекс(ДанныеНаФорме.НайтиСтроки(Новый Структура("Ссылка", Эл.Ссылка))[0]);		
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отметка исполнения контрольных точек'; en = 'Performance mark for milestones'"),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;	
	
	Элементы.НаИсполнение.Обновить();
	
	ИндексПоследнейОбработаннойСтроки = ИндексПоследнейОбработаннойСтроки - Элементы.НаПроверку.ВыделенныеСтроки.Количество() + 1;	
	
	Если ИндексПоследнейОбработаннойСтроки < 0 Тогда
		Возврат;
	КонецЕсли;
	
	Схема = Элементы.НаИсполнение.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.НаИсполнение.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	ДанныеНаФорме = Новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(ДанныеНаФорме); 
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);	
	
	ИндексИтоговойСтроки = Мин(ИндексПоследнейОбработаннойСтроки, ДанныеНаФорме.Количество()-1);
	
	Если ИндексИтоговойСтроки = -1 Тогда
		Возврат;
	КонецЕсли;
	
	ИтоговоеЗначение = ДанныеНаФорме[ИндексИтоговойСтроки].Ссылка;
	
	Элементы.НаИсполнение.ТекущаяСтрока = ИтоговоеЗначение;
	
КонецПроцедуры

&НаСервере
Процедура КомандаПровереноНаСервере()
	
	Схема = Элементы.НаПроверку.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.НаПроверку.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	ДанныеНаФорме = Новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(ДанныеНаФорме); 
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);	
	
	ИндексПоследнейОбработаннойСтроки = -1;	
	
	НачатьТранзакцию();
	
	Попытка 
		
		Для каждого Эл Из Элементы.НаПроверку.ВыделенныеСтроки Цикл
			ЗаблокироватьДанныеДляРедактирования(Эл.Ссылка);
			КТ = Эл.Ссылка.ПолучитьОбъект();
			КТ.Проверено = Истина;
			КТ.ДатаПроверки = ТекущаяДатаСеанса();
			КТ.Записать();
			
		КонецЦикла;	
		
		Если ЗначениеЗаполнено(Эл) Тогда
			ИндексПоследнейОбработаннойСтроки = ДанныеНаФорме.Индекс(ДанныеНаФорме.НайтиСтроки(Новый Структура("Ссылка", Эл.Ссылка))[0]);		
		КонецЕсли;	
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отметка проверки контрольных точек'; en = 'Verification mark for milestones'"),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;	
	
	Элементы.НаПроверку.Обновить();
	
	ИндексПоследнейОбработаннойСтроки = ИндексПоследнейОбработаннойСтроки - Элементы.НаПроверку.ВыделенныеСтроки.Количество() + 1;
	
	Если ИндексПоследнейОбработаннойСтроки < 0 Тогда
		Возврат;
	КонецЕсли;
	
	Схема = Элементы.НаПроверку.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.НаПроверку.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	ДанныеНаФорме = Новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(ДанныеНаФорме); 
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);	
	
	ИндексИтоговойСтроки = Мин(ИндексПоследнейОбработаннойСтроки, ДанныеНаФорме.Количество()-1);
	
	Если ИндексИтоговойСтроки = -1 Тогда
		Возврат;
	КонецЕсли;
	
	ИтоговоеЗначение = ДанныеНаФорме[ИндексИтоговойСтроки].Ссылка;
	
	Элементы.НаПроверку.ТекущаяСтрока = ИтоговоеЗначение;	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборСписка(Список, ПараметрыОтбора)
	
	// уровень контрольной точки 
	УровеньКонтроля = ПараметрыОтбора.Получить("УровеньКонтроля");
	Если УровеньКонтроля <> Неопределено Тогда 
		Если ЗначениеЗаполнено(УровеньКонтроля) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
				"УровеньКТ",
				УровеньКонтроля,
				ВидСравненияКомпоновкиДанных.Равно);
		Иначе
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "УровеньКТ");

		КонецЕсли;
	КонецЕсли;
	
	// Ответственный
	Ответственный = ПараметрыОтбора.Получить("Ответственный");
	Если Ответственный <> Неопределено Тогда 
		Если ЗначениеЗаполнено(Ответственный) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
				"Ответственный",
				Ответственный,
				ВидСравненияКомпоновкиДанных.Равно);
		Иначе
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Ответственный");

		КонецЕсли;
	КонецЕсли;	
	
	// Объект КТ
	ОбъектКТ = ПараметрыОтбора.Получить("ОбъектКТ");
	Если ОбъектКТ <> Неопределено Тогда 
		Если ЗначениеЗаполнено(ОбъектКТ) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
				"ОбъектКТ",
				ОбъектКТ,
				ВидСравненияКомпоновкиДанных.Равно);
		Иначе
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "ОбъектКТ");

		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ЗапроситьОценкиНаСервере(Знач СписокКТ, КоличествоЗапрошенныхОценок)

	КонтрольныеТочки.ЗапроситьОценки(Неопределено, СписокКТ, КоличествоЗапрошенныхОценок);		
	Элементы.НаКонтроль.Обновить();		

КонецПроцедуры // ЗапроситьОценкиНаСервере()

&НаСервере
Процедура СформироватьСпискиВыбораОбъектовКТ(СпискиВыбора)

	Если СпискиВыбора.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ТекстЗапроса = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 20
		|	КонтрольныеТочки.ОбъектКТ КАК ОбъектКТ
		|ИЗ
		|	Справочник.КонтрольныеТочки КАК КонтрольныеТочки
		|ГДЕ
		|	КонтрольныеТочки.ПометкаУдаления = ЛОЖЬ
		| [ОтборСписка] ";
		
	Для Каждого Список Из СпискиВыбора Цикл
		
		Запрос.Текст = Запрос.Текст + " " + ТекстЗапроса;
		СтрокаОтбора = "";
		
		Если Список.Значение = "ОбъектКТНаИспонение" Тогда
			СтрокаОтбора =  "И КонтрольныеТочки.Ответственный = &Ответственный
							|	И КонтрольныеТочки.Исполнено = ЛОЖЬ ;";
			
		ИначеЕсли Список.Значение = "ОбъектКТНаПроверку" Тогда
			СтрокаОтбора =  "И КонтрольныеТочки.Исполнено = ИСТИНА
							|	И КонтрольныеТочки.Проверено = ЛОЖЬ
							|	И КонтрольныеТочки.Проверяющий = &Ответственный ;";
							
		ИначеЕсли Список.Значение = "ОбъектКТНаКонтроль" Тогда
			СтрокаОтбора =  "И КонтрольныеТочки.Пройдена = ЛОЖЬ
							|	И КонтрольныеТочки.Проверяющий = &Ответственный ;";
							
		КонецЕсли;
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "[ОтборСписка]", СтрокаОтбора);
		
	КонецЦикла;	
			
	Запрос.УстановитьПараметр("Ответственный", Пользователи.ТекущийПользователь());
	Результаты = Запрос.ВыполнитьПакет();
	
	Для Каждого Список Из СпискиВыбора Цикл
		НомерЭлемента = СпискиВыбора.Индекс(Список);		
		
		Выборка = Результаты[НомерЭлемента].Выбрать();
		
		СписокВыбора = Элементы[Список.Значение].СписокВыбора;
		СписокВыбора.Очистить();
		Пока Выборка.Следующий() Цикл
			СписокВыбора.Добавить(Выборка.ОбъектКТ);
		КонецЦикла;
		
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти
