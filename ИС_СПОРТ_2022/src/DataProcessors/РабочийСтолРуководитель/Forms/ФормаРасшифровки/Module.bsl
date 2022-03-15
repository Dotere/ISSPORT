
// {Рарус ivaart IN-19230 Расшифровка таблиц тренеров и спортсменов 2021.07.30
&НаКлиенте
Процедура ТаблицаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// {Рарус adilas #23370 -РС Руководитель. Спортивные объекты. Количество спортсменов. 2021.12.22
	Если ТипЗнч(Элемент.ТекущиеДанные.Значение) = Тип("СправочникСсылка.Спортсмены") Тогда
		
		СпортсменСсылка = Элемент.ТекущиеДанные.Значение;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", СпортсменСсылка);
		ПараметрыФормы.Вставить("Организация", Организация);
		ОткрытьФорму("Справочник.Спортсмены.Форма.ФормаЭлемента", ПараметрыФормы); 
		
	Иначе
		
		ПоказатьЗначение(, Элемент.ТекущиеДанные.Значение);
		
	КонецЕсли;
	// }Рарус adilas #23370 -РС Руководитель. Спортивные объекты. Количество спортсменов. 2021.12.22
	
КонецПроцедуры

// {Рарус adilas #20292 -РС Руководитель. Спортивные объекты. Количество спортсменов. 2021.09.30
#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Источник 		 = Параметры.ИсточникДанных;
	КлючевойПараметр = Параметры.КлючевойПараметр;
	Параметр 		 = Параметры.Параметр; 
	Организация 	 = Параметры.Организация;
	
	// {Рарус adilas #23463 -РС Руководитель. Расшифровка значений. 2021.12.24
	Если Источник = "КоличествоСпортсменовПоЭтапам" Тогда
		
		Элементы.ГлавнаяДекорацияФормы.Заголовок = НСтр("ru='Количество спортсменов тренера по этапам СП'")  + " - " + Организация + " - " + КлючевойПараметр;
		Элементы.Таблица.Заголовок = "Спортсмены";
		Результат = КолСпортсменовПоЭтапам(КлючевойПараметр, Параметр, Организация);
		
	ИначеЕсли Источник = "ТаблицаСпортсменыПоТренерам" тогда
		
		Элементы.ГлавнаяДекорацияФормы.Заголовок = НСтр("ru='Количество спортсменов тренера по разрядам и званиям'")  + " - " + Организация + " - " + КлючевойПараметр;
		Элементы.Таблица.Заголовок = "Спортсмены";
		Результат = КолСпортсменовПоРазрядам(КлючевойПараметр, Параметр, Организация);
		
	ИначеЕсли Источник = "КолТренерКвалификационныеКатегории" тогда
		
		Элементы.ГлавнаяДекорацияФормы.Заголовок = НСтр("ru='Количество тренеров тренерской квалификационной категории'")  + " - " + Организация + " - " + КлючевойПараметр;
		Элементы.Таблица.Заголовок = "Тренеры";
		Результат = КолТренеровКвалификационныеКатегории(КлючевойПараметр, Организация);
		
	ИначеЕсли Источник = "КолТренерСпортивныеСудьи" тогда
		
		Элементы.ГлавнаяДекорацияФормы.Заголовок = НСтр("ru='Количество тренеров спортивной судейской категории'")  + " - " + Организация + " - " + КлючевойПараметр;
		Элементы.Таблица.Заголовок = "Судьи";
		Результат = КолСудейКвалификационныеКатегории(КлючевойПараметр, Организация);
		
	ИначеЕсли Источник = "КолТренерЗвания" тогда
		
		Элементы.ГлавнаяДекорацияФормы.Заголовок = НСтр("ru='Количество тренеров имеющих звания'")  + " - " + Организация + " - " + КлючевойПараметр;
		Элементы.Таблица.Заголовок = "Тренеры";
		Результат = КолТренеровЗвания(КлючевойПараметр, Организация);
		
	ИначеЕсли Источник = "КолСпортсменовПоЭтапамСП" тогда
		
		Элементы.ГлавнаяДекорацияФормы.Заголовок = НСтр("ru='Количество спортсменов по этапам СП'")  + " - " + Организация + " - " + КлючевойПараметр;
		Элементы.Таблица.Заголовок = "Спортсмены";
		Результат = КолСпортсменовПоЭтапамСП(КлючевойПараметр, Организация);
		
	ИначеЕсли Источник = "ТаблицаКоличествоСпортсменовПоГодамСпортсмены" тогда
		
		Элементы.ГлавнаяДекорацияФормы.Заголовок = НСтр("ru='Количество спортсменов по этапам СП за период'")  + " - " + Организация + " - " + КлючевойПараметр;
		Элементы.Таблица.Заголовок = "Спортсмены";
		Результат = КолСпортсменовПоГодамЭтапы(КлючевойПараметр, Параметр, Организация);
		
	ИначеЕсли Источник = "ТаблицаСпортсменыПоРазрядам" тогда
		
		Элементы.ГлавнаяДекорацияФормы.Заголовок = НСтр("ru='Количество спортсменов по разрядам и званиям'")  + " - " + Организация + " - " + КлючевойПараметр;
		Элементы.Таблица.Заголовок = "Спортсмены";
		Результат = КолСпортсменовПоРазрядамВидСпорта(КлючевойПараметр, Параметр, Организация);
		
	ИначеЕсли Источник = "Статистика изменения количества спортсменов за период" тогда
		
		Элементы.Таблица.Заголовок = "Спортсмены";
		Результат = КолСпортсменовПоГодамВидСпорта(КлючевойПараметр, Параметр, Организация);
		
	ИначеЕсли Источник = "Статистика изменения количества тренеров за период" тогда
		
		Элементы.Таблица.Заголовок = "Тренеры";
		Результат = КолТренеровПоГодамВидСпорта(КлючевойПараметр, Параметр, Организация);
		
	ИначеЕсли Источник = "Количество спортсменов" тогда
		
		Элементы.Таблица.Заголовок = "Спортсмены";
		// {Рарус adilas #20291 -РС Руководитель. Спортивные объекты 2021.09.30
	    ДобавитьКолонкиДляСпортсменовНаСервере();
		// }Рарус adilas #20291 -РС Руководитель. Спортивные объекты 2021.09.30
		Результат = КолСпортсменов(КлючевойПараметр, Организация);
		
	ИначеЕсли Источник = "Количество тренеров" тогда
		
		Элементы.Таблица.Заголовок = "Тренеры";	
		Результат = КолТренеров(КлючевойПараметр, Организация);
		
	КонецЕсли;
	// }Рарус adilas #23463 -РС Руководитель. Расшифровка значений. 2021.12.24
	
	Если Не ПустаяСтрока(Результат) тогда 
		Таблица.Загрузить(Результат);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	УдалитьКолонкиДляСпортсменовНаСервере();		
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ПриЗакрытииНаСервере();
КонецПроцедуры
  
