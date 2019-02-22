
&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОчиститьСообщения();
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	МассивСтруктур = Новый Массив;
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиСравненияФайлов");
	Элемент.Вставить("Настройка", "СпособСравненияВерсийФайлов");
	Элемент.Вставить("Значение", СпособСравненияВерсийФайлов);
	МассивСтруктур.Добавить(Элемент);
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьМассивИОбновитьПовторноИспользуемыеЗначения(МассивСтруктур);
	
	РезультатВыбора = КодВозвратаДиалога.ОК;
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры


