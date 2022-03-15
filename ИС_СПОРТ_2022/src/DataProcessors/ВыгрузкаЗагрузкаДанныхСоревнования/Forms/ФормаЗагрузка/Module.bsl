#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДокументСоревнование  = Параметры.ДокументСоревнование;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	НомерСтроки   = 8;
	КодСпортсмена = 2;
	
КонецПроцедуры

#КонецОбласти

#Область ЧтениеФайла

&НаКлиенте
Процедура ФайлНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Отказ = Ложь;
	Для Каждого элемент_ Из Элементы.Настройки.ПодчиненныеЭлементы Цикл
		Если элемент_.Вид = ВидПоляФормы.ПолеВвода Тогда
			Если ЭтотОбъект[элемент_.Имя] = 0 Тогда
				Отказ = Истина;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("В обязательных полях не указано значение поля!",,элемент_.Имя);
			КонецЕсли;	
		КонецЕсли;	
	КонецЦикла;	
	
	Если Отказ Тогда
		Возврат
	КонецЕсли;	
	
	Состояние("Выполняется чтение файла....");
	
	СтандартнаяОбработка = Ложь;
    ДополнительныеПараметры = Новый Структура;
    ДополнительныеПараметры.Вставить("ВыборЗавершение", Новый ОписаниеОповещения("ВложениеВыборЗавершение", ЭтотОбъект));
    Оповещение = Новый ОписаниеОповещения("НачатьПодключениеРасширенияРаботыСФайламиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
    НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьПодключениеРасширенияРаботыСФайламиЗавершение(Подключено, ДополнительныеПараметры) Экспорт
    Если Не Подключено Тогда
        Оповещение = Новый ОписаниеОповещения("НачатьУстановкуРасширенияРаботыСФайламиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
        ТекстСообщения = НСтр("ru='Для продолжении работы необходимо установить расширение для веб-клиента ""1С:Предприятие"". Установить?'");
        ПоказатьВопрос(Оповещение, ТекстСообщения, РежимДиалогаВопрос.ДаНет); 
    Иначе
        ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ВыборЗавершение);
    КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НачатьУстановкуРасширенияРаботыСФайламиЗавершение(Результат, ДополнительныеПараметры) Экспорт
    Если Результат = КодВозвратаДиалога.Да Тогда
        НачатьУстановкуРасширенияРаботыСФайлами(ДополнительныеПараметры.ВыборЗавершение);
    КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВложениеВыборЗавершение(ДополнительныеПараметры, ДопПараметр) Экспорт
    НачатьПолучениеКаталогаДокументов(Новый ОписаниеОповещения("КаталогДокументовЗавершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура КаталогДокументовЗавершение(ИмяКаталогаДокументов, ДополнительныеПараметры) Экспорт 
    Диалог = новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
    ОписаниеОп=новый ОписаниеОповещения("ВыбранФайл", ЭтотОбъект);
    Диалог.Показать(ОписаниеОп);
КонецПроцедуры 

&НаКлиенте
Процедура ВыбранФайл(ВыбранныеФайлы,ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		ПоказатьПредупреждение( , "Файл не выбран!");
		Возврат;
	КонецЕсли;
	ПомещаемыеФайлы = Новый Массив;

	
	Если ВыбранныеФайлы.Количество() Тогда
		Для Каждого ИмяФайла Из ВыбранныеФайлы Цикл
				ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ИмяФайла));
				Файл = ИмяФайла;
			КонецЦикла;
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьИПередатьФайлыНаСерверЗавершение", ЭтаФорма);
		НачатьПомещениеФайлов(ОписаниеОповещения,ПомещаемыеФайлы,, Ложь);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИПередатьФайлыНаСерверЗавершение(Знач МассивФайлов,Знач ВыбранноеИмяФайла)  Экспорт
	
	Состояние("Выполняется чтение файла...");
	
	Если МассивФайлов.Количество()>0 Тогда
		
		Для Каждого ИмяФайла_ Из МассивФайлов Цикл
			ПутьКФайлу 					= ИмяФайла_.ПолноеИмя;
			АдресВоВременномХранилице 	= ИмяФайла_.Хранение;
			РасширениеФайла 			= Прав(ИмяФайла_.Имя,СтрДлина(ИмяФайла_.Имя)-(СтрНайти(ИмяФайла_.Имя,".",НаправлениеПоиска.СКонца,,1)));;	
		КонецЦикла;
		
		ЗагрузитьДанныеНаСервере();
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Данные прочитаны.");
	
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеНаСервере()
					
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(РасширениеФайла);
	Если НЕ ЗначениеЗаполнено(АдресВоВременномХранилице) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка чтения файла " + ПутьКФайлу);
		Возврат;
	КонецЕсли; 
	
	ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(АдресВоВременномХранилице);
	ДвоичныеДанныеФайла.Записать(ИмяВременногоФайла);	
	
    ТабличныйДокументЗагрузка.Очистить();
	ТабличныйДокументЗагрузка.Прочитать(ИмяВременногоФайла);
	
	ТаблицаИтог.Очистить();
	таблицаАнализаДанных = ТаблицаИтог.Выгрузить();
	таблицаАнализаДанных.Колонки.Добавить("КодВозрастнойГруппы", Новый ОписаниеТипов("Строка"));
	таблицаАнализаДанных.Колонки.Добавить("Индекс"             , Новый ОписаниеТипов("Число"));
	
	ТаблицаНефинишировавшихУчастников.Очистить();
	НомерСтрокиНеСтартовали.Сортировать("НомерСтроки Возр");
	ЗагрузкаНеФинишировавшихСпортсменов = ?(НомерСтрокиНеСтартовали.Количество() = 0 , Неопределено, НомерСтрокиНеСтартовали[0].НомерСтроки);
		
	ИндексСтроки = 0;
	ВозрастнаяГруппа_ = "";
	Для ИндексОбласти = НомерСтроки По ТабличныйДокументЗагрузка.ВысотаТаблицы Цикл
				
		Если НЕ ЗагрузкаНеФинишировавшихСпортсменов = Неопределено Тогда
			Если ИндексОбласти = ЗагрузкаНеФинишировавшихСпортсменов Тогда
				Прервать;
			КонецЕсли;	
		КонецЕсли;	
		
		Если НЕ ЗначениеЗаполнено(ТабличныйДокументЗагрузка.Область("R" + СокрЛП(ИндексОбласти) + "C" + СокрЛП(КодСпортсмена)).Текст) Тогда 
			Продолжить;
		КонецЕсли;
		
		строкаДанных                     = таблицаАнализаДанных.Добавить();
		строкаДанных.Индекс              = ИндексСтроки;
		строкаДанных.КодВозрастнойГруппы = ВозрастнаяГруппа_;
		строкаДанных.GUIDСпортсмена      = ТабличныйДокументЗагрузка.Область("R" + СокрЛП(ИндексОбласти) + "C" + СокрЛП(КодСпортсмена)).Текст;
		Попытка
			строкаДанных.СтартовыйНомер  = ТабличныйДокументЗагрузка.Область("R" + СокрЛП(ИндексОбласти) + "C" + СокрЛП(СтартовыйНомер)).Текст;
		Исключение
			// {Рарус adilas #1.0.0.2 -SonarQube 2021.04.23
			ЗаписьЖурналаРегистрации(НСтр("ru = 'ЗагрузитьДанныеНаСервере()'"), УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			// }Рарус adilas #1.0.0.2 -SonarQube 2021.04.23
		КонецПопытки;
		строкаДанных.Параметр1           = ЗаменитьСимволВСтрокеРезультата(ТабличныйДокументЗагрузка.Область("R" + СокрЛП(ИндексОбласти) + "C" + СокрЛП(Параметр1)).Текст);
		строкаДанных.Параметр2           = ЗаменитьСимволВСтрокеРезультата(ТабличныйДокументЗагрузка.Область("R" + СокрЛП(ИндексОбласти) + "C" + СокрЛП(Параметр2)).Текст);
		строкаДанных.ИтоговыйРезультат   = ЗаменитьСимволВСтрокеРезультата(ТабличныйДокументЗагрузка.Область("R" + СокрЛП(ИндексОбласти) + "C" + СокрЛП(Результат)).Текст);
		строкаДанных.Отставание          = ЗаменитьСимволВСтрокеРезультата(ТабличныйДокументЗагрузка.Область("R" + СокрЛП(ИндексОбласти) + "C" + СокрЛП(Отставание)).Текст);
		Попытка
			строкаДанных.Место           = ТабличныйДокументЗагрузка.Область("R" + СокрЛП(ИндексОбласти) + "C" + СокрЛП(Место)).Текст;
		Исключение
			// {Рарус adilas #1.0.0.2 -SonarQube 2021.04.23
			ЗаписьЖурналаРегистрации(НСтр("ru = 'ЗагрузитьДанныеНаСервере()'"), УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			// }Рарус adilas #1.0.0.2 -SonarQube 2021.04.23
		КонецПопытки;
		
		ИндексСтроки = ИндексСтроки + 1;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаДанных"        ,таблицаАнализаДанных);
	Запрос.УстановитьПараметр("ДокументСоревнование" , ДокументСоревнование);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТаблицаДанных.Индекс КАК Индекс,
	               |	ВЫРАЗИТЬ(ТаблицаДанных.КодВозрастнойГруппы КАК СТРОКА(150)) КАК КодВозрастнойГруппы,
	               |	ВЫРАЗИТЬ(ТаблицаДанных.GUIDСпортсмена КАК СТРОКА(32)) КАК GUID
	               |ПОМЕСТИТЬ ВТ_ТаблицаДанных
	               |ИЗ
	               |	&ТаблицаДанных КАК ТаблицаДанных
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_ТаблицаДанных.Индекс КАК Индекс,
	               |	СоставУчастников.Спортсмен КАК Спортсмен,
	               |	СоставУчастников.МеждународнаяВозрастнаяГруппа КАК МеждународнаяВозрастнаяГруппа
	               |ИЗ
	               |	ВТ_ТаблицаДанных КАК ВТ_ТаблицаДанных
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Соревнование.СоставУчастников КАК СоставУчастников
	               |		ПО ВТ_ТаблицаДанных.GUID = СоставУчастников.GUIDУчастника
	               |			И (СоставУчастников.Ссылка = &ДокументСоревнование)";
	
	
	ТаблицаИтог.Очистить();
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		строкаИтог = ТаблицаИтог.Добавить();
		ЗаполнитьЗначенияСвойств(строкаИтог, таблицаАнализаДанных[Выборка.Индекс]);
		ЗаполнитьЗначенияСвойств(строкаИтог, Выборка);
		Если НЕ ЗначениеЗаполнено(Выборка.Спортсмен) Тогда
			Попытка
				спортсменСсылка = Справочники.Спортсмены.ПолучитьСсылку(Новый УникальныйИдентификатор(таблицаАнализаДанных[Выборка.Индекс].GUIDСпортсмена));
				строкаИтог.Спортсмен = спортсменСсылка;
			Исключение
				// {Рарус adilas #1.0.0.2 -SonarQube 2021.04.23
				ЗаписьЖурналаРегистрации(НСтр("ru = 'ЗагрузитьДанныеНаСервере()'"), УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				// }Рарус adilas #1.0.0.2 -SonarQube 2021.04.23
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;	
	
	Если НЕ ЗагрузкаНеФинишировавшихСпортсменов = Неопределено Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТаблицаДанных",  ПроведениеСоревнованийФормыСервер.ПроиндексироватьТаблицуДокумента(ЭтотОбъект,"НомерСтрокиНеСтартовали"));
		
		ТекстЗапроса = "";
		// {Рарус adilas #- -Sonar 2021.06.29
		УчетСпортсменовВызовСервера.ВвестиСтруктуруВоВременнуюТаблицу(
		   ТекстЗапроса, 
		   Новый Структура("Индекс, НомерСтроки"),
		   "ВТ_ДанныеТаблицы",
		   "ТаблицаДанных");
		
		Запрос.Текст =  ТекстЗапроса +"
		                |;
		                |
		                |////////////////////////////////////////////////////////////////////////////////
		                |ВЫБРАТЬ
		                |	ВТ_ДанныеТаблицы.Индекс КАК Индекс,
		                |	ВТ_ДанныеТаблицы.НомерСтроки КАК НомерСтроки,
		                |	ЕСТЬNULL(ВТ_ДанныеТаблицыСледПозиция.НомерСтроки,99999) КАК НомерСтрокиСледПозиция
		                |ИЗ
		                |	ВТ_ДанныеТаблицы КАК ВТ_ДанныеТаблицы
		                |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДанныеТаблицы КАК ВТ_ДанныеТаблицыСледПозиция
		                |		ПО ВТ_ДанныеТаблицы.НомерСтроки < ВТ_ДанныеТаблицыСледПозиция.НомерСтроки";
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			НомерПопытки_     = НомерСтрокиНеСтартовали[Выборка.Индекс].НомерПопытки;
			КодСпортсмена_    = НомерСтрокиНеСтартовали[Выборка.Индекс].КодСпортсмена;
			СостояниеПопытки  = НомерСтрокиНеСтартовали[Выборка.Индекс].СостояниеПопытки;
			СтартовыйНомер_   = НомерСтрокиНеСтартовали[Выборка.Индекс].СтартовыйНомер;
			Результат_        = НомерСтрокиНеСтартовали[Выборка.Индекс].Результат;
			
			Для ИндексОбласти = Выборка.НомерСтроки По ТабличныйДокументЗагрузка.ВысотаТаблицы Цикл
				
				Если ИндексОбласти = Выборка.НомерСтрокиСледПозиция Тогда
					Прервать;
				КонецЕсли;	
				
				Если НЕ ЗначениеЗаполнено(ТабличныйДокументЗагрузка.Область("R" + СокрЛП(ИндексОбласти) + "C" + СокрЛП(КодСпортсмена_)).Текст) Тогда 
					Продолжить;
				КонецЕсли;
				
				строкаДанных                     = ТаблицаНефинишировавшихУчастников.Добавить();
				строкаДанных.GUIDСпортсмена      = ТабличныйДокументЗагрузка.Область("R" + СокрЛП(ИндексОбласти) + "C" + СокрЛП(КодСпортсмена_)).Текст;
				Попытка
					строкаДанных.СтартовыйНомер  = ТабличныйДокументЗагрузка.Область("R" + СокрЛП(ИндексОбласти) + "C" + СокрЛП(СтартовыйНомер_)).Текст;
				Исключение
					// {Рарус adilas #1.0.0.2 -SonarQube 2021.04.23
					ЗаписьЖурналаРегистрации(НСтр("ru = 'ЗагрузитьДанныеНаСервере()'"), УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
					// }Рарус adilas #1.0.0.2 -SonarQube 2021.04.23
				КонецПопытки;
				Попытка
					спортсменСсылка = Справочники.Спортсмены.ПолучитьСсылку(Новый УникальныйИдентификатор(строкаДанных.GUIDСпортсмена));
					строкаДанных.Спортсмен = спортсменСсылка;
				Исключение
					// {Рарус adilas #1.0.0.2 -SonarQube 2021.04.23
					ЗаписьЖурналаРегистрации(НСтр("ru = 'ЗагрузитьДанныеНаСервере()'"), УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
					// }Рарус adilas #1.0.0.2 -SonarQube 2021.04.23
				КонецПопытки;
				строкаДанных.Параметр            = НомерПопытки_;
				строкаДанных.СостояниеПопытки    = СостояниеПопытки;
				Если НЕ Результат_ = 0 Тогда
					строкаДанных.Результат           = ЗаменитьСимволВСтрокеРезультата(ТабличныйДокументЗагрузка.Область("R" + СокрЛП(ИндексОбласти) + "C" + СокрЛП(Результат_)).Текст);
				КонецЕсли;
								
			КонецЦикла;
			
		КонецЦикла;	
		
	КонецЕсли;
	
	// Удаляем временный файл
	Попытка
		УдалитьФайлы(ИмяВременногоФайла);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'ЗагрузитьДанныеНаСервере()'"), УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)	
	
	ЭтаФорма.Закрыть(Новый Структура("СтруктураДанных,УспешнаяПопытка", сформироватьМассивИзТаблицы(),УспешнаяПопытка));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СоздатьВозрастнуюГруппу(возрастнаяГруппаСсылка, КодВозрастнойГруппы)
	
	объект_                        = Справочники.ВозрастныеГруппыСоревнований.СоздатьЭлемент();
	объект_.Наименование           = КодВозрастнойГруппы;
	объект_.КодСистемыХронометража = КодВозрастнойГруппы;
	
	Попытка
		объект_.Записать();
		возрастнаяГруппаСсылка =  объект_.Ссылка;
		СписокДопВозрастныхГрупп.Добавить(возрастнаяГруппаСсылка);
	Исключение
		// {Рарус adilas #1.0.0.2 -SonarQube 2021.04.23
		ЗаписьЖурналаРегистрации(НСтр("ru = 'ЗагрузитьДанныеНаСервере()'"), УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		// }Рарус adilas #1.0.0.2 -SonarQube 2021.04.23
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Функция сформироватьМассивИзТаблицы()
	
	МассивВозврат    = Новый Массив;
	СтруктураВозврат = Новый Структура;
		
	СформироватьМассивИзТаблицыЗначений("ТаблицаИтог", МассивВозврат);	
	
	СтруктураВозврат.Вставить("РезультатыСоревнования",МассивВозврат);
	
	МассивНеФинишировавшихСпортсменов = Новый Массив;
	СформироватьМассивИзТаблицыЗначений("ТаблицаНефинишировавшихУчастников", МассивНеФинишировавшихСпортсменов);
	СтруктураВозврат.Вставить("НеФинишировавшиеУчастники",МассивНеФинишировавшихСпортсменов);
	
	Возврат СтруктураВозврат
	
КонецФункции

&НаСервере
Процедура СформироватьМассивИзТаблицыЗначений(ИмяТаблицы, МассивДанных)
	
	тзКолонки = ЭтотОбъект[ИмяТаблицы].Выгрузить();
	Для Каждого строкаДанных Из ЭтотОбъект[ИмяТаблицы] Цикл
		СтруктураДанных = Новый Структура;
		Для Каждого Колонка Из тзколонки.Колонки Цикл
			СтруктураДанных.Вставить(Колонка.Имя,строкаДанных[Колонка.Имя]); 
		КонецЦикла;
		МассивДанных.Добавить(СтруктураДанных);
	КонецЦикла;
	
КонецПроцедуры	

&НаСервере
Функция ЗаменитьСимволВСтрокеРезультата(Результат)
	
	Результат = СтрЗаменить(Результат, ".", ":");
	Результат = СтрЗаменить(Результат, ",", ":");
	массивЗначений = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Результат,":");
	РезультатВозврат = "";
	Для Индекс = 0 По массивЗначений.Количество()-1 Цикл
		Если Индекс < 3 Тогда
			остаток =  СокрЛП(массивЗначений[Индекс]);
			Пока СтрДлина(остаток) < 2 Цикл
				остаток = "0" + СокрЛП(остаток);
			КонецЦикла;
		Иначе
			остаток =  СокрЛП(массивЗначений[Индекс]);
			Пока СтрДлина(остаток) < 3 Цикл
				остаток = СокрЛП(остаток) + "0";
			КонецЦикла;
		КонецЕсли;
		РезультатВозврат = РезультатВозврат + ?(Индекс=0,"",":") + остаток;
	КонецЦикла;
	
	Возврат РезультатВозврат
	
КонецФункции

#КонецОбласти