#КонецОбласти
// }Рарус adilas #20292 -РС Руководитель. Спортивные объекты. Количество спортсменов. 2021.09.30

#Область ПроцедурыИФункцииДляТаблицы
&НаСервереБезКонтекста
Функция КолСпортсменовПоЭтапам(Тренер, Этап, Организация)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Спортсмен КАК Значение,
		|	АВТОНОМЕРЗАПИСИ() КАК Номер
		|ПОМЕСТИТЬ ПромежуточноеСпортсмены
		|ИЗ
		|	РегистрСведений.ЭтапыСпортивнойПодготовкиСпортсменов.СрезПоследних(, Организация = &Организация) КАК ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоставУчащихсяСпортивногоУчреждения.СрезПоследних(, Организация = &Организация) КАК СоставУчащихсяСпортивногоУчрежденияСрезПоследних
		|		ПО ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Спортсмен = СоставУчащихсяСпортивногоУчрежденияСрезПоследних.Спортсмен
		|ГДЕ
		|	ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Тренер = &Тренер
		|	И ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Этап.Наименование = &Этап
		|	И ВЫБОР
		|			КОГДА СоставУчащихсяСпортивногоУчрежденияСрезПоследних.ДатаОкончанияОбучения = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ
		|
		|СГРУППИРОВАТЬ ПО
		|	ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Спортсмен
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПромежуточноеСпортсмены.Значение КАК Значение,
		|	ПромежуточноеСпортсмены.Номер КАК Номер
		|ИЗ
		|	ПромежуточноеСпортсмены КАК ПромежуточноеСпортсмены";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Тренер", Тренер);
	Запрос.УстановитьПараметр("Этап", Этап);
	
	Возврат Запрос.Выполнить().Выгрузить(); 
КонецФункции

&НаСервереБезКонтекста
Функция КолСпортсменовПоРазрядам(Тренер, Разряд, Организация)
	Запрос = Новый Запрос;
	Запрос.Текст = 
				   "ВЫБРАТЬ РАЗРЕШЕННЫЕ
				   |	ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Спортсмен КАК Спортсмен,
				   |	ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Тренер КАК Тренер
				   |ПОМЕСТИТЬ Спортсмены
				   |ИЗ
				   |	РегистрСведений.ЭтапыСпортивнойПодготовкиСпортсменов.СрезПоследних(, Организация = &Организация) КАК ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних
				   |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоставУчащихсяСпортивногоУчреждения.СрезПоследних(, Организация = &Организация) КАК СоставУчащихсяСпортивногоУчрежденияСрезПоследних
				   |		ПО ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Спортсмен = СоставУчащихсяСпортивногоУчрежденияСрезПоследних.Спортсмен
				   |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КадровыеИсторииТренеров.СрезПоследних(, Организация = &Организация) КАК КадровыеИсторииТренеровСрезПоследних
				   |		ПО ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Тренер = КадровыеИсторииТренеровСрезПоследних.Тренер
				   |ГДЕ
				   |	НЕ ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Тренер ЕСТЬ NULL
				   |	И ВЫБОР
				   |			КОГДА СоставУчащихсяСпортивногоУчрежденияСрезПоследних.ДатаОкончанияОбучения = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
				   |				ТОГДА ИСТИНА
				   |			ИНАЧЕ ЛОЖЬ
				   |		КОНЕЦ
				   |	И КадровыеИсторииТренеровСрезПоследних.ВидСобытия <> ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)
				   |;
				   |
				   |////////////////////////////////////////////////////////////////////////////////
				   |ВЫБРАТЬ РАЗРЕШЕННЫЕ
				   |	Спортсмены.Спортсмен КАК Спортсмен,
				   |	ЕСТЬNULL(ПодтвержденныеРазрядыСпортсменовСрезПоследних.Разряд.Наименование, ""б/р"") КАК Разряд,
				   |	Спортсмены.Тренер КАК Тренер
				   |ПОМЕСТИТЬ ПромежуточнаяСпортсмены
				   |ИЗ
				   |	Спортсмены КАК Спортсмены
				   |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПодтвержденныеРазрядыСпортсменов.СрезПоследних(, Организация = &Организация) КАК ПодтвержденныеРазрядыСпортсменовСрезПоследних
				   |		ПО Спортсмены.Спортсмен = ПодтвержденныеРазрядыСпортсменовСрезПоследних.Спортсмен
				   |
				   |СГРУППИРОВАТЬ ПО
				   |	Спортсмены.Спортсмен,
				   |	ЕСТЬNULL(ПодтвержденныеРазрядыСпортсменовСрезПоследних.Разряд.Наименование, ""б/р""),
				   |	Спортсмены.Тренер
				   |;
				   |
				   |////////////////////////////////////////////////////////////////////////////////
				   |ВЫБРАТЬ
				   |	ПромежуточнаяСпортсмены.Спортсмен КАК Спортсмен,
				   |	ПромежуточнаяСпортсмены.Разряд КАК Разряд,
				   |	АВТОНОМЕРЗАПИСИ() КАК Номер
				   |ПОМЕСТИТЬ ВтрораяПромежуточная
				   |ИЗ
				   |	ПромежуточнаяСпортсмены КАК ПромежуточнаяСпортсмены
				   |ГДЕ
				   |	ПромежуточнаяСпортсмены.Разряд = &Разряд
				   |	И ПромежуточнаяСпортсмены.Тренер = &Тренер
				   |;
				   |
				   |////////////////////////////////////////////////////////////////////////////////
				   |ВЫБРАТЬ
				   |	ВтрораяПромежуточная.Спортсмен КАК Значение,
				   |	ВтрораяПромежуточная.Номер КАК Номер
				   |ИЗ
				   |	ВтрораяПромежуточная КАК ВтрораяПромежуточная";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Тренер", Тренер);
	Запрос.УстановитьПараметр("Разряд", Разряд);
	
	Возврат Запрос.Выполнить().Выгрузить(); 
