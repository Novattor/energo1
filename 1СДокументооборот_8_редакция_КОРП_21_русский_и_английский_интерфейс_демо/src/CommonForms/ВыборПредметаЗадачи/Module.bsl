////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Задача") Тогда
		ПредметыЗадачи = Мультипредметность.ПолучитьПредметыЗадачи(Параметры.Задача);
		Для каждого СтрокаПредмета из ПредметыЗадачи Цикл
			Если ЗначениеЗаполнено(СтрокаПредмета.Предмет) Тогда
				Строка = Предметы.Добавить();
				ЗаполнитьЗначенияСвойств(Строка, СтрокаПредмета);
				Строка.Картинка = МультипредметностьКлиентСервер.ИндексКартинкиРолиПредмета(
					Строка.РольПредмета, ?(Строка.Предмет = Неопределено, Ложь, Строка.Предмет.ПометкаУдаления));
				Строка.Описание = ОбщегоНазначенияДокументооборотВызовСервера.ПредметСтрокой(Строка.Предмет, Строка.ИмяПредмета);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Предметы.Количество() > 0 Тогда
		Если Предметы.Количество() = 1 Тогда
			Отказ = Истина;
			ПоказатьЗначение(,Предметы[0].Предмет);
		КонецЕсли;
	Иначе
		Отказ = Истина;
		ПоказатьПредупреждение(,НСтр("ru = 'У выбранной задачи не установлен предмет.'; en = 'The selected task has no subject.'"));
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПредметыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Строка = Предметы.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	Если Строка.Предмет <> Неопределено и НЕ Строка.Предмет.Пустая() Тогда
		ОткрытьПредметНаКлиенте(Элементы.Предметы.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПредмет(Команда)
	
	Если Элементы.Предметы.ТекущиеДанные <> Неопределено Тогда
		ОткрытьПредметНаКлиенте(Элементы.Предметы.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОткрытьПредметНаКлиенте(ТекущиеДанные)
	
	ТекущаяСтрока = ТекущиеДанные.Предмет;
	
	Если ТипЗнч(ТекущаяСтрока) = Тип("СправочникСсылка.Файлы") Тогда
		
		КакОткрывать = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ДействиеПоДвойномуЩелчкуМыши;
		Если КакОткрывать = "ОткрыватьКарточку" Тогда
			ПоказатьЗначение(,ТекущаяСтрока);
			Возврат;
		КонецЕсли;
		
		ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(
			ТекущаяСтрока,
			Неопределено,
			ЭтаФорма.УникальныйИдентификатор);
		
		РаботаСФайламиКлиент.Открыть(ДанныеФайла, ЭтаФорма.УникальныйИдентификатор);
		
	Иначе
		
		ПоказатьЗначение(,ТекущаяСтрока);
		
	КонецЕсли;
	
	Закрыть();
	
	
КонецПроцедуры

