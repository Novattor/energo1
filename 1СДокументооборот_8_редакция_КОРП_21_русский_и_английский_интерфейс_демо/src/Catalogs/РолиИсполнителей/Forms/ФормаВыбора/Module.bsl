
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПоказатьПомеченныеРоли();
	
	// Установка условного оформления для списка Роли
	ЭлементУсловногоОформления = Роли.УсловноеОформление.Элементы.Добавить();
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЕстьИсполнители");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементЦветаОформления.Значение =  Метаданные.ЭлементыСтиля.РольБезИсполнителей.Значение; 
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОбластиОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОбластиОформления.Поле = Новый ПолеКомпоновкиДанных("Наименование");
	
	ЭлементУсловногоОформления = Роли.УсловноеОформление.Элементы.Добавить();
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементШрифтОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Шрифт");
	ЗачеркнутыйШрифт = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста,,,,,,Истина);
	ЭлементШрифтОформления.Значение = ЗачеркнутыйШрифт;
	ЭлементШрифтОформления.Использование = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьПомеченныеНаУдаление(Команда)
	
	ПоказыватьПомеченныеНаУдаление = Не ПоказыватьПомеченныеНаУдаление;
	Элементы.ПоказыватьПомеченныеНаУдаление.Пометка = ПоказыватьПомеченныеНаУдаление;
	ПоказатьПомеченныеРоли();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПоказатьПомеченныеРоли()
	
	Если ПоказыватьПомеченныеНаУдаление Тогда
		ПараметрСписка = Роли.Параметры.Элементы.Найти("ПоказыватьПомеченныеРоли");
		Если ПараметрСписка <> Неопределено Тогда
			ПараметрСписка.Использование = Ложь;
		КонецЕсли;
	Иначе
		Роли.Параметры.УстановитьЗначениеПараметра("ПоказыватьПомеченныеРоли", Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