КонецФункции

&НаСервереБезКонтекста
Функция КолТренеровКвалификационныеКатегории(Категория, Организация)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СоответствияФизическихЛицИОрганизаций.ФизическоеЛицо КАК ФизическоеЛицо
		|ПОМЕСТИТЬ ФизЛица
		|ИЗ
		|	РегистрСведений.СоответствияФизическихЛицИОрганизаций КАК СоответствияФизическихЛицИОрганизаций
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КадровыеИсторииТренеров.СрезПоследних(, Организация = &Организация) КАК КадровыеИсторииТренеровСрезПоследних
		|		ПО СоответствияФизическихЛицИОрганизаций.ФизическоеЛицо.Ссылка = КадровыеИсторииТренеровСрезПоследних.Тренер.ФизическоеЛицо.Ссылка
		|ГДЕ
		|	СоответствияФизическихЛицИОрганизаций.Организация = &Организация
		|	И КадровыеИсторииТренеровСрезПоследних.ВидСобытия <> ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КвалификационныеКатегорииТренеровСрезПоследних.Категория КАК Категория,
		|	КвалификационныеКатегорииТренеровСрезПоследних.Тренер КАК Значение,
		|	АВТОНОМЕРЗАПИСИ() КАК Номер
		|ПОМЕСТИТЬ ПромежуточнаяТренера
		|ИЗ
		|	РегистрСведений.КвалификационныеКатегорииТренеров.СрезПоследних КАК КвалификационныеКатегорииТренеровСрезПоследних
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ФизЛица КАК ФизЛица
		|		ПО (ФизЛица.ФизическоеЛицо.Ссылка = КвалификационныеКатегорииТренеровСрезПоследних.Тренер.ФизическоеЛицо.Ссылка)
		|ГДЕ
		|	КвалификационныеКатегорииТренеровСрезПоследних.Категория = &Категория
		|
		|СГРУППИРОВАТЬ ПО
		|	КвалификационныеКатегорииТренеровСрезПоследних.Категория,
		|	КвалификационныеКатегорииТренеровСрезПоследних.Тренер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПромежуточнаяТренера.Значение КАК Значение,
		|	ПромежуточнаяТренера.Номер КАК Номер
		|ИЗ
		|	ПромежуточнаяТренера КАК ПромежуточнаяТренера";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Категория", Категория);
	
	Возврат Запрос.Выполнить().Выгрузить(); 
КонецФункции

&НаСервереБезКонтекста
Функция КолСудейКвалификационныеКатегории(Категория, Организация)
	Запрос = Новый Запрос;
	// {Рарус dotere #19864 -Не поподают уволенные тренеры 2021.09.24
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КадровыеИсторииТренеровСрезПоследних.Тренер КАК Тренер
		|ПОМЕСТИТЬ ФизЛица
		|ИЗ
		|	РегистрСведений.КадровыеИсторииТренеров.СрезПоследних(&ТекущаяДата, Организация = &Организация) КАК КадровыеИсторииТренеровСрезПоследних
		|ГДЕ
		|	(КадровыеИсторииТренеровСрезПоследних.ВидСобытия <> ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)
		|			ИЛИ КадровыеИсторииТренеровСрезПоследних.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)
		|				И КадровыеИсторииТренеровСрезПоследних.Период > &ТекущаяДата)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КатегорииСпортивныхСудейСрезПоследних.Тренер КАК Значение,
		|	КатегорииСпортивныхСудейСрезПоследних.Категория КАК Категория,
		|	АВТОНОМЕРЗАПИСИ() КАК Номер
		|ПОМЕСТИТЬ ПромежуточныйСудьи
		|ИЗ
		|	ФизЛица КАК ФизЛица
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КатегорииСпортивныхСудей.СрезПоследних КАК КатегорииСпортивныхСудейСрезПоследних
		|		ПО ФизЛица.Тренер = КатегорииСпортивныхСудейСрезПоследних.Тренер
		|ГДЕ
		|	КатегорииСпортивныхСудейСрезПоследних.Категория = &Категория
		|	И (КатегорииСпортивныхСудейСрезПоследних.СрокДействия >= &ТекущаяДата
		|			ИЛИ КатегорииСпортивныхСудейСрезПоследних.СрокДействия = ДАТАВРЕМЯ(1, 1, 1))
		|
		|СГРУППИРОВАТЬ ПО
		|	КатегорииСпортивныхСудейСрезПоследних.Категория,
		|	КатегорииСпортивныхСудейСрезПоследних.Тренер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПромежуточныйСудьи.Значение КАК Значение,
		|	ПромежуточныйСудьи.Номер КАК Номер
		|ИЗ
		|	ПромежуточныйСудьи КАК ПромежуточныйСудьи";
	    // }Рарус dotere #19864 -Не поподают уволенные тренеры 2021.09.24
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Категория", Категория);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	
	Возврат Запрос.Выполнить().Выгрузить(); 
