#Область ПрограммныйИнтерфейс

// Возвращает виды доступа, для которых используется уровень доступа "Регистрация".
// 
// Возвращаемое значение - Массив.
// 
Функция ВидыДоступаИспользующиеРегистрацию() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(ПредопределенноеЗначение("ПланВидовХарактеристик.ВидыДоступа.ВидыВнутреннихДокументов"));
	Результат.Добавить(ПредопределенноеЗначение("ПланВидовХарактеристик.ВидыДоступа.ВидыВходящихДокументов"));
	Результат.Добавить(ПредопределенноеЗначение("ПланВидовХарактеристик.ВидыДоступа.ВидыИсходящихДокументов"));
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
