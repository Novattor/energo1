
&НаКлиенте
Процедура ПросмотретьСообщение(Команда)
	
	ДанныеФайла = РаботаССВД.ДанныеФайлаДляОткрытия(Объект.Ссылка); 
	Если ДанныеФайла <> Неопределено Тогда
		КомандыРаботыСФайламиКлиент.Открыть(ДанныеФайла);	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	ПервоеСообщениеВСессии = РаботаССВД.НайтиСообщениеСВДПоИдентификатору(Объект.ИдентификаторСессии);
	
    ТекстHTML = РаботаССВД.ПолучитьHTMLПоXDTO(Объект.Ссылка,Объект.ФорматСообщения);
		
КонецПроцедуры

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ДокументооборотПраваДоступаКлиент.ОткрытьФормуПравДоступа(ЭтаФорма);
	
КонецПроцедуры