КонецФункции

&НаСервереБезКонтекста
Функция КолТренеровЗвания(Звание, Организация)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СоответствияФизическихЛицИОрганизаций.ФизическоеЛицо КАК ФизическоеЛицо
		|ПОМЕСТИТЬ ФизЛица
		|ИЗ
		|	РегистрСведений.СоответствияФизическихЛицИОрганизаций КАК СоответствияФизическихЛицИОрганизаций
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КадровыеИсторииТренеров.СрезПоследних(, Организация = &Организация) КАК КадровыеИсторииТренеровСрезПоследних
		|		ПО СоответствияФизическихЛицИОрганизаций.ФизическоеЛицо.Ссылка = КадровыеИсторииТренеровСрезПоследних.Тренер.ФизическоеЛицо.Ссылка
		|ГДЕ
		|	КадровыеИсторииТренеровСрезПоследних.ВидСобытия <> ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)
		|	И СоответствияФизическихЛицИОрганизаций.Организация = &Организация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СпортивныеЗванияТренеровСрезПоследних.Звание КАК Звание,
		|	СпортивныеЗванияТренеровСрезПоследних.Тренер КАК Значение,
		|	АВТОНОМЕРЗАПИСИ() КАК Номер
		|ПОМЕСТИТЬ ПромежуточноеТренера
		|ИЗ
		|	ФизЛица КАК ФизЛица
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СпортивныеЗванияТренеров.СрезПоследних КАК СпортивныеЗванияТренеровСрезПоследних
		|		ПО ФизЛица.ФизическоеЛицо.Ссылка = СпортивныеЗванияТренеровСрезПоследних.Тренер.ФизическоеЛицо.Ссылка
		|ГДЕ
		|	СпортивныеЗванияТренеровСрезПоследних.Звание = &Звание
		|
		|СГРУППИРОВАТЬ ПО
		|	СпортивныеЗванияТренеровСрезПоследних.Звание,
		|	СпортивныеЗванияТренеровСрезПоследних.Тренер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПромежуточноеТренера.Значение КАК Значение,
		|	ПромежуточноеТренера.Номер КАК Номер
		|ИЗ
		|	ПромежуточноеТренера КАК ПромежуточноеТренера";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Звание", Звание);
	
	Возврат Запрос.Выполнить().Выгрузить(); 
КонецФункции

&НаСервереБезКонтекста
Функция КолСпортсменовПоЭтапамСП(Этап, Организация)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Спортсмен КАК Значение,
		|	АВТОНОМЕРЗАПИСИ() КАК Номер
		|ПОМЕСТИТЬ ПромежуточнаяТаблица
		|ИЗ
		|	РегистрСведений.ЭтапыСпортивнойПодготовкиСпортсменов.СрезПоследних(, Организация = &Организация) КАК ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоставУчащихсяСпортивногоУчреждения.СрезПоследних(, Организация = &Организация) КАК СоставУчащихсяСпортивногоУчрежденияСрезПоследних
		|		ПО ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Спортсмен = СоставУчащихсяСпортивногоУчрежденияСрезПоследних.Спортсмен
		|ГДЕ
		|	ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Этап = &Этап
		|	И ВЫБОР
		|			КОГДА СоставУчащихсяСпортивногоУчрежденияСрезПоследних.ДатаОкончанияОбучения = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ
		|
		|СГРУППИРОВАТЬ ПО
		|	ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Спортсмен
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПромежуточнаяТаблица.Значение КАК Значение,
		|	ПромежуточнаяТаблица.Номер КАК Номер
		|ИЗ
		|	ПромежуточнаяТаблица КАК ПромежуточнаяТаблица";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Этап", Этап);
	
	Возврат Запрос.Выполнить().Выгрузить(); 
КонецФункции

&НаСервереБезКонтекста
Функция КолСпортсменовПоГодамЭтапы(Этап, Год, Организация)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Спортсмен КАК Значение,
		|	АВТОНОМЕРЗАПИСИ() КАК Номер
		|ПОМЕСТИТЬ ПромежуточнаяСпортсмены
		|ИЗ
		|	РегистрСведений.ЭтапыСпортивнойПодготовкиСпортсменов.СрезПоследних(&Год, Организация = &Организация) КАК ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоставУчащихсяСпортивногоУчреждения.СрезПоследних(&Год, Организация = &Организация) КАК СоставУчащихсяСпортивногоУчрежденияСрезПоследних
		|		ПО ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Спортсмен = СоставУчащихсяСпортивногоУчрежденияСрезПоследних.Спортсмен
		|ГДЕ
		|	ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Этап = &Этап
		|	И ВЫБОР
		|			КОГДА СоставУчащихсяСпортивногоУчрежденияСрезПоследних.ДатаОкончанияОбучения = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ
		|
		|СГРУППИРОВАТЬ ПО
		|	ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Спортсмен
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПромежуточнаяСпортсмены.Значение КАК Значение,
		|	ПромежуточнаяСпортсмены.Номер КАК Номер
		|ИЗ
		|	ПромежуточнаяСпортсмены КАК ПромежуточнаяСпортсмены";
	
	Запрос.УстановитьПараметр("Год", Дата(Число(Год),12,31));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Этап", Этап);
	
	Возврат Запрос.Выполнить().Выгрузить(); 
КонецФункции

