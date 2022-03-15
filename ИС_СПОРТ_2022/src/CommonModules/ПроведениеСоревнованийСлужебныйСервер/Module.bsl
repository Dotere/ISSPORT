
Процедура ПроверитьСоответствиеВозрастныхГруппСпортсменов(СтруктураДанныхДокумента, МассивСпортсменовНеВключенныхВГруппу, Отказ) Экспорт
	
	тзСоставУчастников = Новый ТаблицаЗначений;
	тзСоставУчастников.Колонки.Добавить("Спортсмен", Новый ОписаниеТипов("СправочникСсылка.Спортсмены"));
	тзСоставУчастников.Колонки.Добавить("МеждународнаяВозрастнаяГруппа", Новый ОписаниеТипов("СправочникСсылка.МеждународныеВозрастныеГруппы"));
	
	Для Каждого СтруктураТаблицыДокумента Из СтруктураДанныхДокумента.СоставУчастниковДокумента Цикл
		СтрокаТзСоставУчастников = тзСоставУчастников.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТзСоставУчастников,СтруктураТаблицыДокумента);
	КонецЦикла;	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТЧ_СоставСпортсменов"  , тзСоставУчастников);
	Запрос.УстановитьПараметр("ДатаДокумента"         , СтруктураДанныхДокумента.Дата);
	Запрос.УстановитьПараметр("УчебныйГод"                 , СтруктураДанныхДокумента.УчебныйГод);
	Запрос.УстановитьПараметр("Организация"           , СтруктураДанныхДокумента.Организация);
	Запрос.УстановитьПараметр("ВидСпорта"             , СтруктураДанныхДокумента.ВидСпорта);
	
	ТекстЗапроса ="";
	// {Рарус adilas #- -Sonar 2021.06.29
	УчетСпортсменовВызовСервера.ВвестиСтруктуруВоВременнуюТаблицу(
	   ТекстЗапроса,
	   Новый Структура("Спортсмен,МеждународнаяВозрастнаяГруппа"),
	   "ВТ_СоставСпортсменовПоДокументу",
	   "ТЧ_СоставСпортсменов");
	   
	   
	   ТекстЗапроса = ТекстЗапроса + "
	   |;
	   |////////////////////////////////////////////////////////////////////////////////
	   |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	   |	ВТ_СоставСпортсменовПоДокументу.Спортсмен КАК Спортсмен,
	   |	ВТ_СоставСпортсменовПоДокументу.МеждународнаяВозрастнаяГруппа КАК МеждународнаяВозрастнаяГруппа,
	   |	ГОД(&ДатаДокумента) - ГОД(ФизическиеЛица.ДатаРождения) - ВЫБОР
	   |		КОГДА МЕСЯЦ(&ДатаДокумента) < МЕСЯЦ(ФизическиеЛица.ДатаРождения)
	   |			ТОГДА 1
	   |		ИНАЧЕ ВЫБОР
	   |				КОГДА МЕСЯЦ(&ДатаДокумента) = МЕСЯЦ(ФизическиеЛица.ДатаРождения)
	   |						И ДЕНЬ(&ДатаДокумента) < ДЕНЬ(ФизическиеЛица.ДатаРождения)
	   |					ТОГДА 1
	   |				ИНАЧЕ 0
	   |			КОНЕЦ
	   |	КОНЕЦ КАК ВозрастВГодах,
	   |    МеждународныеВозрастныеГруппы.ВозрастОт КАК ВозрастОт,
       |	МеждународныеВозрастныеГруппы.ВозрастДо КАК ВозрастДо
	   |ПОМЕСТИТЬ ВТ_СоставСпортсменов
	   |ИЗ
	   |	ВТ_СоставСпортсменовПоДокументу КАК ВТ_СоставСпортсменовПоДокументу
	   |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ФизическиеЛица
	   |		ПО ВТ_СоставСпортсменовПоДокументу.Спортсмен.ФизическоеЛицо = ФизическиеЛица.Ссылка
	   |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.МеждународныеВозрастныеГруппы КАК МеждународныеВозрастныеГруппы
       |        ПО ВТ_СоставСпортсменовПоДокументу.МеждународнаяВозрастнаяГруппа = МеждународныеВозрастныеГруппы.Ссылка
	   |;
	   |
	   |////////////////////////////////////////////////////////////////////////////////
	   |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	   |	ВозрастныеГруппыПоУчебнымГодам.Спортсмен КАК Спортсмен,
	   |	ВозрастныеГруппыПоУчебнымГодам.МеждународнаяВозрастнаяГруппа КАК МеждународнаяВозрастнаяГруппа
	   |ПОМЕСТИТЬ ВТ_УстановленныеВозрастныеГруппыСпортсмена
	   |ИЗ
	   |	РегистрСведений.МеждународныеВозрастныеГруппы.СрезПоследних(
	   |			&ДатаДокумента,
	   |			Спортсмен В (
	   |                         ВЫБРАТЬ
	   |                           ВТ_СоставСпортсменов.Спортсмен Из ВТ_СоставСпортсменов)
	   |				И Организация = &Организация
	   |				И УчебныйГод = &УчебныйГод
	   |				И ВидСпорта = &ВидСпорта) КАК ВозрастныеГруппыПоУчебнымГодам
	   |;
	   |
	   |////////////////////////////////////////////////////////////////////////////////
	   |ВЫБРАТЬ РАЗЛИЧНЫЕ
	   |	ВТ_СоставСпортсменов.Спортсмен КАК Спортсмен,
	   |	ВТ_СоставСпортсменов.МеждународнаяВозрастнаяГруппа КАК МеждународнаяВозрастнаяГруппа,
	   |	ВТ_СоставСпортсменов.ВозрастВГодах КАК ВозрастВГодах,
	   |	ВТ_СоставСпортсменов.ВозрастОт КАК ВозрастОт,
       |	ВТ_СоставСпортсменов.ВозрастДо КАК ВозрастДо,
	   |	ВТ_УстановленныеВозрастныеГруппыСпортсмена.МеждународнаяВозрастнаяГруппа КАК МеждународнаяВозрастнаяГруппаУстановленная
	   |ИЗ
	   |	ВТ_СоставСпортсменов КАК ВТ_СоставСпортсменов
	   |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_УстановленныеВозрастныеГруппыСпортсмена КАК ВТ_УстановленныеВозрастныеГруппыСпортсмена
	   |		ПО ВТ_СоставСпортсменов.Спортсмен = ВТ_УстановленныеВозрастныеГруппыСпортсмена.Спортсмен";
	
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.МеждународнаяВозрастнаяГруппа = Выборка.МеждународнаяВозрастнаяГруппаУстановленная Тогда
			
			Продолжить;
			
		ИначеЕсли Не Выборка.ВозрастДо = Null И Выборка.ВозрастДо < Выборка.ВозрастВГодах  Тогда
			
			Отказ = Истина;
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Проведение невозможно! Спортсмену %1 указана неверная возрастная группа: %2.
				|Спортсмен включен в группу: %3'"),
				ВРег(Выборка.Спортсмен),
		        ВРег(Выборка.МеждународнаяВозрастнаяГруппа),
				ВРег(Выборка.МеждународнаяВозрастнаяГруппаУстановленная)); 
		    ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			
		ИначеЕсли Не Выборка.ВозрастДо = Null И Выборка.ВозрастОт > Выборка.ВозрастВГодах Тогда
			
			МассивСпортсменовНеВключенныхВГруппу.Добавить(Выборка.Спортсмен);
			
		КонецЕсли;
		
	КонецЦикла;	
	
