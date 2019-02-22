
&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ТекстСостояния = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выполняется обновление прав пользователя %1.%2Пожалуйста, подождите...'; en = 'Updating permissions of user %1.%2Please wait...'"),
		Строка(Запись.Кому),
		Символы.ПС);
	Состояние(ТекстСостояния);
		
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Параметры.Ключ) Тогда
		Запись.Ответственный = Пользователи.ТекущийПользователь();
		Запись.ДатаПередачи = ТекущаяДата();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ТекстСостояния = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Нстр("ru = 'Права пользователя %1 обновлены.'; en = 'Права пользователя %1 обновлены.'"),
		Строка(Запись.Кому));
	Состояние(ТекстСостояния);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтКогоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСПользователямиКлиент.ВыбратьПользователя(Элемент, Запись.ОтКого);
	
КонецПроцедуры

&НаКлиенте
Процедура КомуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСПользователямиКлиент.ВыбратьПользователя(Элемент, Запись.Кому);
	
КонецПроцедуры