&НаСервереБезКонтекста
Функция КолСпортсменовПоРазрядамВидСпорта(ВидСпорта, Разряд, Организация)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	СоставУчащихсяСпортивногоУчрежденияСрезПоследних.Спортсмен КАК Спортсмен,
	               |	СоставУчащихсяСпортивногоУчрежденияСрезПоследних.ВидСпорта КАК ВидСпорта
	               |ПОМЕСТИТЬ Спортсмены
	               |ИЗ
	               |	РегистрСведений.СоставУчащихсяСпортивногоУчреждения.СрезПоследних(, Организация = &Организация) КАК СоставУчащихсяСпортивногоУчрежденияСрезПоследних
	               |ГДЕ
	               |	ВЫБОР
	               |			КОГДА СоставУчащихсяСпортивногоУчрежденияСрезПоследних.ДатаОкончанияОбучения = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	               |				ТОГДА ИСТИНА
	               |			ИНАЧЕ ЛОЖЬ
	               |		КОНЕЦ
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	СоставУчащихсяСпортивногоУчрежденияСрезПоследних.Спортсмен,
	               |	СоставУчащихсяСпортивногоУчрежденияСрезПоследних.ВидСпорта
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ЕСТЬNULL(ПодтвержденныеРазрядыСпортсменовСрезПоследних.Разряд.Наименование, ""б/р"") КАК Разряд,
	               |	Спортсмены.Спортсмен КАК Значение,
	               |	Спортсмены.ВидСпорта КАК ВидСпорта
	               |ПОМЕСТИТЬ ПромежуточнаяСпортмены
	               |ИЗ
	               |	Спортсмены КАК Спортсмены
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПодтвержденныеРазрядыСпортсменов.СрезПоследних(, Организация = &Организация) КАК ПодтвержденныеРазрядыСпортсменовСрезПоследних
	               |		ПО Спортсмены.Спортсмен.Ссылка = ПодтвержденныеРазрядыСпортсменовСрезПоследних.Спортсмен.Ссылка
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Спортсмены.Спортсмен,
	               |	ЕСТЬNULL(ПодтвержденныеРазрядыСпортсменовСрезПоследних.Разряд.Наименование, ""б/р""),
	               |	Спортсмены.ВидСпорта
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ПромежуточнаяСпортмены.Значение КАК Значение,
	               |	АВТОНОМЕРЗАПИСИ() КАК Номер
	               |ПОМЕСТИТЬ ПромежуточнаяСпортсмены2
	               |ИЗ
	               |	ПромежуточнаяСпортмены КАК ПромежуточнаяСпортмены
	               |ГДЕ
	               |	ПромежуточнаяСпортмены.Разряд = &Разряд
	               |	И ПромежуточнаяСпортмены.ВидСпорта = &ВидСпорта
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ПромежуточнаяСпортсмены2.Значение КАК Значение,
	               |	ПромежуточнаяСпортсмены2.Номер КАК Номер
	               |ИЗ
	               |	ПромежуточнаяСпортсмены2 КАК ПромежуточнаяСпортсмены2";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Разряд", Разряд);
	Запрос.УстановитьПараметр("ВидСпорта", ВидСпорта);
	
	Возврат Запрос.Выполнить().Выгрузить(); 
КонецФункции

