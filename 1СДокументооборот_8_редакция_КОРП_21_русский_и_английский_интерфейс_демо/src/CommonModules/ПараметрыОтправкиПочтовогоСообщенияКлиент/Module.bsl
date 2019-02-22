// Шифрует вложения, указанные в структуре ПараметрыОтправки.
//
Функция ЗашифроватьВложения(ПараметрыОтправки, Сообщение, УникальныйИдентификатор) Экспорт
	
	Если Не ПараметрыОтправки.Шифровать Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ПараметрыОтправки.ОтпечаткиСертификатовШифрования.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
		
	Возврат Истина;
	
КонецФункции


