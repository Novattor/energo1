
// Печать карточек внутренних, входящих, исходящих документов
// Параметры:
//   ОписаниеКоманды - Структура - См. УправлениеПечатью.ОписаниеКомандыПечати.
//
Функция ПечатьКарточкиДокумента(ОписаниеКоманды) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПараметрКоманды", ОписаниеКоманды.ОбъектыПечати);
	
	ОткрытьФорму(ОписаниеКоманды.МенеджерПечати + ".Форма.ПечатьКарточки", 
		ПараметрыФормы,
		ОписаниеКоманды.ОбъектыПечати);
	
КонецФункции

// Печать карточек мероприятий.
//
// Параметры:
//   ОписаниеКоманды - Структура - См. УправлениеПечатью.ОписаниеКомандыПечати.
//
Функция ПечатьКарточкиМероприятия(ОписаниеКоманды) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПараметрКоманды", ОписаниеКоманды.ОбъектыПечати);
	
	ОткрытьФорму("Справочник.Мероприятия.Форма.ПечатьКарточки", 
		ПараметрыФормы,
		ОписаниеКоманды.ОбъектыПечати);
	
КонецФункции

// Открывает форму печати всех файлов документа
//
// Параметры:
//   ОписаниеКоманды - Структура - См. УправлениеПечатью.ОписаниеКомандыПечати.
//
Функция Напечататьфайлы(ОписаниеКоманды) Экспорт 
	
	ПараметрыФормы = Новый Структура("МассивВладельцев", ОписаниеКоманды.ОбъектыПечати);
	ОткрытьФорму("ОбщаяФорма.НапечататьВсеФайлыДокумента", 
		ПараметрыФормы);
	
КонецФункции

// Печать регистрационного штампа
// Параметры:
//   ОписаниеКоманды - Структура - См. УправлениеПечатью.ОписаниеКомандыПечати.
//
Функция ПечатьРегистрационногоШтампа(ОписаниеКоманды) Экспорт
	
	#Если НЕ ВебКлиент Тогда
		Если ОписаниеКоманды.ОбъектыПечати.Количество() > 1 Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Выполнение данной операции возможно только для одного элемента'; en = 'Performs this operation is possible only for one item'"));
			Возврат Неопределено;
		КонецЕсли;
		
		ПараметрКоманды = ОписаниеКоманды.ОбъектыПечати[0];
		ДанныеССервера = УправлениеПечатьюВызовСервераДокументооборот.ПолучитьРегНомерДокумента(ПараметрКоманды);
		ПараметрыОбработки = Новый Структура;
		ПараметрыОбработки.Вставить("ПараметрКоманды", ПараметрКоманды);
		ПараметрыОбработки.Вставить("ДанныеССервера", ДанныеССервера);
		ОписаниеОповещения = Новый ОписаниеОповещения("ПечатьРегистрационногоШтампаПродолжение", ЭтотОбъект, ПараметрыОбработки);
		
		РегистрационныйНомер = ДанныеССервера.РегистрационныйНомер;
		Если ПустаяСтрока(РегистрационныйНомер) Тогда
			Режим = РежимДиалогаВопрос.ДаНет;
			Текст = НСтр("ru = 'Документ еще не зарегистрирован. Продолжить выполнение операции?'; en = 'Document is not yet registered. Continue with the operation?'");
			ПоказатьВопрос(ОписаниеОповещения, Текст, Режим);
		Иначе
			ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
		КонецЕсли;
		
	#Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'В веб-клиенте выполнение данной операции невозможно'; en = 'It is not possible to perform the operation in web client'"));
	#КонецЕсли	
	
КонецФункции
	
// Продолжение печати регистрационного штампа (асинхронное, после вопроса)
//
Процедура ПечатьРегистрационногоШтампаПродолжение(Ответ, ПараметрыОбработки) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
		
	ПараметрыНастройки = Новый Структура;
	ПараметрыНастройки.Вставить("ЗаголовокФормы", НСтр("ru = 'Положение регистрационного штампа'; en = 'Position of a registration stamp'"));
	ПараметрыНастройки.Вставить("РежимИспользованияНастроек", 0);
	ПараметрыНастройки.Вставить("ЗапросОриентацииСтраницы", Истина);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПечатьРегистрационногоШтампаЗавершение", ЭтотОбъект, ПараметрыОбработки);
	ШтрихкодированиеКлиент.ПолучитьНастройкиШтрихкода(ПараметрыНастройки, ОписаниеОповещения);
	
КонецПроцедуры