&НаСервереБезКонтекста
Функция КолСпортсменовПоГодамВидСпорта(ВидСпорта, Год, Организация)
	
	// {Рарус adilas #23447 -Тестирование релиза 1.0.0.5. РС Руководитель. Закладка "Виды спорта" 2021.12.24
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СоставУчащихсяСпортивногоУчрежденияСрезПоследних.Организация КАК Организация,
		|	СоставУчащихсяСпортивногоУчрежденияСрезПоследних.Спортсмен КАК Спортсмен,
		|	СоставУчащихсяСпортивногоУчрежденияСрезПоследних.ВидСпорта КАК ВидСпорта
		|ПОМЕСТИТЬ ВТ_СоставУчащихся
		|ИЗ
		|	РегистрСведений.СоставУчащихсяСпортивногоУчреждения.СрезПоследних(, Организация = &Организация) КАК СоставУчащихсяСпортивногоУчрежденияСрезПоследних
		|ГДЕ
		|	СоставУчащихсяСпортивногоУчрежденияСрезПоследних.ВидСпорта = &ВидСпорта
		|	И (СоставУчащихсяСпортивногоУчрежденияСрезПоследних.ДатаОкончанияОбучения = ДАТАВРЕМЯ(1, 1, 1)
		|			ИЛИ СоставУчащихсяСпортивногоУчрежденияСрезПоследних.ДатаОкончанияОбучения МЕЖДУ &НачалоПериода И &КонецПериода)
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ВидСпорта,
		|	Организация,
		|	Спортсмен
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВТ_СоставУчащихся.Спортсмен КАК Спортсмен,
		|	АВТОНОМЕРЗАПИСИ() КАК Номер
		|ПОМЕСТИТЬ ВТ_ЗаДату1
		|ИЗ
		|	ВТ_СоставУчащихся КАК ВТ_СоставУчащихся
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЭтапыСпортивнойПодготовкиСпортсменов.СрезПоследних(, Организация = &Организация) КАК ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних
		|		ПО ВТ_СоставУчащихся.Спортсмен = ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Спортсмен
		|			И ВТ_СоставУчащихся.ВидСпорта = ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.ВидСпорта
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ЗаДату1.Спортсмен КАК Значение,
		|	ВТ_ЗаДату1.Номер КАК Номер
		|ИЗ
		|	ВТ_ЗаДату1 КАК ВТ_ЗаДату1";	
		
	НачалоПериода = НачалоГода(Дата(Число(Год),12,31)) - 1;
	КонецПериода = КонецГода(Дата(Число(Год),12,31)); 
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	// }Рарус adilas #23447 -Тестирование релиза 1.0.0.5. РС Руководитель. Закладка "Виды спорта" 2021.12.24
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ВидСпорта", ВидСпорта);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервереБезКонтекста
Функция КолТренеровПоГодамВидСпорта(ВидСпорта, Год, Организация)
	
	// {Рарус adilas #23447 -Тестирование релиза 1.0.0.5. РС Руководитель. Закладка "Виды спорта" 2021.12.24
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СоответствияФизическихЛицИОрганизаций.ФизическоеЛицо КАК ФизическоеЛицо,
		|	СоответствияФизическихЛицИОрганизаций.Организация КАК Организация
		|ПОМЕСТИТЬ ОрганизацииФизЛиц
		|ИЗ
		|	РегистрСведений.СоответствияФизическихЛицИОрганизаций КАК СоответствияФизическихЛицИОрганизаций
		|ГДЕ
		|	СоответствияФизическихЛицИОрганизаций.Организация = &Организация
		|	И СоответствияФизическихЛицИОрганизаций.ФизическоеЛицо <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Тренер КАК Тренер,
		|	ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.ВидСпорта КАК ВидСпорта
		|ПОМЕСТИТЬ ВТ_Тренеры
		|ИЗ
		|	ОрганизацииФизЛиц КАК ОрганизацииФизЛиц
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КадровыеИсторииТренеров.СрезПоследних(, ) КАК КадровыеИсторииТренеровСрезПоследних
		|		ПО ОрганизацииФизЛиц.ФизическоеЛицо = КадровыеИсторииТренеровСрезПоследних.Тренер.ФизическоеЛицо
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЭтапыСпортивнойПодготовкиСпортсменов.СрезПоследних(, ) КАК ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних
		|		ПО (КадровыеИсторииТренеровСрезПоследних.Тренер = ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Тренер)
		|ГДЕ
		|	КадровыеИсторииТренеровСрезПоследних.ВидСобытия <> ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)
		|	И КадровыеИсторииТренеровСрезПоследних.Тренер.СтатусТренера = ЗНАЧЕНИЕ(Перечисление.СтатусыТренеров.Работает)
		|	И КадровыеИсторииТренеровСрезПоследних.Период МЕЖДУ &НачалоПериода И &КонецПериода
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Тренер КАК Тренер,
		|	ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.ВидСпорта КАК ВидСпорта
		|ПОМЕСТИТЬ ВТ_ВидыСпорта_Предв
		|ИЗ
		|	РегистрСведений.ЭтапыСпортивнойПодготовкиСпортсменов.СрезПоследних(, ) КАК ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних
		|ГДЕ
		|	(ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Тренер, ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.ВидСпорта) В
		|			(ВЫБРАТЬ
		|				ВТ_Тренеры.Тренер КАК Тренер,
		|				ВТ_Тренеры.ВидСпорта КАК ВидСпорта
		|			ИЗ
		|				ВТ_Тренеры КАК ВТ_Тренеры)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КоличествоВидовСпортаТренеровОстатки.Тренер,
		|	КоличествоВидовСпортаТренеровОстатки.ВидСпорта
		|ИЗ
		|	РегистрНакопления.КоличествоВидовСпортаТренеров.Остатки(
		|			,
		|			(Тренер, ВидСпорта) В
		|				(ВЫБРАТЬ
		|					ВТ_Тренеры.Тренер КАК Тренер,
		|					ВТ_Тренеры.ВидСпорта КАК ВидСпорта
		|				ИЗ
		|					ВТ_Тренеры КАК ВТ_Тренеры)) КАК КоличествоВидовСпортаТренеровОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВидыСпорта.Тренер КАК Тренер,
		|	ВидыСпорта.ВидСпорта КАК ВидСпорта,
		|	АВТОНОМЕРЗАПИСИ() КАК Номер
		|ПОМЕСТИТЬ ВТ_Итог
		|ИЗ
		|	ВТ_ВидыСпорта_Предв КАК ВидыСпорта
		|ГДЕ
		|	ВидыСпорта.ВидСпорта = &ВидСпорта
		|
		|СГРУППИРОВАТЬ ПО
		|	ВидыСпорта.ВидСпорта,
		|	ВидыСпорта.Тренер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Итог.Тренер КАК Значение,
		|	ВТ_Итог.Номер КАК Номер
		|ИЗ
		|	ВТ_Итог КАК ВТ_Итог";
	
	НачалоПериода = НачалоГода(Дата(Число(Год),12,31)) - 1;
	КонецПериода = КонецГода(Дата(Число(Год),12,31)); 
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	// }Рарус adilas #23447 -Тестирование релиза 1.0.0.5. РС Руководитель. Закладка "Виды спорта" 2021.12.24
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ВидСпорта", ВидСпорта);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// {Рарус ivaart IN-19390 Расшифровка Данных по СО 2021.08.27
&НаСервереБезКонтекста
Функция КолСпортсменов(СпортивныйОбъект, Организация)
	
	// {Рарус adilas #20292 -РС Руководитель. Спортивные объекты. Количество спортсменов. 2021.10.07
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СпортивныеОбъекты.Тренер КАК Тренер
		|ПОМЕСТИТЬ ВТ_Тренеры
		|ИЗ
		|	РегистрСведений.СпортивныеОбъекты КАК СпортивныеОбъекты
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КадровыеИсторииТренеров.СрезПоследних КАК КадровыеИсторииТренеровСрезПоследних
		|		ПО СпортивныеОбъекты.Организация = КадровыеИсторииТренеровСрезПоследних.Организация
		|			И СпортивныеОбъекты.Тренер = КадровыеИсторииТренеровСрезПоследних.Тренер
		|ГДЕ
		|	СпортивныеОбъекты.Организация = &Организация
		|	И СпортивныеОбъекты.СпортивныйОбъект = &СпортивныйОбъект
		|	И КадровыеИсторииТренеровСрезПоследних.ВидСобытия <> &ВидСобытия
		|
		|СГРУППИРОВАТЬ ПО
		|	СпортивныеОбъекты.Тренер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СоставУчащихсяСпортивногоУчрежденияСрезПоследних.Спортсмен КАК Спортсмен,
		|	СоставУчащихсяСпортивногоУчрежденияСрезПоследних.Организация КАК Организация,
		|	СоставУчащихсяСпортивногоУчрежденияСрезПоследних.ВидСпорта КАК ВидСпорта
		|ПОМЕСТИТЬ ВТ_СоставУчащихся
		|ИЗ
		|	РегистрСведений.СоставУчащихсяСпортивногоУчреждения.СрезПоследних(
		|			,
		|			Организация = &Организация
		|				И Спортсмен.СтатусСпортсмена <> ЗНАЧЕНИЕ(Перечисление.СтатусыСпортсменов.СпортсменДругогоСпортивногоУчреждения)) КАК СоставУчащихсяСпортивногоУчрежденияСрезПоследних
		|ГДЕ
		|	(СоставУчащихсяСпортивногоУчрежденияСрезПоследних.ДатаОкончанияОбучения > &ТекущаяДата
		|			ИЛИ СоставУчащихсяСпортивногоУчрежденияСрезПоследних.ДатаОкончанияОбучения = ДАТАВРЕМЯ(1, 1, 1))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Спортсмен КАК Спортсмен,
		|	ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Этап КАК Этап
		|ПОМЕСТИТЬ ВТ_Этапы
		|ИЗ
		|	РегистрСведений.ЭтапыСпортивнойПодготовкиСпортсменов.СрезПоследних(
		|			,
		|			Организация = &Организация
		|				И (Спортсмен, ВидСпорта) В
		|					(ВЫБРАТЬ
		|						ВТ_СоставУчащихся.Спортсмен КАК Спортсмен,
		|						ВТ_СоставУчащихся.ВидСпорта КАК ВидСпорта
		|					ИЗ
		|						ВТ_СоставУчащихся КАК ВТ_СоставУчащихся)) КАК ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних
		|ГДЕ
		|	ЭтапыСпортивнойПодготовкиСпортсменовСрезПоследних.Тренер В
		|			(ВЫБРАТЬ
		|				ВТ_Тренеры.Тренер КАК Тренер
		|			ИЗ
		|				ВТ_Тренеры КАК ВТ_Тренеры)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПодтвержденныеРазрядыСпортсменовСрезПоследних.Спортсмен КАК Спортсмен,
		|	ПодтвержденныеРазрядыСпортсменовСрезПоследних.Разряд КАК Разряд
		|ПОМЕСТИТЬ ВТ_Разряды
		|ИЗ
		|	РегистрСведений.ПодтвержденныеРазрядыСпортсменов.СрезПоследних(
		|			,
		|			Организация = &Организация
		|				И (Спортсмен, ВидСпорта) В
		|					(ВЫБРАТЬ
		|						ВТ_СоставУчащихся.Спортсмен КАК Спортсмен,
		|						ВТ_СоставУчащихся.ВидСпорта КАК ВидСпорта
		|					ИЗ
		|						ВТ_СоставУчащихся КАК ВТ_СоставУчащихся)) КАК ПодтвержденныеРазрядыСпортсменовСрезПоследних
		|
		|СГРУППИРОВАТЬ ПО
		|	ПодтвержденныеРазрядыСпортсменовСрезПоследних.Спортсмен,
		|	ПодтвержденныеРазрядыСпортсменовСрезПоследних.Разряд
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Этапы.Спортсмен КАК Значение,
		|	ВТ_Этапы.Этап КАК Этап,
		|	ВТ_Разряды.Разряд КАК Разряд,
		|	ВТ_Этапы.Спортсмен.ФизическоеЛицо.ДатаРождения КАК ДатаРождения,
		|	0 КАК Номер
		|ИЗ
		|	ВТ_Этапы КАК ВТ_Этапы
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Разряды КАК ВТ_Разряды
		|		ПО ВТ_Этапы.Спортсмен = ВТ_Разряды.Спортсмен
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВТ_Этапы.Спортсмен.Наименование";
	// }Рарус adilas #20292 -РС Руководитель. Спортивные объекты. Количество спортсменов. 2021.10.07
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("СпортивныйОбъект", СпортивныйОбъект);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ВидСобытия", Перечисления.ВидыКадровыхСобытий.Увольнение);
	// {Рарус adilas #20292 -РС Руководитель. Спортивные объекты. Количество спортсменов. 2021.10.07
	ТЗСпортсмены = Запрос.Выполнить().Выгрузить();
	
	НомерСтрокиСпр = 1;
	
	Для Каждого Строка Из ТЗСпортсмены Цикл	
		Строка.Номер = НомерСтрокиСпр;
		НомерСтрокиСпр = НомерСтрокиСпр + 1;	
	КонецЦикла;
	
	Возврат ТЗСпортсмены;
	// }Рарус adilas #20292 -РС Руководитель. Спортивные объекты. Количество спортсменов. 2021.10.07
	