КонецПроцедуры

Функция ЗаполнитьДополнительныеДанныеНаФорме(СтруктураДанныхДокумента, Индекс = Неопределено) Экспорт
	
	ТекстОбщий  = "";
	// {Рарус adilas #- -Sonar 2021.06.29
	УчетСпортсменовВызовСервера.ВвестиСтруктуруВоВременнуюТаблицу(
	   ТекстОбщий,
	   Новый Структура("Индекс,Спортсмен"),
	   "ВТ_СписокСпортсменов",
	   "ТаблицаДанных");
	
	ТекстСтрока =  "ВЫБРАТЬ
	               |	&Индекс КАК Индекс,
	               |	&Спортсмен КАК Спортсмен
	               |ПОМЕСТИТЬ ВТ_СписокСпортсменов";
	
	таблицаДанных = СтруктураДанныхДокумента.СоставУчастников;
	Если Индекс = Неопределено Тогда
		СписокСпортсменов = таблицаДанных.ВыгрузитьКолонку("Спортсмен");
	Иначе
		СписокСпортсменов = Новый СписокЗначений;
		СписокСпортсменов.Добавить(СтруктураДанныхДокумента.СоставУчастников[Индекс].Спортсмен);
	КонецЕсли;
	
	ТаблицаЭтаповПоОрганизации = Новый ТаблицаЗначений;
	ТаблицаЭтаповПоОрганизации.Колонки.Добавить("Пол", Новый ОписаниеТипов("ПеречислениеСсылка.ПолФизическогоЛица"));
	ТаблицаЭтаповПоОрганизации.Колонки.Добавить("Последовательность", Новый ОписаниеТипов("Число"));
	ТаблицаЭтаповПоОрганизации.Колонки.Добавить("Этап", Новый ОписаниеТипов("СправочникСсылка.ЭтапыСпортивнойПодготовки"));
	ТаблицаЭтаповПоОрганизации.Колонки.Добавить("МинимальныйВозраст", Новый ОписаниеТипов("Число"));
	Если СтруктураДанныхДокумента.Свойство("ВыбиратьСледЭтап") Тогда
	   СформироватьТаблицуЭтаповОрганизации(СтруктураДанныхДокумента, ТаблицаЭтаповПоОрганизации);
	КонецЕсли;   
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Индекс", Индекс);
	Запрос.УстановитьПараметр("Спортсмен"  , ?(Индекс = Неопределено, Неопределено, СтруктураДанныхДокумента.СоставУчастников[Индекс].Спортсмен));
	Запрос.УстановитьПараметр("СписокСпортсменов", СписокСпортсменов);
	Запрос.УстановитьПараметр("УчебныйГод", СтруктураДанныхДокумента.УчебныйГод);
	Запрос.УстановитьПараметр("Организация", СтруктураДанныхДокумента.Организация);
	Запрос.УстановитьПараметр("ТаблицаДанных", таблицаДанных);
	ДатаДокумента = ?(СтруктураДанныхДокумента.Свойство("ДатаНачалаСоревнования"), СтруктураДанныхДокумента.ДатаНачалаСоревнования, СтруктураДанныхДокумента.ДатаПроведения);
	Запрос.УстановитьПараметр("Дата", ДатаДокумента);
	Запрос.УстановитьПараметр("ВидСпорта", СтруктураДанныхДокумента.ВидСпорта);
	
	Запрос.Текст = ?(Индекс = Неопределено,ТекстОбщий,ТекстСтрока) + "
	     |ИНДЕКСИРОВАТЬ ПО
		 |	Спортсмен
		 |;
		 |
		 |////////////////////////////////////////////////////////////////////////////////
		 |ВЫБРАТЬ РАЗРЕШЕННЫЕ
         |	ПодтвержденныеРазряды.Спортсмен КАК Спортсмен,
         |	МАКСИМУМ(ПодтвержденныеРазряды.Период) КАК Период
         |ПОМЕСТИТЬ ВТ_МаксимумРазряды
         |ИЗ
         |	РегистрСведений.ПодтвержденныеРазрядыСпортсменов КАК ПодтвержденныеРазряды
         |ГДЕ
         |	ПодтвержденныеРазряды.Спортсмен В(&СписокСпортсменов)
         |	И ПодтвержденныеРазряды.Организация = &Организация
         |	И ПодтвержденныеРазряды.ВидСпорта = &ВидСпорта
         |	И (ПодтвержденныеРазряды.ДатаПрисвоения <= &Дата
         |				И ПодтвержденныеРазряды.ДатаПрисвоения <> ДАТАВРЕМЯ(1, 1, 1)
         |				И ПодтвержденныеРазряды.ДатаПодтверждения = ДАТАВРЕМЯ(1, 1, 1)
         |			ИЛИ ПодтвержденныеРазряды.ДатаПодтверждения <= &Дата
         |				И ПодтвержденныеРазряды.ДатаПодтверждения <> ДАТАВРЕМЯ(1, 1, 1)
         |				И ПодтвержденныеРазряды.ДатаПрисвоения = ДАТАВРЕМЯ(1, 1, 1))
         |
         |СГРУППИРОВАТЬ ПО
         |	ПодтвержденныеРазряды.Спортсмен
         |
         |ИНДЕКСИРОВАТЬ ПО
         |	Спортсмен
         |;
         |
         |////////////////////////////////////////////////////////////////////////////////
         |ВЫБРАТЬ РАЗРЕШЕННЫЕ
         |	ВТ_МаксимумРазряды.Спортсмен КАК Спортсмен,
         |	ПодтвержденныеРазрядыСпортсменов.Разряд КАК Разряд
         |ПОМЕСТИТЬ ВТ_Разряды
         |ИЗ
         |	ВТ_МаксимумРазряды КАК ВТ_МаксимумРазряды
         |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПодтвержденныеРазрядыСпортсменов КАК ПодтвержденныеРазрядыСпортсменов
         |		ПО ВТ_МаксимумРазряды.Спортсмен = ПодтвержденныеРазрядыСпортсменов.Спортсмен
         |			И ВТ_МаксимумРазряды.Период = ПодтвержденныеРазрядыСпортсменов.Период
         |
         |ИНДЕКСИРОВАТЬ ПО
         |	Спортсмен
         |;
         |
         |////////////////////////////////////////////////////////////////////////////////
         |ВЫБРАТЬ РАЗРЕШЕННЫЕ
         |	РегистрацияДопусков.Спортсмен КАК Спортсмен,
         |	МАКСИМУМ(РегистрацияДопусков.Период) КАК Период
         |ПОМЕСТИТЬ ВТ_МаксимумДопуск
         |ИЗ
         |	РегистрСведений.РегистрацияДопусковКСпортивнымСоревнованиям.СрезПоследних(&Дата, Спортсмен В (&СписокСпортсменов)) КАК РегистрацияДопусков
         |
         |СГРУППИРОВАТЬ ПО
         |	РегистрацияДопусков.Спортсмен
         |
         |ИНДЕКСИРОВАТЬ ПО
         |	Спортсмен
         |;
         |
         |////////////////////////////////////////////////////////////////////////////////
         |ВЫБРАТЬ РАЗРЕШЕННЫЕ
         |	ВТ_МаксимумДопуск.Спортсмен КАК Спортсмен,
         |	РегистрацияДопусков.ДействуетДо КАК ДействуетДо,
         |	РегистрацияДопусков.Регистратор КАК ДопускРегистратор
         |ПОМЕСТИТЬ ВТ_Допуски
         |ИЗ
         |	ВТ_МаксимумДопуск КАК ВТ_МаксимумДопуск
         |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РегистрацияДопусковКСпортивнымСоревнованиям КАК РегистрацияДопусков
         |		ПО ВТ_МаксимумДопуск.Спортсмен = РегистрацияДопусков.Спортсмен
         |			И ВТ_МаксимумДопуск.Период = РегистрацияДопусков.Период
         |
         |ИНДЕКСИРОВАТЬ ПО
         |	Спортсмен
         |;
         |
         |////////////////////////////////////////////////////////////////////////////////
         |ВЫБРАТЬ РАЗРЕШЕННЫЕ
         |	СоставГруппы.Спортсмен КАК Спортсмен,
         |	СоставГруппы.Группа КАК Группа
         |ПОМЕСТИТЬ ВТ_Группы
         |ИЗ
         |	РегистрСведений.СоставГруппы.СрезПоследних(
         |			&Дата,
         |			УчебныйГод = &УчебныйГод
         |				И Спортсмен В (&СписокСпортсменов)) КАК СоставГруппы
         |
         |ИНДЕКСИРОВАТЬ ПО
         |	Спортсмен
         |;
         |
         |////////////////////////////////////////////////////////////////////////////////
         |ВЫБРАТЬ РАЗРЕШЕННЫЕ
         |	РегистрацияСтраховыхПолисов.Спортсмен КАК Спортсмен,
         |	МАКСИМУМ(РегистрацияСтраховыхПолисов.Период) КАК Период
         |ПОМЕСТИТЬ ВТ_СтраховыеПолисяМаксимум
         |ИЗ
         |	РегистрСведений.РегистрацияСтраховыхПолисовСпортсменов КАК РегистрацияСтраховыхПолисов
         |ГДЕ
		 // {Рарус dotere #21973 -Убрано условие на вид спорта 2021.11.02
		 |	РегистрацияСтраховыхПолисов.Спортсмен В(&СписокСпортсменов)
         |	И РегистрацияСтраховыхПолисов.Организация = &Организация
		 // }Рарус dotere #21973 -Убрано условие на вид спорта 2021.11.02
		 |
         |СГРУППИРОВАТЬ ПО
         |	РегистрацияСтраховыхПолисов.Спортсмен
         |;
         |
         |////////////////////////////////////////////////////////////////////////////////
         |ВЫБРАТЬ РАЗРЕШЕННЫЕ
         |	ВТ_СтраховыеПолисяМаксимум.Спортсмен КАК Спортсмен,
         |	РегистрацияСтраховыхПолисовСпортсменов.Регистратор КАК СтраховойПолисРегистратор,
         |	РегистрацияСтраховыхПолисовСпортсменов.СтраховаяКомпания КАК СтраховаяКомпания,
         |	РегистрацияСтраховыхПолисовСпортсменов.ДатаНачала КАК ДатаНачала,
         |	РегистрацияСтраховыхПолисовСпортсменов.ДатаОкончания КАК ДатаОкончания,
         |	РегистрацияСтраховыхПолисовСпортсменов.НомерСтраховогоПолиса КАК НомерСтраховогоПолиса,
         |	РегистрацияСтраховыхПолисовСпортсменов.ДатаВыдачиПолиса КАК ДатаВыдачиПолиса
         |ПОМЕСТИТЬ ВТ_СтраховыеПолисы
         |ИЗ
         |	ВТ_СтраховыеПолисяМаксимум КАК ВТ_СтраховыеПолисяМаксимум
         |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РегистрацияСтраховыхПолисовСпортсменов КАК РегистрацияСтраховыхПолисовСпортсменов
         |		ПО ВТ_СтраховыеПолисяМаксимум.Спортсмен = РегистрацияСтраховыхПолисовСпортсменов.Спортсмен
         |			И ВТ_СтраховыеПолисяМаксимум.Период = РегистрацияСтраховыхПолисовСпортсменов.Период
         |;
         |
         |////////////////////////////////////////////////////////////////////////////////
         |ВЫБРАТЬ РАЗРЕШЕННЫЕ
         |	ЭтапыСпортивнойПодготовкиСпортсменов.Этап КАК ТекущийЭтап,
         |	ЕСТЬNULL(ЭтапыСпортивнойПодготовки.Ссылка, СледЭтапыСпортивнойПодготовки.Ссылка) КАК СледующийЭтап,
         |	ЭтапыСпортивнойПодготовкиСпортсменов.Организация КАК Организация,
         |	ЭтапыСпортивнойПодготовкиСпортсменов.ВидСпорта КАК ВидСпорта,
         |	ЭтапыСпортивнойПодготовкиСпортсменов.Спортсмен КАК Спортсмен,
         |	ЭтапыСпортивнойПодготовкиСпортсменов.Тренер КАК Тренер
         |ПОМЕСТИТЬ ВТ_Этапы
         |ИЗ
         |	РегистрСведений.ЭтапыСпортивнойПодготовкиСпортсменов.СрезПоследних(
         |			&Дата,
         |			ВидСпорта = &Видспорта
         |				И Организация = &Организация
         |				И Спортсмен В (&СписокСпортсменов)) КАК ЭтапыСпортивнойПодготовкиСпортсменов
         |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЭтапыСпортивнойПодготовки КАК ЭтапыСпортивнойПодготовки
         |		ПО (ЭтапыСпортивнойПодготовки.Родитель = ЭтапыСпортивнойПодготовкиСпортсменов.Этап.Родитель)
         |			И (ЭтапыСпортивнойПодготовки.Последовательность = ЭтапыСпортивнойПодготовкиСпортсменов.Этап.Последовательность + 1)
         |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЭтапыСпортивнойПодготовки КАК СледЭтапыСпортивнойПодготовки
         |		ПО (СледЭтапыСпортивнойПодготовки.Родитель.Последовательность = ЭтапыСпортивнойПодготовкиСпортсменов.Этап.Родитель.Последовательность + 1)
         |			И (СледЭтапыСпортивнойПодготовки.Последовательность = 1)
         |;
         |
         |////////////////////////////////////////////////////////////////////////////////
         |ВЫБРАТЬ РАЗРЕШЕННЫЕ
         |	ВТ_СписокСпортсменов.Индекс КАК Индекс,
         |	ВЫБОР
         |		КОГДА ВТ_Допуски.ДействуетДо ЕСТЬ NULL
         |			ТОГДА ""НЕ ДОПУЩЕН""
         |		КОГДА ВТ_Допуски.ДействуетДо < &Дата
         |			ТОГДА ""НЕ ДОПУЩЕН""
         |		ИНАЧЕ ""ДОПУЩЕН""
         |	КОНЕЦ КАК Допуск,
         |	ЕСТЬNULL(ВТ_Допуски.ДействуетДо, ДАТАВРЕМЯ(1, 1, 1)) КАК ДействуетДо,
         |	ВТ_Допуски.ДопускРегистратор КАК ДопускРегистратор,
         |	ВТ_Группы.Группа КАК Группа,
         |	ЭтапыСпортивнойПодготовкиСпортсменов.Тренер КАК Тренер,
         |	ЭтапыСпортивнойПодготовкиСпортсменов.Организация КАК СпортивноеУчреждение,
         |	ВТ_Разряды.Разряд КАК Разряд,
         |	ЕСТЬNULL(ВТ_СтраховыеПолисы.СтраховойПолисРегистратор, ЗНАЧЕНИЕ(Документ.СтраховойПолисСпортсмена.ПустаяСсылка)) КАК СтраховойПолисРегистратор,
         |	ВТ_СтраховыеПолисы.СтраховаяКомпания КАК СтраховаяКомпания,
         |	ВТ_СтраховыеПолисы.ДатаНачала КАК ДатаНачала,
         |	ВТ_СтраховыеПолисы.ДатаОкончания КАК ДатаОкончания,
         |	ВТ_СтраховыеПолисы.НомерСтраховогоПолиса КАК НомерСтраховогоПолиса,
         |	ВТ_СтраховыеПолисы.ДатаВыдачиПолиса КАК ДатаВыдачиПолиса,
         |	ФизическиеЛица.Пол КАК Пол,
         |	ВЫБОР
         |		КОГДА ФизическиеЛица.Пол = ЗНАЧЕНИЕ(перечисление.полфизическоголица.женский)
         |			ТОГДА ""Ж""
         |		КОГДА ФизическиеЛица.Пол = ЗНАЧЕНИЕ(перечисление.полфизическоголица.мужской)
         |			ТОГДА ""М""
         |		ИНАЧЕ ""Неопределен""
         |	КОНЕЦ КАК ПолПредставление,
         |	ФизическиеЛица.ГодРождения КАК ГодРождения,
         |	МеждународныеВозрастныеГруппы.МеждународнаяВозрастнаяГруппа КАК МеждународнаяВозрастнаяГруппа,
         |	ЭтапыСпортивнойПодготовкиСпортсменов.ТекущийЭтап КАК ТекущийЭтап,
         |	ЭтапыСпортивнойПодготовкиСпортсменов.СледующийЭтап КАК СледующийЭтап,
         |	ВТ_СписокСпортсменов.Спортсмен КАК Спортсмен
         |ИЗ
         |	ВТ_СписокСпортсменов КАК ВТ_СписокСпортсменов
         |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Разряды КАК ВТ_Разряды
         |		ПО ВТ_СписокСпортсменов.Спортсмен = ВТ_Разряды.Спортсмен
         |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Допуски КАК ВТ_Допуски
         |		ПО ВТ_СписокСпортсменов.Спортсмен = ВТ_Допуски.Спортсмен
         |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Группы КАК ВТ_Группы
         |		ПО ВТ_СписокСпортсменов.Спортсмен = ВТ_Группы.Спортсмен
         |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СтраховыеПолисы КАК ВТ_СтраховыеПолисы
         |		ПО ВТ_СписокСпортсменов.Спортсмен = ВТ_СтраховыеПолисы.Спортсмен
         |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ФизическиеЛица
         |		ПО ВТ_СписокСпортсменов.Спортсмен.ФизическоеЛицо = ФизическиеЛица.Ссылка
         |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МеждународныеВозрастныеГруппы.СрезПоследних(
         |				,
         |				Организация = &Организация
         |					И УчебныйГод = &УчебныйГод
         |					И ВидСпорта = &ВидСпорта) КАК МеждународныеВозрастныеГруппы
         |		ПО ВТ_СписокСпортсменов.Спортсмен = МеждународныеВозрастныеГруппы.Спортсмен
         |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Этапы КАК ЭтапыСпортивнойПодготовкиСпортсменов
         |		ПО ВТ_СписокСпортсменов.Спортсмен = ЭтапыСпортивнойПодготовкиСпортсменов.Спортсмен";

	Возврат Запрос.Выполнить().Выбрать()
	
