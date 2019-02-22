
&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	ПараметрПроект = Новый ПараметрКомпоновкиДанных("Проект"); 
	Для Каждого ЭлементНастроек Из Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(ЭлементНастроек) = Тип("ЭлементОтбораКомпоновкиДанных")
		   И ЗначениеЗаполнено(Параметры.Проект) Тогда
 			ЭлементНастроек.ПравоеЗначение = Параметры.Проект;
			ЭлементНастроек.Использование = Истина;
			Прервать;
 		КонецЕсли;
 	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	
	ПараметрПроект = Новый ПараметрКомпоновкиДанных("Проект"); 
	Для Каждого ЭлементНастроек Из Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(ЭлементНастроек) = Тип("ЭлементОтбораКомпоновкиДанных")
		   И ЗначениеЗаполнено(Параметры.Проект) Тогда
 			ЭлементНастроек.ПравоеЗначение = Параметры.Проект;
			ЭлементНастроек.Использование = Истина;
			Прервать;
 		КонецЕсли;
 	КонецЦикла;
	
КонецПроцедуры