КонецФункции

&НаСервереБезКонтекста
Функция КолТренеров(СпортивныйОбъект, Организация)
	Менеджер = новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СпортивныеОбъекты.Тренер КАК Тренер,
		|	АВТОНОМЕРЗАПИСИ() КАК Номер
		|ПОМЕСТИТЬ Тренеры
		|ИЗ
		|	РегистрСведений.СпортивныеОбъекты КАК СпортивныеОбъекты
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КадровыеИсторииТренеров.СрезПоследних КАК КадровыеИсторииТренеровСрезПоследних
		|		ПО СпортивныеОбъекты.Организация = КадровыеИсторииТренеровСрезПоследних.Организация
		|			И СпортивныеОбъекты.Тренер = КадровыеИсторииТренеровСрезПоследних.Тренер
		|ГДЕ
		|	СпортивныеОбъекты.Организация = &Организация
		|	И СпортивныеОбъекты.СпортивныйОбъект = &СпортивныйОбъект
		|	И КадровыеИсторииТренеровСрезПоследних.ВидСобытия <> &ВидСобытия
		|
		|СГРУППИРОВАТЬ ПО
		|	СпортивныеОбъекты.Тренер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Тренеры.Тренер КАК Значение,
		|	Тренеры.Номер КАК Номер
		|ИЗ
		|	Тренеры КАК Тренеры";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("СпортивныйОбъект", СпортивныйОбъект);
	Запрос.УстановитьПараметр("ВидСобытия", Перечисления.ВидыКадровыхСобытий.Увольнение);
					
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции
// }Рарус ivaart IN-19390 Расшифровка Данных по СО 2021.08.27
#КонецОбласти
// }Рарус ivaart IN-19230 Расшифровка таблиц тренеров и спортсменов 2021.07.30