КонецФункции

Процедура СформироватьТаблицуЭтаповОрганизации(СтруктураДанныхДокумента, ТаблицаЭтаповПоОрганизации)
	
	ЗапросЭтапы = Новый Запрос;
	ЗапросЭтапы.УстановитьПараметр("Организация", СтруктураДанныхДокумента.Организация);
	ЗапросЭтапы.УстановитьПараметр("Дата", СтруктураДанныхДокумента.ДатаНачалаСоревнования);
	ЗапросЭтапы.УстановитьПараметр("ВидСпорта", СтруктураДанныхДокумента.ВидСпорта);
	
	ЗапросЭтапы.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                    |	НастройкиЭтаповПоОрганизациям.Этап.Родитель КАК ЭтапРодитель,
	                    |	НастройкиЭтаповПоОрганизациям.Этап КАК Этап,
	                    |	НастройкиЭтаповПоОрганизациям.Пол КАК Пол,
	                    |	НастройкиЭтаповПоОрганизациям.МинимальныйВозраст КАК МинимальныйВозраст
	                    |ПОМЕСТИТЬ ВТ_ЭтапыОрганизации
	                    |ИЗ
	                    |	РегистрСведений.НастройкиЭтаповПоОрганизациям.СрезПоследних(
	                    |			&Дата,
	                    |			Организация = &Организация
	                    |				И ВидСпорта = &ВидСпорта) КАК НастройкиЭтаповПоОрганизациям
	                    |;
	                    |
	                    |////////////////////////////////////////////////////////////////////////////////
	                    |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                    |	НастройкаКоличестваПодэтапов.Этап КАК Этап,
	                    |	СУММА(НастройкаКоличестваПодэтапов.КоличествоПодэтапов) КАК КоличествоПодэтапов
	                    |ПОМЕСТИТЬ ВТ_КоличествоПодэтаповВЭтапеРодителе
	                    |ИЗ
	                    |	РегистрСведений.НастройкаКоличестваПодэтапов КАК НастройкаКоличестваПодэтапов
	                    |ГДЕ
	                    |	НастройкаКоличестваПодэтапов.Организация = &Организация
	                    |	И НастройкаКоличестваПодэтапов.ВидСпорта = &ВидСпорта
	                    |
	                    |СГРУППИРОВАТЬ ПО
	                    |	НастройкаКоличестваПодэтапов.Этап
	                    |;
	                    |
	                    |////////////////////////////////////////////////////////////////////////////////
	                    |ВЫБРАТЬ
	                    |	ВТ_ЭтапыОрганизации.ЭтапРодитель КАК ЭтапРодитель,
	                    |	ВТ_ЭтапыОрганизации.Этап КАК Этап,
	                    |	ВТ_ЭтапыОрганизации.Пол КАК Пол,
	                    |	ВТ_ЭтапыОрганизации.МинимальныйВозраст КАК МинимальныйВозраст,
	                    |	ЕСТЬNULL(ВТ_КоличествоПодэтаповВЭтапеРодителе.КоличествоПодэтапов, 5) КАК КоличествоПоэтапов
	                    |ПОМЕСТИТЬ ВТ_НастройкиЭтаповОрганизции
	                    |ИЗ
	                    |	ВТ_ЭтапыОрганизации КАК ВТ_ЭтапыОрганизации
	                    |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КоличествоПодэтаповВЭтапеРодителе КАК ВТ_КоличествоПодэтаповВЭтапеРодителе
	                    |		ПО ВТ_ЭтапыОрганизации.ЭтапРодитель = ВТ_КоличествоПодэтаповВЭтапеРодителе.Этап
	                    |;
	                    |
	                    |////////////////////////////////////////////////////////////////////////////////
	                    |ВЫБРАТЬ
	                    |	ЭтапыСпортивнойПодготовки.Ссылка КАК Этап,
	                    |	ЭтапыСпортивнойПодготовки.Последовательность КАК Последовательность,
	                    |	ЭтапыСпортивнойПодготовки.Родитель КАК ЭтапРодитель,
	                    |	ЭтапыСпортивнойПодготовки.Родитель.Последовательность КАК ЭтапРодительПоследовательность,
	                    |	ВТ_НастройкиЭтаповОрганизции.Пол КАК Пол,
	                    |	ВТ_НастройкиЭтаповОрганизции.МинимальныйВозраст КАК МинимальныйВозраст,
	                    |	ВТ_НастройкиЭтаповОрганизции.КоличествоПоэтапов КАК КоличествоПоэтапов
	                    |ИЗ
	                    |	Справочник.ЭтапыСпортивнойПодготовки КАК ЭтапыСпортивнойПодготовки
	                    |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_НастройкиЭтаповОрганизции КАК ВТ_НастройкиЭтаповОрганизции
	                    |		ПО ЭтапыСпортивнойПодготовки.Ссылка = ВТ_НастройкиЭтаповОрганизции.Этап
	                    |			И ЭтапыСпортивнойПодготовки.Родитель = ВТ_НастройкиЭтаповОрганизции.ЭтапРодитель
	                    |ГДЕ
	                    |	ЭтапыСпортивнойПодготовки.Родитель <> ЗНАЧЕНИЕ(справочник.ЭтапыСпортивнойПодготовки.пустаяссылка)
	                    |
	                    |УПОРЯДОЧИТЬ ПО
	                    |	ЭтапРодительПоследовательность,
	                    |	Последовательность
	                    |ИТОГИ ПО
	                    |	ЭтапРодитель";
	
	Пакет = ЗапросЭтапы.ВыполнитьПакет();
	
	ВыборкаЭтапРодитель = Пакет[3].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаЭтапРодитель.Следующий() Цикл
	КонецЦикла;	
	
КонецПроцедуры	


