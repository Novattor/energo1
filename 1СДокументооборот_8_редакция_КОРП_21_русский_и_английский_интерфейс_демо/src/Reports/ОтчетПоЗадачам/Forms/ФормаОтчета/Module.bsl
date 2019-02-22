#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПередЗагрузкойВариантаНаСервере(Настройки)
	
	Параметр = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПодчиненныеПодразделения"));
	Если Параметр <> Неопределено
		И Параметр.Использование = Истина Тогда
		
		ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
		
		Руководители = Справочники.ДелегированиеПрав.СписокДелегирующих(ТекущийПользователь);
		Руководители.Добавить(ТекущийПользователь);
		
		Параметр.Значение = 
			Справочники.СтруктураПредприятия.ПодчиненныеПодразделения(Руководители);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	Если ЗначениеЗаполнено(Параметры.Подразделение) Тогда
		
		ПараметрПодразделение = Новый ПараметрКомпоновкиДанных("Подразделение");
		Для Каждого ЭлементНастроек Из Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
			Если ТипЗнч(ЭлементНастроек) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") 
				И ЭлементНастроек.Параметр = ПараметрПодразделение Тогда
			
 				ЭлементНастроек.Значение = Параметры.Подразделение;
				ЭлементНастроек.Использование = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	
	Если ЗначениеЗаполнено(Параметры.Подразделение) Тогда
		
		ПараметрПодразделение = Новый ПараметрКомпоновкиДанных("Подразделение");
		Для Каждого ЭлементНастроек Из Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
			Если ТипЗнч(ЭлементНастроек) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") 
				И ЭлементНастроек.Параметр = ПараметрПодразделение Тогда
			
 				ЭлементНастроек.Значение = Параметры.Подразделение;
				ЭлементНастроек.Использование = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	Если ТипЗнч(Элемент.ТекущаяОбласть) = Тип("РисунокТабличногоДокумента") Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	Если ТипЗнч(Элемент.ТекущаяОбласть) = Тип("РисунокТабличногоДокумента") Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
