Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		Если Не ЗначениеЗаполнено(Владелец) Тогда
			Владелец = Пользователи.ТекущийПользователь();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


