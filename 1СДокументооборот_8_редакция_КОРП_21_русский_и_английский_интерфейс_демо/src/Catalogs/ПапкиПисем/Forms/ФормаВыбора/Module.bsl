&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Список.Параметры.УстановитьЗначениеПараметра("Пользователь", ПользователиКлиентСервер.ТекущийПользователь());
	
	Если Параметры.Свойство("ОтображатьУдаленные") Тогда
		ПараметрОтображатьУдаленные = Параметры.ОтображатьУдаленные;
	Иначе
		ПараметрОтображатьУдаленные =
			ВстроеннаяПочтаСервер.ПолучитьПерсональнуюНастройку("ОтображатьУдаленныеПисьмаИПапки");
	КонецЕсли;
	
	Если Параметры.Свойство("РежимМоиПапки") Тогда
		ПараметрРежимМоиПапки = Параметры.РежимМоиПапки;
	Иначе
		ПараметрРежимМоиПапки = ВстроеннаяПочтаСервер.ПолучитьПерсональнуюНастройку("РежимМоиПапки");
	КонецЕсли;
		
	УстановитьРежимМоиПапки(ПараметрРежимМоиПапки);
	УстановитьРежимОтображатьУдаленные(ПараметрОтображатьУдаленные);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимМоиПапки(Команда)
	
	УстановитьРежимМоиПапки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимВсеПапки(Команда)
	
	УстановитьРежимМоиПапки(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьРежимМоиПапки(НовыйРежимМоиПапки)
	
	РежимМоиПапки = НовыйРежимМоиПапки; 
	
	Элементы.ПапкиКонтекстноеМенюРежимМоиПапки.Пометка = НовыйРежимМоиПапки;
	Элементы.ПапкиКонтекстноеМенюРежимВсеПапки.Пометка = Не НовыйРежимМоиПапки;
	Элементы.ПапкиМенюРежимМоиПапки.Пометка = НовыйРежимМоиПапки;
	Элементы.ПапкиМенюРежимВсеПапки.Пометка = Не НовыйРежимМоиПапки;
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор,
		"ВМоихПапках",
		Истина,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		НовыйРежимМоиПапки);
		
КонецПроцедуры

&НаСервере
Процедура УстановитьРежимОтображатьУдаленные(НовымРежимОтображатьУдаленные)
	
	Элементы.СписокОтображатьПомеченныеНаУдаление.Пометка = НовымРежимОтображатьУдаленные;
	Элементы.СписокОтображатьПомеченныеНаУдалениеКонтекст.Пометка = НовымРежимОтображатьУдаленные;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор,
		"ПометкаУдаления",
		Ложь,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		Не НовымРежимОтображатьУдаленные);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьПомеченныеНаУдаление(Команда)
	
	УстановитьРежимОтображатьУдаленные(Не Элементы.СписокОтображатьПомеченныеНаУдаление.Пометка);	
	
КонецПроцедуры


