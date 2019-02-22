&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
			
	КтоИКогдаПрервалПроцесс = Неопределено;
	Параметры.Свойство("КтоИКогдаПрервалПроцесс", КтоИКогдаПрервалПроцесс);
	
	Если ТипЗнч(КтоИКогдаПрервалПроцесс) = Тип("Структура") Тогда
		ДатаПрерывания = КтоИКогдаПрервалПроцесс.Дата;
		ПользовательПрервавшийПроцесс = КтоИКогдаПрервалПроцесс.Пользователь;
		ПричинаПрерывания = КтоИКогдаПрервалПроцесс.ПричинаПрерывания;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Закрыть();
	
КонецПроцедуры


