
&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПараметрСрокИстекает = Новый ПараметрКомпоновкиДанных("ПоказыватьДокументыСрокИстекает");
	Для Каждого ЭлементНастройки Из Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(ЭлементНастройки) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") 
		   И ЭлементНастройки.Параметр = ПараметрСрокИстекает
		   И ЭлементНастройки.Использование = Ложь Тогда 
		   
		   ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		    		НСтр("ru = 'Не указан параметр ""Показывать договоры, срок которых истекает""'; en = 'Parameter ""Show contracts with expiring period of validity"" is not specified'"),,
		    		"Отчет.КомпоновщикНастроек.ПользовательскиеНастройки",,Отказ);
		КонецЕсли;   
	КонецЦикла;
	
	ПараметрДействующие = Новый ПараметрКомпоновкиДанных("Действующие");
	Для Каждого ЭлементНастройки Из Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(ЭлементНастройки) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") 
		   И ЭлементНастройки.Параметр = ПараметрДействующие
		   И ЭлементНастройки.Использование = Ложь Тогда 
		   
		   ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		    		НСтр("ru = 'Не указан параметр ""Показывать договоры""'; en = 'Parameter ""Show contracts"" is not specified'"),,
		    		"Отчет.КомпоновщикНастроек.ПользовательскиеНастройки",,Отказ);
		КонецЕсли;   
	КонецЦикла;
	
	ПараметрВалюта = Новый ПараметрКомпоновкиДанных("Валюта");
	Для Каждого ЭлементНастройки Из Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(ЭлементНастройки) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") 
		   И ЭлементНастройки.Параметр = ПараметрВалюта
		   И ЭлементНастройки.Использование = Ложь Тогда 
		   
		   ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		    		НСтр("ru = 'Не указан параметр ""Валюта""'; en = 'Parameter ""Currency"" is not specified'"),,
		    		"Отчет.КомпоновщикНастроек.ПользовательскиеНастройки",,Отказ);
		КонецЕсли;   
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
 	ПараметрВалюта = Новый ПараметрКомпоновкиДанных("Валюта"); 
	Для Каждого ЭлементНастроек Из Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если (ТипЗнч(ЭлементНастроек) =  Тип("ЗначениеПараметраНастроекКомпоновкиДанных"))
		   И (ЭлементНастроек.Параметр = ПараметрВалюта) 
		   И (Не ЗначениеЗаполнено(ЭлементНастроек.Значение)) Тогда
 			ЭлементНастроек.Значение = Константы.ОсновнаяВалюта.Получить();
			ЭлементНастроек.Использование = Истина;
 		КонецЕсли;	
 	КонецЦикла;	
	
КонецПроцедуры

