
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Поиск текста в поле ""%1""'; en = 'Search text in the field ""%1""'"),
		Параметры.Поле);
	
	Для Каждого Элемент Из Параметры.СписокЗначений Цикл
		НоваяСтрока = ТаблицаСтрок.Добавить();
		НоваяСтрока.Строка = Элемент.Значение;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	ВозвращаемыйСписок = Новый СписокЗначений();
	Для Каждого СтрокаТаблицы Из ТаблицаСтрок Цикл
		Если ЗначениеЗаполнено(СтрокаТаблицы.Строка) Тогда
			ВозвращаемыйСписок.Добавить(СтрокаТаблицы.Строка);
		КонецЕсли;
	КонецЦикла;
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Список", ВозвращаемыйСписок);
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры


