
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭлементыКорень = ДеревоБизнесПроцессовИТочек.ПолучитьЭлементы();
	
	Для Каждого Элемент Из Метаданные.БизнесПроцессы Цикл
		ИмяБизнесПроцесса = Элемент.Имя;
		БизнесПроцессМенеджер = БизнесПроцессы[ИмяБизнесПроцесса];
		
		ЭлементБизнесПроцесс = ЭлементыКорень.Добавить();
		ЭлементБизнесПроцесс.Имя = Элемент.Представление();
		ЭлементБизнесПроцесс.Картинка = 0;
		
		ЭлементыБП = ЭлементБизнесПроцесс.ПолучитьЭлементы();
		
		ВБизнесПроцессеЕстьТочки = Ложь;
		Для Каждого Точка Из БизнесПроцессМенеджер.ТочкиМаршрута Цикл
			Если Точка.Вид = ВидТочкиМаршрутаБизнесПроцесса.Действие Тогда
				ЭлементТочка = ЭлементыБП.Добавить();
				ЭлементТочка.Имя = Точка.НаименованиеЗадачи;
				ЭлементТочка.Ссылка = Точка;
				ЭлементТочка.Картинка = -1;
				ВБизнесПроцессеЕстьТочки = Истина;
			КонецЕсли;
		КонецЦикла;
		
		Если Не ВБизнесПроцессеЕстьТочки Тогда
			ЭлементыКорень.Удалить(ЭлементБизнесПроцесс);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоБизнес

&НаКлиенте
Процедура ДеревоБизнесПроцессовИТочекВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработатьВыбор();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ОбработатьВыбор();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обрабатывает выбор значения в таблице ДеревоБизнесПроцессовИТочек
//
&НаКлиенте
Процедура ОбработатьВыбор()
	
	ЭлементДерева = Элементы.ДеревоБизнесПроцессовИТочек.ДанныеСтроки(
		Элементы.ДеревоБизнесПроцессовИТочек.ТекущаяСтрока);
	Если ЭлементДерева.Ссылка <> Неопределено Тогда
		
		СтруктураВозврата = Новый Структура(
			"ТочкаМаршрута, БизнесПроцесс",
			ЭлементДерева.Ссылка,
			ЭлементДерева.ПолучитьРодителя().Имя);
			
		Закрыть(СтруктураВозврата);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти





