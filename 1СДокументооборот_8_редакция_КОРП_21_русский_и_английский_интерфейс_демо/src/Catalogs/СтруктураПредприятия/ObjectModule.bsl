
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Обновление адресной книги
Перем ОбновитьДанныеСтруктурыПредприятияВАдреснойКниге;
Перем ОбновитьДанныеОтображенияСтруктурыПредприятияВАдреснойКниге;
Перем ОбновитьСловаПоискаПоСтруктуреПредприятияВАдреснойКниге;
Перем ОбновитьДоступностьВПоискеПоСтруктуреПредприятия;

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	РеквизитыПодразделенияПоСсылке = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Ссылка, "Руководитель, Родитель, ПометкаУдаления, Наименование");
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("СтарыйРуководитель", РеквизитыПодразделенияПоСсылке.Руководитель);
	ДополнительныеСвойства.Вставить("СтарыйРодитель", РеквизитыПодразделенияПоСсылке.Родитель);
	ДополнительныеСвойства.Вставить("СтараяПометкаУдаления", РеквизитыПодразделенияПоСсылке.ПометкаУдаления);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Обновление адресной книги
	ОбновитьДанныеСтруктурыПредприятияВАдреснойКниге = Ложь;
	ОбновитьДанныеОтображенияСтруктурыПредприятияВАдреснойКниге = Ложь;
	ОбновитьСловаПоискаПоСтруктуреПредприятияВАдреснойКниге = Ложь;
	ОбновитьДоступностьВПоискеПоСтруктуреПредприятия = Ложь;
	
	Если ЭтоНовый() Тогда
		ОбновитьДанныеСтруктурыПредприятияВАдреснойКниге = Истина;
		ОбновитьСловаПоискаПоСтруктуреПредприятияВАдреснойКниге = Истина;
	Иначе
		Если РеквизитыПодразделенияПоСсылке.Родитель <> Родитель Тогда
			ОбновитьДанныеСтруктурыПредприятияВАдреснойКниге = Истина;
		КонецЕсли;
		Если РеквизитыПодразделенияПоСсылке.ПометкаУдаления <> ПометкаУдаления Тогда
			ОбновитьДанныеСтруктурыПредприятияВАдреснойКниге = Истина;
			ОбновитьДанныеОтображенияСтруктурыПредприятияВАдреснойКниге = Истина;
			ОбновитьДоступностьВПоискеПоСтруктуреПредприятия = Истина;
		КонецЕсли;
		Если РеквизитыПодразделенияПоСсылке.Наименование <> Наименование Тогда
			ОбновитьСловаПоискаПоСтруктуреПредприятияВАдреснойКниге = Истина;
			ОбновитьДанныеОтображенияСтруктурыПредприятияВАдреснойКниге = Истина;
			ОбновитьДанныеСтруктурыПредприятияВАдреснойКниге = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка
		И ЗначениеЗаполнено(ОбменДанными.Отправитель)
		И ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(ОбменДанными.Отправитель) Тогда
		Возврат;
	КонецЕсли;
	
	// Общий обработчик для всех разрезов доступа.
	ДокументооборотПраваДоступа.ПриЗаписиРазрезаДоступа(ЭтотОбъект, Отказ);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Заполнение разрешений по умолчанию.
	РегистрыСведений.РазрешенияДоступаОбщие.ЗаполнитьРазрешенияПоПодразделениям(ЭтотОбъект.Ссылка);
	
	Если Руководитель <> ДополнительныеСвойства.СтарыйРуководитель Тогда
		УправлениеДоступомВызовСервераДокументооборот.ЗаполнитьПодчиненностьПользователейПоПодразделению(Ссылка);
	КонецЕсли;
	
	Если ДополнительныеСвойства.ЭтоНовый Тогда
		РегистрыСведений.ПодчиненностьПодразделений.СоздатьТривиальнуюЗапись(Ссылка);
	КонецЕсли;
	
	Если Родитель <> ДополнительныеСвойства.СтарыйРодитель Тогда
		УправлениеДоступомВызовСервераДокументооборот.ЗаполнитьСоставСотрудниковРодительскихПодразделений(ДополнительныеСвойства.СтарыйРодитель);
		УправлениеДоступомВызовСервераДокументооборот.ЗаполнитьСоставСотрудниковРодительскихПодразделений(Родитель);
		РегистрыСведений.ПодчиненностьПодразделений.ОбновитьДанныеВышестоящегоПодразделения(ДополнительныеСвойства.СтарыйРодитель);
		РегистрыСведений.ПодчиненностьПодразделений.ОбновитьДанныеВышестоящегоПодразделения(Родитель);
	КонецЕсли;
	
	ОбработанныеКонтейнеры = Новый Массив;
	Если ПометкаУдаления <> ДополнительныеСвойства.СтараяПометкаУдаления Тогда
		РегистрыСведений.ПользователиВКонтейнерах.ОбновитьДанныеКонтейнера(Ссылка, ОбработанныеКонтейнеры);
	КонецЕсли;
		
	Если Родитель <> ДополнительныеСвойства.СтарыйРодитель Тогда
		РегистрыСведений.ПользователиВКонтейнерах.ОбновитьДанныеКонтейнера(Родитель, ОбработанныеКонтейнеры);
		РегистрыСведений.ПользователиВКонтейнерах.ОбновитьДанныеКонтейнера(ДополнительныеСвойства.СтарыйРодитель, ОбработанныеКонтейнеры);
	КонецЕсли;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	// Обновление адресной книги
	Если ОбновитьДанныеСтруктурыПредприятияВАдреснойКниге Тогда
		Справочники.АдреснаяКнига.ОбновитьДанныеОбъекта(
			Ссылка, Родитель, Справочники.АдреснаяКнига.ПоСтруктуреПредприятия);
	КонецЕсли;
	Если ОбновитьДанныеОтображенияСтруктурыПредприятияВАдреснойКниге Тогда
		Справочники.АдреснаяКнига.ОбновитьДанныеОтображенияПодчиненногоОбъекта(Ссылка);
	КонецЕсли;
	Если ОбновитьСловаПоискаПоСтруктуреПредприятияВАдреснойКниге Тогда
		РегистрыСведений.ПоискВАдреснойКниге.ОбновитьСловаПоискаПоПодразделению(ЭтотОбъект);
	КонецЕсли;
	Если ОбновитьДоступностьВПоискеПоСтруктуреПредприятия Тогда
		РегистрыСведений.ПоискВАдреснойКниге.ОбновитьДоступностьВПоиске(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
