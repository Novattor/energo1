#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Отсутствия.Количество() = 1 Тогда
		КлючСохраненияПоложенияОкна = "ОдноОтсутствие";
		ТекущееОтсутствие = Параметры.Отсутствия[0];
		ОбновитьДанныеОтсутствия(ТекущееОтсутствие, ПолноеОписаниеОтсутствия);
		Элементы.Список.Видимость = Ложь;
	Иначе
		КлючСохраненияПоложенияОкна = "СписокОтсутствий";
		Список.Параметры.УстановитьЗначениеПараметра("МассивСсылок", Параметры.Отсутствия);
	КонецЕсли;
	
	ЗаместителиДляПроверки = Новый Массив;
	Для Каждого Отсутствие Из Параметры.Отсутствия Цикл
		
		Если ОтсутсвующиеПользователи.НайтиПоЗначению(Отсутствие.Сотрудник) = Неопределено Тогда
			ОтсутсвующиеПользователи.Добавить(Отсутствие.Сотрудник);
		КонецЕсли;
		
		Для Каждого СтрокаЗаместитель Из Отсутствие.Заместители Цикл
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("Сотрудник", Отсутствие.Сотрудник);
			ПараметрыОтбора.Вставить("Заместитель", СтрокаЗаместитель.Заместитель);
			Если Заместители.НайтиСтроки(ПараметрыОтбора).Количество() = 0 Тогда
				НоваяСтрока = Заместители.Добавить();
				НоваяСтрока.Сотрудник = Отсутствие.Сотрудник;
				НоваяСтрока.Заместитель = СтрокаЗаместитель.Заместитель;
			КонецЕсли;
			Если ЗаместителиДляПроверки.Найти(СтрокаЗаместитель.Заместитель) = Неопределено Тогда
				ЗаместителиДляПроверки.Добавить(СтрокаЗаместитель.Заместитель);
			КонецЕсли;
		КонецЦикла;
		
		Если ЗаместителиДляПроверки.Количество() <> 0 Тогда
			
			ДатаНачала = ТекущаяДатаСеанса();
			ДатаОкончания = ДатаНачала;
			ТаблицаОтсутствий = Отсутствия.ПолучитьТаблицуОтсутствий(
				ДатаНачала,
				ДатаОкончания,
				ЗаместителиДляПроверки);
			ОтсутствияЗаместителей.ЗагрузитьЗначения(ТаблицаОтсутствий.ВыгрузитьКолонку("Ссылка"));
			
		КонецЕсли;
		ЕстьОтсутствующиеЗаместители = ОтсутствияЗаместителей.Количество() <> 0;
		
		ЕстьОтсутствующиеБезЗаместителей = Ложь;
		Для Каждого Отсутствующий Из ОтсутсвующиеПользователи Цикл
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("Сотрудник", Отсутствие.Сотрудник);
			Если Заместители.НайтиСтроки(ПараметрыОтбора).Количество() = 0 Тогда
				ЕстьОтсутствующиеБезЗаместителей = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	КоличествоЗаместителей = ЗаместителиДляПроверки.Количество();
	ЕстьЗаместители = КоличествоЗаместителей <> 0;
	Если КоличествоЗаместителей = 0 Тогда
		Элементы.ГруппаФлаги.Видимость = Ложь;
		ЕстьОтсутствующиеБезЗаместителей = Ложь;
		ДобавитьЗаместителей = Ложь;
		
		ВсеАдресатыОтсутсвуют = ВсеАдресатыОтсутсвуют(Параметры.Адресаты);
		Если ВсеАдресатыОтсутсвуют Тогда
			Элементы.ГруппаПереключатель.Видимость = Ложь;
			КлючНазначенияИспользования = "ВсеАдресатыОтсутсвуют";
			УдалитьОтсутствующих = Ложь;
			Если Параметры.Адресаты.Количество() = 1 Тогда
				НадписьПредупреждение = "Адресат письма сейчас отсутствует.";
			Иначе
				НадписьПредупреждение = "Адресаты письма сейчас отсутствуют.";
			КонецЕсли;
		Иначе
			КлючНазначенияИспользования = "БезЗаместителей";
		КонецЕсли;
		
	ИначеЕсли КоличествоЗаместителей = 1 Тогда
		Элементы.ГруппаПереключатель.Видимость = Ложь;
		Элементы.ДобавитьЗаместителей.Заголовок = НСтр("ru = 'Добавить заместителя'; en = 'Add deputy'");
		КлючНазначенияИспользования = "СЗаместителями";
	Иначе
		Элементы.ГруппаПереключатель.Видимость = Ложь;
		Элементы.ДобавитьЗаместителей.Заголовок = СтрШаблон(
			НСтр("ru = 'Добавить заместителей (%1)'; en = 'Add deputies (%1)'"),
			КоличествоЗаместителей);
		КлючНазначенияИспользования = "СЗаместителями";
	КонецЕсли;
	
	КоличествоОтсутствующих = ОтсутсвующиеПользователи.Количество();
	Если КоличествоОтсутствующих = 1 Тогда
		Элементы.УдалитьОтсутствующих.Заголовок = НСтр("ru = 'Удалить отсутствующего'; en = 'Delete the absent one'");
		Элементы.ВариантОтправки.СписокВыбора[1].Представление = НСтр("ru = 'Удалить отсутствующего'; en = 'Delete the absent one'");
	Иначе
		Элементы.УдалитьОтсутствующих.Заголовок = НСтр("ru = 'Удалить отсутствующих'; en = 'Delete the absent ones'");
		Элементы.ВариантОтправки.СписокВыбора[1].Представление = НСтр("ru = 'Удалить отсутствующих'; en = 'Delete the absent ones'");
	КонецЕсли;
	
	ОбновитьФлаги();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если КлючНазначенияИспользования = "БезЗаместителей" Тогда
		ДобавитьЗаместителей = Ложь;
	ИначеЕсли КлючНазначенияИспользования = "ВсеАдресатыОтсутсвуют" Тогда
		ДобавитьЗаместителей = Ложь;
		УдалитьОтсутствующих = Ложь;
	КонецЕсли;
	
	Элементы.УдалитьОтсутствующихПодсказка.Видимость = 
		ЕстьОтсутствующиеБезЗаместителей
		И УдалитьОтсутствующих
		И ДобавитьЗаместителей;
	Элементы.ВариантОтправкиПодсказка.Видимость = Элементы.УдалитьОтсутствующихПодсказка.Видимость;
	Элементы.ПоказатьОтсутствующихЗаместителей.Видимость =
		ЕстьОтсутствующиеЗаместители
		И ДобавитьЗаместителей;
	ОбновитьФлаги();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПолноеОписаниеОтсутствияПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВстроеннаяПочтаКлиент.ОткрытьСсылку(ДанныеСобытия.Href, ДанныеСобытия.Element, , Элемент.Документ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьКакЕстьПриИзменении(Элемент)
	
	ДобавитьЗаместителей = Ложь;
	УдалитьОтсутствующих = Ложь;
	ОбновитьФлагиНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьОтсутствующихПриИзменении(Элемент)
	
	ОбновитьФлагиНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЗаместителейПриИзменении(Элемент)
	
	ОбновитьФлагиНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОтправкиПриИзменении(Элемент)
	
	Если ВариантОтправки = 1 Тогда
		УдалитьОтсутствующих = Истина;
	ИначеЕсли ВариантОтправки = 0 Тогда
		УдалитьОтсутствующих = Ложь;
	КонецЕсли;
	ОбновитьФлагиНаКлиенте();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		ТекущееОтсутствие = Неопределено;
	ИначеЕсли Элемент.ТекущиеДанные.Ссылка <> ТекущееОтсутствие Тогда
		ТекущееОтсутствие = Элемент.ТекущиеДанные.Ссылка;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ОбновитьОтсутствие", 0.2, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Да(Команда)
	
	Результат = Результат(Истина);
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Нет(Команда)
	
	Результат = Результат(Ложь);
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтсутствующихЗаместителей(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отсутствия", ОтсутствияЗаместителей.ВыгрузитьЗначения());
	ПараметрыФормы.Вставить("ТекстПредупреждения", НСтр("ru = 'Некоторые заместители адресатов письма сейчас отсутствуют.'; en = 'Some deputies of recipients of the email are absent now.'"));
	
	ОткрытьФорму("Документ.Отсутствие.Форма.ПредупреждениеОбОтсутствии", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция Результат(Отправить)
	
	Результат = Новый Структура;
	Результат.Вставить("Отправить", Отправить);
	Результат.Вставить("УдалитьОтсутствующих", УдалитьОтсутствующих);
	Результат.Вставить("ДобавитьЗаместителей", ДобавитьЗаместителей И ЕстьЗаместители);
	Результат.Вставить("Отсутствующие", ОтсутсвующиеПользователи.ВыгрузитьЗначения());
	Результат.Вставить("Заместители", Новый Соответствие);
	
	Для Каждого Отсутствующий Из Результат.Отсутствующие Цикл
		
		ЗаместителиСотрудника = Новый Массив;
		Для Каждого СтрокаЗаместитель Из Заместители Цикл
			Если СтрокаЗаместитель.Сотрудник = Отсутствующий Тогда
				ЗаместителиСотрудника.Добавить(СтрокаЗаместитель.Заместитель);
			КонецЕсли;
		КонецЦикла;
		
		Результат.Заместители.Вставить(Отсутствующий, ЗаместителиСотрудника);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьОтсутствие()
	
	Если Не ЗначениеЗаполнено(ТекущееОтсутствие) Тогда
		ПолноеОписаниеОтсутствия = ОтсутствияКлиентСервер.ПолучитьПустоеHTMLПредставление();
		Возврат;
	КонецЕсли;
	
	ОбновитьДанныеОтсутствия(ТекущееОтсутствие, ПолноеОписаниеОтсутствия);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбновитьДанныеОтсутствия(Отсутствие, ПолноеОписаниеОтсутствия)
	
	ПолноеОписаниеОтсутствия = Документы.Отсутствие.ПолучитьПредставлениеHTML(Отсутствие);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФлагиНаКлиенте()
	
	ОтправитьКакЕсть = Не УдалитьОтсутствующих И Не (ДобавитьЗаместителей И ЕстьЗаместители);
	Элементы.УдалитьОтсутствующихПодсказка.Видимость = 
		ЕстьОтсутствующиеБезЗаместителей
		И УдалитьОтсутствующих
		И ДобавитьЗаместителей;
	Элементы.ВариантОтправкиПодсказка.Видимость = Элементы.УдалитьОтсутствующихПодсказка.Видимость;
	Элементы.ПоказатьОтсутствующихЗаместителей.Видимость =
		ЕстьОтсутствующиеЗаместители
		И ДобавитьЗаместителей;
	Если ОтправитьКакЕсть Тогда
		ВариантОтправки = 0;
	ИначеЕсли УдалитьОтсутствующих Тогда
		ВариантОтправки = 1;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьФлаги()
	
	ОтправитьКакЕсть = Не УдалитьОтсутствующих И Не (ДобавитьЗаместителей И ЕстьЗаместители);
	Элементы.УдалитьОтсутствующихПодсказка.Видимость = 
		ЕстьОтсутствующиеБезЗаместителей
		И УдалитьОтсутствующих
		И ДобавитьЗаместителей;
	Элементы.ВариантОтправкиПодсказка.Видимость = Элементы.УдалитьОтсутствующихПодсказка.Видимость;
	Элементы.ПоказатьОтсутствующихЗаместителей.Видимость =
		ЕстьОтсутствующиеЗаместители
		И ДобавитьЗаместителей;
	Если ОтправитьКакЕсть Тогда
		ВариантОтправки = 0;
	ИначеЕсли УдалитьОтсутствующих Тогда
		ВариантОтправки = 1;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВсеАдресатыОтсутсвуют(Адресаты)
	
	ВсеАдресатыОтсутсвуют = Истина;
	Для Каждого Адресат Из Адресаты Цикл
		
		Если Адресат.ТипАдреса <> НСтр("ru = 'Кому:'; en = 'To:'") Тогда
			ВсеАдресатыОтсутсвуют = Ложь;
			Прервать;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Адресат.Контакт) Тогда
			ВсеАдресатыОтсутсвуют = Ложь;
			Прервать;
		КонецЕсли;
		
		Если ОтсутсвующиеПользователи.НайтиПоЗначению(Адресат.Контакт) = Неопределено Тогда
			ВсеАдресатыОтсутсвуют = Ложь;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ВсеАдресатыОтсутсвуют;
	
КонецФункции

#КонецОбласти