// {Рарус adilas #20292 -РС Руководитель. Спортивные объекты. Количество спортсменов. 2021.09.30
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьКолонкиДляСпортсменовНаСервере()
	
	МассивДобавляемыхРеквизитов = Новый Массив;
	
	// Описание типа даты:
    НовДата = Новый ОписаниеТипов("Дата");
    // Описание даты с уточнением через квалификатор: храниться только дата, без времени
    КвалификаторыДаты = Новый КвалификаторыДаты(ЧастиДаты.Дата);
    НовДата_БезВремени = Новый ОписаниеТипов("Дата", , ,КвалификаторыДаты);
	
    МассивДобавляемыхРеквизитов.Добавить(Новый РеквизитФормы("ДатаРождения", НовДата_БезВремени, "Таблица", "Дата рождения" , Истина));
	СписокУдаляемыхРеквизитов.Добавить("Таблица" + "." + "ДатаРождения");
	МассивДобавляемыхРеквизитов.Добавить(Новый РеквизитФормы("Этап", Новый ОписаниеТипов("СправочникСсылка.ЭтапыСпортивнойПодготовки"), "Таблица", "Этап", Истина));           
	СписокУдаляемыхРеквизитов.Добавить("Таблица" + "." + "Этап");
	МассивДобавляемыхРеквизитов.Добавить(Новый РеквизитФормы("Разряд", Новый ОписаниеТипов("СправочникСсылка.СпортивнаяКлассификация"), "Таблица", "Разряд", Истина));
	СписокУдаляемыхРеквизитов.Добавить("Таблица" + "." + "Разряд");

    ИзменитьРеквизиты(МассивДобавляемыхРеквизитов);

	ТабНаФорме = ЭтаФорма.Элементы.Таблица;
	ТабНаФорме.Шапка = Истина;
	Элементы.ТаблицаЗначение.Заголовок = "Спортсмен";
	
	КолонкаДатаРождения = ЭтаФорма.Элементы.Добавить("ДатаРождения", Тип("ПолеФормы"), ТабНаФорме);
	КолонкаДатаРождения.Заголовок = "Дата рождения";
	КолонкаДатаРождения.ПутьКДанным = "Таблица" + "." + "ДатаРождения";
	КолонкаДатаРождения.Вид = ВидПоляФормы.ПолеВвода;
	
	СписокУдаляемыхЭлементов.Добавить("ДатаРождения");
	СписокКолонок.Добавить("ДатаРождения");
	
	КолонкаЭтап = ЭтаФорма.Элементы.Добавить("Этап", Тип("ПолеФормы"), ТабНаФорме);
	КолонкаЭтап.Заголовок = "Этап";
	КолонкаЭтап.ПутьКДанным = "Таблица" + "." + "Этап";
	КолонкаЭтап.Вид = ВидПоляФормы.ПолеВвода;
	
	СписокУдаляемыхЭлементов.Добавить("Этап");
	СписокКолонок.Добавить("Этап");
	
	КолонкаРазряд = ЭтаФорма.Элементы.Добавить("Разряд", Тип("ПолеФормы"), ТабНаФорме);
	КолонкаРазряд.Заголовок = "Разряд";
	КолонкаРазряд.ПутьКДанным = "Таблица" + "." + "Разряд";
	КолонкаРазряд.Вид = ВидПоляФормы.ПолеВвода;
	
	СписокУдаляемыхЭлементов.Добавить("Разряд");
	СписокКолонок.Добавить("Разряд");
	
КонецПроцедуры

&НаСервере
Процедура УдалитьКолонкиДляСпортсменовНаСервере()

	Для Каждого ЭлементСписка Из СписокУдаляемыхЭлементов Цикл
		
		НайденныйЭлементФормы = ЭтаФорма.Элементы.Найти(ЭлементСписка.Значение);
		Если НайденныйЭлементФормы <> Неопределено  Тогда
			ЭтаФорма.Элементы.Удалить(НайденныйЭлементФормы);
		КонецЕсли;
		
	КонецЦикла;
	
	МассивУдаляемыхРеквизитов = Новый Массив;
	
	Для Каждого ЭлементСписка Из СписокУдаляемыхРеквизитов Цикл
        МассивУдаляемыхРеквизитов.Добавить(ЭлементСписка.Значение);
	КонецЦикла;
		
	ИзменитьРеквизиты(, МассивУдаляемыхРеквизитов);
	
	СписокУдаляемыхРеквизитов.Очистить();
    СписокУдаляемыхЭлементов.Очистить();
	СписокКолонок.Очистить();
	
КонецПроцедуры	

#КонецОбласти
// }Рарус adilas #20292 -РС Руководитель. Спортивные объекты. Количество спортсменов. 2021.09.30