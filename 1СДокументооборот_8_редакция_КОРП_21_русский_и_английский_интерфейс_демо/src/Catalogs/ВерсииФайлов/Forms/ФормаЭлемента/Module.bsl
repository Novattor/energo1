
&НаКлиенте
Процедура ОткрытьВыполнить()
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(
		Неопределено, Объект.Ссылка, УникальныйИдентификатор);
		
	РаботаСФайламиКлиент.Открыть(ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолноеНаименованиеПриИзменении(Элемент)
	Объект.Наименование = Объект.ПолноеНаименование;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Файлы") Тогда
		Элементы.ПолноеНаименование.ТолькоПросмотр = Истина;
	КонецЕсли;	
	
	СписокРасширенийТекстовыхФайлов = ФайловыеФункции.ПолучитьСписокРасширенийТекстовыхФайлов();
	Если ФайловыеФункцииКлиентСервер.РасширениеФайлаВСписке(СписокРасширенийТекстовыхФайлов, Объект.Расширение) Тогда
	
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
			
			КодировкаЗначение = РаботаСФайламиВызовСервера.ПолучитьКодировкуВерсииФайла(Объект.Ссылка);
			
			СписокКодировок = РаботаСоСтроками.ПолучитьСписокКодировок();
			ЭлементСписка = СписокКодировок.НайтиПоЗначению(КодировкаЗначение);
			Если ЭлементСписка = Неопределено Тогда
				Кодировка = КодировкаЗначение;
			Иначе	
				Кодировка = ЭлементСписка.Представление;
			КонецЕсли;
			
		КонецЕсли;	
		
		Если Не ЗначениеЗаполнено(Кодировка) Тогда
			Кодировка = НСтр("ru='По умолчанию'; en = 'Default'");
		КонецЕсли;	
		
	Иначе	
		Элементы.Кодировка.Видимость = Ложь;
	КонецЕсли;	
		
	Если ПользователиСерверПовтИсп.ЭтоПолноправныйПользовательИБ() Тогда
		Элементы.Автор.ТолькоПросмотр = Ложь;
		Элементы.ДатаСоздания.ТолькоПросмотр = Ложь;
		Элементы.РодительскаяВерсия.ТолькоПросмотр = Ложь;
	Иначе
		Элементы.ГруппаХранение.Видимость = Ложь;
	КонецЕсли;	
	
	ТомПолныйПуть = ФайловыеФункции.ПолныйПутьТома(Объект.Том);
	
	РасставитьВидимостьЭлементовВосстановления();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ВерсияВосстановлена" Тогда
		ПрочитатьИРасставитьВидимостьЭлементовВосстановления();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ВерсияСохранена", Объект.Владелец);
КонецПроцедуры


&НаКлиенте
Процедура СохранитьКак(Команда)
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляСохранения(
		Неопределено, Объект.Ссылка, УникальныйИдентификатор);
		
	КомандыРаботыСФайламиКлиент.СохранитьКак(ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры


&НаКлиенте
Процедура ВосстановитьВерсию(Команда)
	
	ПараметрыФормы = Новый Структура("ВерсияСсылка", Объект.Ссылка);
	Обработчик = Новый ОписаниеОповещения("ПрочитатьИРасставитьВидимостьЭлементовВосстановленияКлиент", ЭтотОбъект);
	ОткрытьФорму("Справочник.ВерсииФайлов.Форма.ФормаВосстановленияВерсии", ПараметрыФормы,,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьИРасставитьВидимостьЭлементовВосстановленияКлиент(Результат = Неопределено, 
	ПараметрыВыполнения = Неопределено) Экспорт
	
	Если Результат <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;	
	
	ПрочитатьИРасставитьВидимостьЭлементовВосстановления();

КонецПроцедуры
&НаСервере
Процедура РасставитьВидимостьЭлементовВосстановления()

	Если Объект.ФайлУдален И РольДоступна("ПолныеПрава") Тогда
		Элементы.ГруппаСохранение.Видимость = Истина;
		Элементы.ФормаВосстановитьВерсию.Видимость = Истина;
		ПутьСохранения = РаботаСФайламиВызовСервера.ПолучитьИмяСохраненияВерсии(Объект.Ссылка);
	Иначе
		Элементы.ГруппаСохранение.Видимость = Ложь;
		Элементы.ФормаВосстановитьВерсию.Видимость = Ложь;
	КонецЕсли;	
	
	Элементы.Том.Видимость = Не Объект.ФайлУдален;
	Элементы.ТомПолныйПуть.Видимость = Не Объект.ФайлУдален;
	Элементы.ПутьКФайлу.Видимость = Не Объект.ФайлУдален;

КонецПроцедуры

&НаСервере
Процедура ПрочитатьИРасставитьВидимостьЭлементовВосстановления()	
	
	Прочитать();
	РасставитьВидимостьЭлементовВосстановления();

КонецПроцедуры