// Завершение печати регистрационного штампа (асинхронное, после настройки положения штампа)
//
Процедура ПечатьРегистрационногоШтампаЗавершение(НастройкиПоложенияШК, ПараметрыОбработки) Экспорт
	
	Если НастройкиПоложенияШК = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрКоманды = ПараметрыОбработки.ПараметрКоманды;
	ДанныеССервера = ПараметрыОбработки.ДанныеССервера;
	
	ЗаголовокПриложения = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ЗаголовокПриложения;
	ТабличныйДокумент = УправлениеПечатьюВызовСервераДокументооборот.ПолучитьРегистрационныйШтамп(
		ПараметрКоманды, НастройкиПоложенияШК, ЗаголовокПриложения);	
	
	Если ТабличныйДокумент <> Неопределено Тогда
		ТабличныйДокумент.Напечатать(РежимИспользованияДиалогаПечати.Использовать);
		Если ДанныеССервера.ИспользоватьШК Тогда
			Оповестить("НапечатанШтрихкод", ПараметрКоманды); 
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Печать штрихкода на наклейке
// Параметры:
//   ОписаниеКоманды - Структура - См. УправлениеПечатью.ОписаниеКомандыПечати.
//
Функция ПечатьШтрихкодаНаНаклейке(ОписаниеКоманды) Экспорт
	
	#Если НЕ ВебКлиент Тогда
		Если ОписаниеКоманды.ОбъектыПечати.Количество() > 1 Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Выполнение данной операции возможно только для одного элемента'; en = 'Performs this operation is possible only for one item'"));
			Возврат Неопределено;
		КонецЕсли;
		
		ПараметрКоманды = ОписаниеКоманды.ОбъектыПечати[0];
		
		ЗаголовокПриложения = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ЗаголовокПриложения;
		ТабличныйДокумент = УправлениеПечатьюВызовСервераДокументооборот.ПолучитьШтрихкодНаНаклейке(
			ПараметрКоманды, ЗаголовокПриложения);
		
		Если ТабличныйДокумент <> Неопределено Тогда
			ТабличныйДокумент.Напечатать(РежимИспользованияДиалогаПечати.Использовать);
			Оповестить("НапечатанШтрихкод",ПараметрКоманды); 
		Иначе
			ПоказатьПредупреждение(, НСтр("ru = 'Для шаблонов файлов штрихкод не формируется.'; en = 'Barcodes are not generated for file templates.'"));
		КонецЕсли;
	#Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'В веб-клиенте выполнение данной операции невозможно.'; en = 'It is not possible to perform the operation in web client.'"));
	#КонецЕсли
	
КонецФункции

// Печать штрихкода на странице
// Параметры:
//   ОписаниеКоманды - Структура - См. УправлениеПечатью.ОписаниеКомандыПечати.
//
Функция ПечатьШтрихкодаНаСтранице(ОписаниеКоманды) Экспорт
	
	#Если НЕ ВебКлиент Тогда
		Если ОписаниеКоманды.ОбъектыПечати.Количество() > 1 Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Выполнение данной операции возможно только для одного элемента'; en = 'Performs this operation is possible only for one item'"));
			Возврат Неопределено;
		КонецЕсли;
		
		ПараметрКоманды = ОписаниеКоманды.ОбъектыПечати[0];
		
		ПараметрыНастройки = Новый Структура;
		ПараметрыНастройки.Вставить("ЗаголовокФормы", НСтр("ru = 'Положение штрихкода на странице'; en = 'Position of the barcode on page'"));
		ПараметрыНастройки.Вставить("РежимИспользованияНастроек", 1);
		ПараметрыНастройки.Вставить("ЗапросОриентацииСтраницы", Истина);
		ПараметрыОбработки = Новый Структура;
		ПараметрыОбработки.Вставить("ПараметрКоманды", ПараметрКоманды);
		ОписаниеОповещения = Новый ОписаниеОповещения("ПечатьШтрихкодаНаСтраницеЗавершение", ЭтотОбъект, ПараметрыОбработки);
		ШтрихкодированиеКлиент.ПолучитьНастройкиШтрихкода(ПараметрыНастройки, ОписаниеОповещения);
		
	#Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'В веб-клиенте выполнение данной операции невозможно'; en = 'It is not possible to perform the operation in web client'"));
	#КонецЕсли	
	
КонецФункции
	
Процедура ПечатьШтрихкодаНаСтраницеЗавершение(НастройкиПоложенияШК, ПараметрыОбработки) Экспорт
	
		Если НастройкиПоложенияШК = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрКоманды = ПараметрыОбработки.ПараметрКоманды;
		
		ЗаголовокПриложения = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ЗаголовокПриложения;
		ТабличныйДокумент = УправлениеПечатьюВызовСервераДокументооборот.ПолучитьШтрихкодНаСтранице(
			ПараметрКоманды, НастройкиПоложенияШК, ЗаголовокПриложения);	
		
		Если ТабличныйДокумент <> Неопределено Тогда
			ТабличныйДокумент.Напечатать(РежимИспользованияДиалогаПечати.Использовать);
			Оповестить("НапечатанШтрихкод",ПараметрКоманды); 
		КонецЕсли;
	
КонецПроцедуры


