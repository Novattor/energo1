#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из ЭтотОбъект Цикл
		Строка.Использовать = Строка.Вариант <> Перечисления.ВариантыВерсионированияОбъектов.НеВерсионировать;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
