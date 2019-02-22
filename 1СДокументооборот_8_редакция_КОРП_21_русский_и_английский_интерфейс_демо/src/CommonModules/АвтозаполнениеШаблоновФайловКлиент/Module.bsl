#Если Не ВебКлиент Тогда

#Область ПрограммныйИнтерфейс

//Осуществляет поиск, добавление или удаление полей в шаблоне файле MSWord.
//
// Параметры:
//  ПолноеИмяШаблона - Строка - имя шаблона файла.
//  Расширение - Строка - расширение в нижнем регистре.
//  НастройкиЗамены - Массив - содержит настройки замены полей.
//  ФайлШаблон - СправочникСсылка.Файлы - ссылка на файл шаблон.
//  ИдентификаторФормы - уникальный идентификатор формы
//  МассивПолейДляУдаления - Массив - поля, которые необходимо удалить из файла шаблона.
//  ПоказыватьУведомлениеОЗаписи - Булево - признак показа специальной формы оповещения.
//
//
Процедура ПроверитьНаличиеИДобавитьПоляВФайлеMSWord(ПолноеИмяШаблона, Расширение, НастройкиЗамены, 
	ФайлШаблон, ИдентификаторФормы, МассивПолейДляУдаления, ПоказыватьУведомлениеОЗаписи) Экспорт
	
	НастройкиЗамены.Сортировать("РеквизитТабличнойЧасти, НомерКолонкиТабличнойЧасти");
	КоличествоКолонок = 0;
	Для Каждого Настройка Из НастройкиЗамены Цикл 
		Если Настройка.РеквизитТабличнойЧасти Тогда 
			КоличествоКолонок = КоличествоКолонок + 1;
		КонецЕсли;
	КонецЦикла;
	
	ДвоичныеДанныеФайла = АвтозаполнениеШаблоновФайловСервер.ПолучитьДвоичныеДанныеФайла(ФайлШаблон);
	ИмяФайла = ФайловыеФункцииКлиентСервер.ПолучитьИмяСРасширением(ПолноеИмяШаблона, Расширение);
	
	ВременнаяПапка = ПолучитьИмяВременногоФайла("");
	СоздатьКаталог(ВременнаяПапка);
	ВременнаяПапка = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ВременнаяПапка);
	ИмяФайлаСПутем = ВременнаяПапка + ИмяФайла;
	
	ДвоичныеДанныеФайла.Записать(ИмяФайлаСПутем);
	
	Попытка
		WordApp = Новый COMОбъект("Word.Application");
		Док = WordApp.Documents.Add(ИмяФайлаСПутем); 
	Исключение
		УдалитьФайлы(ИмяФайлаСПутем);
		ПоказатьПредупреждение(, НСтр("ru = 'Ошибка работы с приложением MS Word. 
		|Необходимо проверить правильность установки либо использовать более новую версию приложения.';
		|en = 'Application error when working with MS Word. 
		|You should verify that the installation or use a newer version of the application.'"));
		Возврат;
	КонецПопытки;
	
	Док.Activate();
	Text = WordApp.Selection;
	Text.WholeStory();
	Text.MoveUp(, 1);
	
	КоличествоТаблиц = Док.Tables.Count;
	
	ЕстьДобавленныеПоля = Ложь; ЕстьУдаленныеПоля = Ложь;
	НашаТаблица = Неопределено; МассивСуществующихПолей = Новый Массив;
	Для Каждого НастройкаЗамены Из НастройкиЗамены Цикл
		Если ПустаяСтрока(НастройкаЗамены.ТермДляЗамены) Тогда
			Продолжить;
		КонецЕсли;
		
		ПолеНайдено = Ложь;
		ИмяРеквизита = СтрЗаменить(Лев(НастройкаЗамены.ТермДляЗамены, 20), " ", "_");
		Попытка
			Если НастройкаЗамены.РеквизитТабличнойЧасти Тогда 
				Если МассивСуществующихПолей.Количество() = 0 Тогда 
					Для Каждого Поле Из Док.FormFields Цикл 
						МассивСуществующихПолей.Добавить(Поле.Name);
					КонецЦикла;
				КонецЕсли;
				
				Если НашаТаблица = Неопределено Тогда 
					Для Ит = 1 По КоличествоТаблиц Цикл 
						Если Док.Tables(Ит).Rows.Count > 1 Тогда 
							
							Для Ном = 1 По Док.Tables(Ит).Columns.Count Цикл
								Попытка
									Если Док.Bookmarks(ИмяРеквизита).Range.BookmarkID = 
										Док.Tables(Ит).Cell(2, Ном).Range.Fields(1).Result.BookmarkID Тогда 
										
										НашаТаблица = Док.Tables(Ит);
										ПолеНайдено = Истина;
										Прервать;
									КонецЕсли;
								Исключение
								КонецПопытки;
							КонецЦикла;
						КонецЕсли;
						
						Если НашаТаблица <> Неопределено Тогда 
							// Нашли нужную таблицу
							Прервать;
						КонецЕсли;
					КонецЦикла;
				Иначе 
					Для Ном = 1 По НашаТаблица.Columns.Count Цикл
						Попытка
							Если Док.Bookmarks(ИмяРеквизита).Range.BookmarkID = 
								НашаТаблица.Cell(2, Ном).Range.Fields(1).Result.BookmarkID Тогда 
								ПолеНайдено = Истина;
								Прервать;
							КонецЕсли;
						Исключение
						КонецПопытки;
					КонецЦикла;
				КонецЕсли;
			Иначе 
				Для Каждого Field из Док.FormFields Цикл
					Если Field.Name = ИмяРеквизита Тогда
						ПолеНайдено = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		Исключение
		КонецПопытки;
		
		Попытка
			Если Не ПолеНайдено Тогда 
				Если НастройкаЗамены.РеквизитТабличнойЧасти Тогда
					Если НашаТаблица = Неопределено Тогда
						MyRange = Text.Range();
						//Создаем новую таблицу
						НашаТаблица = Док.Tables.add(MyRange, 2, КоличествоКолонок, 1, 2);
						НомерТаблицы = Док.Tables.Count;
						НашаТаблица.AutoFormat(16);
						
						Если Расширение = "docx" Тогда 
							Попытка
								НашаТаблица.Title = "Товары_Документооборот";
							Исключение
							КонецПопытки;
						КонецЕсли;
					КонецЕсли;
					
					КоличествоСтрокТаблицы = НашаТаблица.Rows.Count;
					СчетчикЦикла = 1;
					Пока КоличествоСтрокТаблицы > 0 Цикл 
						
						Если НашаТаблица.Columns.Count < НастройкаЗамены.НомерКолонкиТабличнойЧасти Тогда 
							НашаТаблица.Columns.Add();
						КонецЕсли;
						
						Если СчетчикЦикла = 1 Тогда 
							НашаТаблица.Cell(СчетчикЦикла, НастройкаЗамены.НомерКолонкиТабличнойЧасти).Range.Text = 
								СокрЛП(НастройкаЗамены.ОписаниеПоляЗамены);
							НашаТаблица.Cell(СчетчикЦикла, НастройкаЗамены.НомерКолонкиТабличнойЧасти).Range.Font.Bold = 1;
						Иначе 
							MyRange = НашаТаблица.Cell(СчетчикЦикла, НастройкаЗамены.НомерКолонкиТабличнойЧасти).Range;
							MyRange.Text = "";
							ПолеТаблицы = Неопределено;
							ПолеТаблицы = Док.FormFields.Add(MyRange, 70);
							
							НовоеПоле = Неопределено;
							Если МассивСуществующихПолей.Количество() > 0 Тогда 
								Для Каждого Поле Из Док.FormFields Цикл 
									Если МассивСуществующихПолей.Найти(Поле.Name) = Неопределено Тогда 
										НовоеПоле = Поле;
										Прервать;
									КонецЕсли;
								КонецЦикла;
							КонецЕсли;
							
							Если НовоеПоле <> Неопределено И ПолеТаблицы.Name <> НовоеПоле.Name Тогда 
								ПолеТаблицы = НовоеПоле;
							КонецЕсли;
							
							ИмяРеквизита = СтрЗаменить(Лев(НастройкаЗамены.ТермДляЗамены, 20), " ", "_");
							ПолеТаблицы.Name = ИмяРеквизита;
							ПолеТаблицы.Result = НастройкаЗамены.ОписаниеПоляЗамены;
							ПолеТаблицы.TextInput.Default = НастройкаЗамены.ОписаниеПоляЗамены;
							МассивСуществующихПолей.Добавить(ПолеТаблицы.Name);
						КонецЕсли;
						
						КоличествоСтрокТаблицы = КоличествоСтрокТаблицы - 1;
						СчетчикЦикла = СчетчикЦикла + 1;
					КонецЦикла;
					
				Иначе 
					MyRange = Text.Range();
					НовоеПоле = Док.FormFields.Add(MyRange, 70);
					ИмяРеквизита = СтрЗаменить(Лев(НастройкаЗамены.ТермДляЗамены, 20), " ", "_");
					НовоеПоле.Name = ИмяРеквизита;
					НовоеПоле.Result = НастройкаЗамены.ОписаниеПоляЗамены;
					НовоеПоле.TextInput.Default = НастройкаЗамены.ОписаниеПоляЗамены;
					Text.TypeText(Символы.ВК);
				КонецЕсли;
				
				ЕстьДобавленныеПоля = Истина;
			КонецЕсли;
		Исключение
		КонецПопытки;
	КонецЦикла;
	
	Для Каждого ЭлементМассива Из МассивПолейДляУдаления Цикл
		ИмяРеквизита = ЭлементМассива.ПолеУдаления;
		РеквизитТабличнойЧасти = ЭлементМассива.РеквизитТабличнойЧасти;
		
		Попытка
			Если РеквизитТабличнойЧасти Тогда 
				Если НашаТаблица = Неопределено Тогда 
					Для Ит = 1 По КоличествоТаблиц Цикл 
						Если Док.Tables(Ит).Rows.Count > 1 Тогда 
							
							Для Ном = 1 По Док.Tables(Ит).Columns.Count Цикл
								Попытка
									Если Док.Bookmarks(ИмяРеквизита).Range.BookmarkID = 
										Док.Tables(Ит).Cell(2, Ном).Range.Fields(1).Result.BookmarkID Тогда 
										
										НашаТаблица = Док.Tables(Ит);
										НашаТаблица.Cell(1, Ном).delete();
										НашаТаблица.Cell(2, Ном).delete();
										ЕстьУдаленныеПоля = Истина;
										Прервать;
									КонецЕсли;
								Исключение
								КонецПопытки;
							КонецЦикла;
						КонецЕсли;
						
						Если НашаТаблица <> Неопределено Тогда 
							// Нашли нужную таблицу
							Прервать;
						КонецЕсли;
					КонецЦикла;
				Иначе 
					Для Ном = 1 По НашаТаблица.Columns.Count Цикл
						Попытка
							Если Док.Bookmarks(ИмяРеквизита).Range.BookmarkID = 
								НашаТаблица.Cell(2, Ном).Range.Fields(1).Result.BookmarkID Тогда 
								НашаТаблица.Cell(1, Ном).delete();
								НашаТаблица.Cell(2, Ном).delete();
								ЕстьУдаленныеПоля = Истина;
								Прервать;
							КонецЕсли;
						Исключение
						КонецПопытки;
					КонецЦикла;
				КонецЕсли;
			Иначе 
				Для Каждого Field Из Док.FormFields Цикл
					Если Field.Name = ИмяРеквизита Тогда
						Field.delete();
						ЕстьУдаленныеПоля = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		Исключение
		КонецПопытки;
		
	КонецЦикла;
	
	Build = WordApp.Build;
	Если Найти(Build, "12.") = 1 Или Найти(Build, "14.") = 1
		Или Найти(Build, "15.") = 1 Тогда
		Если Расширение = "docx" Тогда
			Док.SaveAs(ИмяФайлаСПутем, 12);
		Иначе
			Док.SaveAs(ИмяФайлаСПутем, 0);
		КонецЕсли;
	Иначе
		Док.SaveAs(ИмяФайлаСПутем);
	КонецЕсли;
	
	Док.Close(); 
	WordApp.Quit();
	WordApp = Неопределено;
	
	Если ЕстьДобавленныеПоля Или ЕстьУдаленныеПоля Тогда 
		
		ТекстОшибки = "";
		ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайла(ФайлШаблон);
		МожноЗанятьФайл = РаботаСФайламиКлиентСервер.МожноЛиЗанятьФайл(
			ДанныеФайла,
			ТекстОшибки);
			
		Если Не МожноЗанятьФайл Тогда
			ПоказатьПредупреждение(, ТекстОшибки);
			Возврат;
		КонецЕсли;
		
		ТекстОшибки = "";
		ДатаЗаема = ТекущаяДата();
		ФайлЗанят = РаботаСФайламиВызовСервера.ЗанятьФайл(ДанныеФайла, ТекстОшибки, 
			ДатаЗаема, ИдентификаторФормы);
		Если Не ФайлЗанят Тогда
			ПоказатьПредупреждение(, ТекстОшибки);
			Возврат;
		КонецЕсли;
		
		Файл = Новый Файл(ИмяФайлаСПутем);
		
		Обработчик = Новый ОписаниеОповещения("СохранитьФайл", ЭтотОбъект, Новый Структура);
		
		УниверсальноеВремяИзмененияНаДиске = Файл.ПолучитьУниверсальноеВремяИзменения();
		РазмерНаДиске = Файл.Размер();
			
		ПараметрыВыполнения = Новый Структура;
		ПараметрыВыполнения.Вставить("ОбработчикРезультата", Неопределено);
		ПараметрыВыполнения.Вставить("ПараметрКоманды", ФайлШаблон);
			
		ПараметрыОбработчика = РаботаСФайламиКлиент.ПараметрыОбновленияФайла(
			Обработчик, ФайлШаблон, ИдентификаторФормы);
			
		ПараметрыОбработчика.Вставить("ПереданныйПолныйПутьКФайлу", ИмяФайлаСПутем);
		ПараметрыОбработчика.Вставить("СоздатьНовуюВерсию", Истина);
			ПараметрыОбработчика.Вставить("ХранитьВерсии", Истина);
			
		РаботаСФайламиКлиент.ЗакончитьРедактирование(ПараметрыОбработчика);
		
		ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(ФайлШаблон,, ИдентификаторФормы);
		
		СтруктураОбработчика = Новый Структура;
		СтруктураОбработчика.Вставить("Обработчик", Обработчик);
		СтруктураОбработчика.Вставить("ДанныеФайла", ДанныеФайла);
		СтруктураОбработчика.Вставить("ИдентификаторФормы", ИдентификаторФормы);
		ОбработчикПредупреждения = Новый ОписаниеОповещения("ОткрытьФайлНаРедактирование", ЭтотОбъект, 
			СтруктураОбработчика);
			
		Если ПоказыватьУведомлениеОЗаписи Тогда 
			
			ПараметрыФормы = Новый Структура;
			Если ЕстьДобавленныеПоля Тогда 
				ПараметрыФормы.Вставить("Текст", 
					НСтр("ru = '<BODY>
                          |В файл добавлены новые поля.
                          |Расставьте их в нужные места документа и при необходимости поменяйте оформление.
                          |</BODY>';
                          |en = '<BODY>
                          |New fields have been added to the file.
                          |Arrange them in the appropriate places in the document and, if necessary, change the design.
                          |</BODY>'"));
			Иначе 
				ПараметрыФормы.Вставить("Текст", 
					НСтр("ru = '<BODY>
					|Из файла удалены некоторые поля.
					|Проверьте корректность документа.
					|</BODY>';
					|en = '<BODY>
					|Some fields have been removed from the file.
					|Verify the validity of the document.
					|</BODY>'"));
			КонецЕсли;
			
			ПараметрыФормы.Вставить("БольшеНеПоказывать", Истина);
			ПараметрыФормы.Вставить("КлючОбъекта", "ВидыДокументов");
			ПараметрыФормы.Вставить("КлючНастроек", "ПоказыватьУведомлениеОПереносеПолейВФайл");
			
			ОткрытьФорму("ОбщаяФорма.Подсказка", ПараметрыФормы,,,,,
				ОбработчикПредупреждения, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		Иначе 
			ВыполнитьОбработкуОповещения(ОбработчикПредупреждения, КодВозвратаДиалога.ОК);
		КонецЕсли;
		
	КонецЕсли;
	
	УдалитьФайлы(ВременнаяПапка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОткрытьФайлНаРедактирование(Результат, Параметры) Экспорт 
	
	РаботаСФайламиКлиент.РедактироватьФайл(Параметры.Обработчик, Параметры.ДанныеФайла, Параметры.ИдентификаторФормы);
	
КонецПроцедуры

Процедура СохранитьФайл(Результат, Параметры) Экспорт 
	
	Если Результат = Истина Тогда
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("Событие", "ДанныеФайлаИзменены");
		ПараметрыОповещения.Вставить("Файл", Параметры.ДанныеФайла.Ссылка);
		ПараметрыОповещения.Вставить("Владелец", Параметры.ДанныеФайла.Владелец);
		ПараметрыОповещения.Вставить("ЕстьЗанятыеФайлы", Неопределено);
		ПараметрыОповещения.Вставить("ИдентификаторРодительскойФормы", Неопределено);
		
		Оповестить("Запись_Файл", 
			ПараметрыОповещения,
			Параметры.ДанныеФайла.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
