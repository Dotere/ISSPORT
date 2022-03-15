#Область СлужебныйПрограммныйИнтерфейс

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	
	Отказ = Ложь;
	
	// {Рарус adilas #10048 -Реквизиты дат для документов 2020.10.09
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка"       , ДокументСсылка);
	// {Рарус adilas #10048 -Реквизиты дат для документов 2020.10.09
	Запрос.УстановитьПараметр("Период"       , ДокументСсылка.ДатаПеревода);
	// }Рарус adilas #10048 -Реквизиты дат для документов 2020.10.09
	Запрос.УстановитьПараметр("УчебныйГод"   , ДокументСсылка.УчебныйГод);
	Запрос.УстановитьПараметр("Организация"  , ДокументСсылка.Организация);
	Запрос.УстановитьПараметр("Группа"       , ДокументСсылка.Группа);
	Запрос.УстановитьПараметр("ТренерСборной", ДокументСсылка.ТренерСборной);
	Запрос.УстановитьПараметр("ВидСпорта"    , ДокументСсылка.ВидСпорта);
	Запрос.Текст =  "ВЫБРАТЬ
					// {Рарус adilas #10048 -Реквизиты дат для документов 2020.10.09
					// Было ""СоставКоманды"" КАК ИмяРегистра_, 
	                |	""СоставГруппы"" КАК ИмяРегистра_,
					// }Рарус adilas #10048 -Реквизиты дат для документов 2020.10.09
	                |	&Период КАК Период,
	                |	&УчебныйГод КАК УчебныйГод,
	                |	&Организация КАК Организация,
	                |	&Группа КАК Группа,
	                |	&ТренерСборной КАК ТренерСборной,
	                |	&ВидСпорта КАК ВидСпорта,
	                |	Спортсмены.Спортсмен КАК Спортсмен
	                |ИЗ
	                |	Документ.ПереводСпортсменовМеждуГруппами.Спортсмены КАК Спортсмены
	                |ГДЕ
	                |	Спортсмены.Ссылка = &Ссылка
	                |;
	                |
	                |////////////////////////////////////////////////////////////////////////////////
	                |ВЫБРАТЬ
	                |	""ЛичныйТренерСпортсмена"" КАК ИмяРегистра_,
	                |	&Период КАК Период,
	                |	&УчебныйГод КАК УчебныйГод,
	                |	&Организация КАК Организация,
	                |	&Группа КАК Группа,
	                |	&ВидСпорта КАК ВидСпорта,
	                |	СписокЛичныхТренеров.Тренер КАК Тренер,
	                |	ГруппыСпортсмены.Спортсмен КАК Спортсмен,
	                |	СписокЛичныхТренеров.ДатаНачалаРаботыСТренером КАК ДатаНачалаРаботыСТренером,
	                |	СписокЛичныхТренеров.ДатаОкончанияРаботыСТренером КАК ДатаОкончанияРаботыСТренером
	                |ИЗ
	                |	Документ.ПереводСпортсменовМеждуГруппами.Спортсмены КАК ГруппыСпортсмены
	                |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПереводСпортсменовМеждуГруппами.СписокЛичныхТренеров КАК СписокЛичныхТренеров
	                |		ПО ГруппыСпортсмены.Ссылка = СписокЛичныхТренеров.Ссылка
	                |			И ГруппыСпортсмены.КлючСтроки = СписокЛичныхТренеров.КлючСтроки
	                |ГДЕ
	                |	ГруппыСпортсмены.Ссылка = &Ссылка
	                |	И СписокЛичныхТренеров.Тренер <> ЗНАЧЕНИЕ(справочник.тренеры.пустаяссылка)";
	// }Рарус adilas #10048 -Реквизиты дат для документов 2020.10.09
	Пакет = Запрос.ВыполнитьПакет();
	
	ТаблицаСоставГруппы            = Пакет[0].Выгрузить();
	ТаблицаЛичныйТренерСпортсмена  = Пакет[1].Выгрузить();
	
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ТаблицыДляДвижений.Вставить("ТаблицаСоставГруппы"            , ТаблицаСоставГруппы);
	ТаблицыДляДвижений.Вставить("ТаблицаЛичныйТренерСпортсмена"  , ТаблицаЛичныйТренерСпортсмена);
	
    ДополнительныеСвойства.Вставить("Отказ", Отказ);
	
КонецПроцедуры	

Процедура ВыполнитьКонтрольРезультатовПроведения(Объект, Отказ) Экспорт
	
	Если Ложь Тогда
		Объект = Документы.ПереводСпортсменовМеждуГруппами.СоздатьДокумент();
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьКонтрольПередПроведением(Объект, Отказ) Экспорт
	
	Если Ложь Тогда
		Объект = Документы.ПереводСпортсменовМеждуГруппами.СоздатьДокумент();
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьКонтрольРезультатовОтменыПроведения(Объект, Отказ) Экспорт
	
	Если Ложь Тогда
		Объект = Документы.ПереводСпортсменовМеждуГруппами.СоздатьДокумент();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// {Рарус dotere #22992 -Печатная форма 2021.12.15
#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт 
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Перевод") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Перевод", "Перевод", СформироватьПечатнуюФормуПеревод(МассивОбъектов));
    КонецЕсли	
КонецПроцедуры

Функция СформироватьПечатнуюФормуПеревод(МассивОбъектовДляПечати) Экспорт
	
	Если ТипЗнч(МассивОбъектовДляПечати) = Тип("Массив") Тогда
		
		МассивОбъектов = МассивОбъектовДляПечати;
		
	Иначе
		
		МассивОбъектов = Новый Массив;
		МассивОбъектов.Добавить(МассивОбъектовДляПечати);
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПереводСпортсменовМеждуГруппами.Ссылка КАК Ссылка,
		|	ПереводСпортсменовМеждуГруппами.Организация КАК Организация,
		|	ПереводСпортсменовМеждуГруппами.ВидСпорта КАК ВидСпорта,
		|	ПереводСпортсменовМеждуГруппами.НомерДокумента КАК НомерДокумента,
		|	ПереводСпортсменовМеждуГруппами.ДатаДокумента КАК ДатаДокумента,
		|	ПереводСпортсменовМеждуГруппами.ТренерСборнойПредыдущий КАК ТренерСборнойПредыдущий,
		|	ПереводСпортсменовМеждуГруппами.ТренерСборной КАК ТренерСборной,
		|	ПереводСпортсменовМеждуГруппами.ГруппаПредыдущая КАК ГруппаПредыдущая,
		|	ПереводСпортсменовМеждуГруппами.Группа КАК Группа
		|ПОМЕСТИТЬ ВТ_Документ
		|ИЗ
		|	Документ.ПереводСпортсменовМеждуГруппами КАК ПереводСпортсменовМеждуГруппами
		|ГДЕ
		|	ПереводСпортсменовМеждуГруппами.Ссылка В(&МассивОбъектов)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПереводСпортсменовМеждуГруппамиСпортсмены.Спортсмен КАК Спортсмен,
		|	ПереводСпортсменовМеждуГруппамиСпортсмены.Ссылка КАК Ссылка,
		|	Спортсмены.ФизическоеЛицо КАК ФизическоеЛицо
		|ПОМЕСТИТЬ ВТ_Спортсмены
		|ИЗ
		|	Документ.ПереводСпортсменовМеждуГруппами.Спортсмены КАК ПереводСпортсменовМеждуГруппамиСпортсмены
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Спортсмены КАК Спортсмены
		|		ПО ПереводСпортсменовМеждуГруппамиСпортсмены.Спортсмен = Спортсмены.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВТ_Документ.Ссылка КАК Ссылка,
		|	ВТ_Документ.Организация КАК Организация,
		|	ВТ_Документ.ВидСпорта КАК ВидСпорта,
		|	ВТ_Документ.НомерДокумента КАК НомерДокумента,
		|	ВТ_Документ.ДатаДокумента КАК ДатаДокумента,
		|	ВТ_Документ.ТренерСборнойПредыдущий КАК ТренерСборнойПредыдущий,
		|	ВТ_Документ.ТренерСборной КАК ТренерСборной,
		|	ВТ_Документ.ГруппаПредыдущая КАК ГруппаПредыдущая,
		|	ВТ_Документ.Группа КАК Группа,
		|	ВТ_Спортсмены.Спортсмен КАК Спортсмен,
		|	ВТ_Спортсмены.ФизическоеЛицо КАК ФизическоеЛицо
		|ПОМЕСТИТЬ ВТ_Данные
		|ИЗ
		|	ВТ_Документ КАК ВТ_Документ
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Спортсмены КАК ВТ_Спортсмены
		|		ПО ВТ_Документ.Ссылка = ВТ_Спортсмены.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВТ_Данные.Ссылка КАК Ссылка,
		|	ВТ_Данные.Организация КАК Организация,
		|	ВТ_Данные.ВидСпорта КАК ВидСпорта,
		|	ВТ_Данные.НомерДокумента КАК НомерДокумента,
		|	ВТ_Данные.ДатаДокумента КАК ДатаДокумента,
		|	ВТ_Данные.ТренерСборнойПредыдущий КАК ТренерСборнойПредыдущий,
		|	ВТ_Данные.ТренерСборной КАК ТренерСборной,
		|	ВТ_Данные.ГруппаПредыдущая КАК ГруппаПредыдущая,
		|	ВТ_Данные.Группа КАК Группа,
		|	ВТ_Данные.Спортсмен КАК Спортсмен,
		|	ПодтвержденныеРазрядыСпортсменовСрезПоследних.Разряд КАК Разряд,
		|	ВТ_Данные.ФизическоеЛицо КАК ФизическоеЛицо
		|ПОМЕСТИТЬ ВТ_Рязряд
		|ИЗ
		|	ВТ_Данные КАК ВТ_Данные
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПодтвержденныеРазрядыСпортсменов.СрезПоследних КАК ПодтвержденныеРазрядыСпортсменовСрезПоследних
		|		ПО ВТ_Данные.Спортсмен = ПодтвержденныеРазрядыСпортсменовСрезПоследних.Спортсмен
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВТ_Рязряд.Ссылка КАК Ссылка,
		|	ВТ_Рязряд.Организация КАК Организация,
		|	ВТ_Рязряд.ВидСпорта КАК ВидСпорта,
		|	ВТ_Рязряд.НомерДокумента КАК НомерДокумента,
		|	ВТ_Рязряд.ДатаДокумента КАК ДатаДокумента,
		|	ВТ_Рязряд.ТренерСборнойПредыдущий КАК ТренерСборнойПредыдущий,
		|	ВТ_Рязряд.ТренерСборной КАК ТренерСборной,
		|	ВТ_Рязряд.ГруппаПредыдущая КАК ГруппаПредыдущая,
		|	ВТ_Рязряд.Группа КАК Группа,
		|	ВТ_Рязряд.Спортсмен КАК Спортсмен,
		|	ВТ_Рязряд.Разряд КАК Разряд,
		|	ВТ_Рязряд.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ФизическиеЛица.ГодРождения КАК ГодРождения
		|ПОМЕСТИТЬ ВТ_Пред_Данные
		|ИЗ
		|	ВТ_Рязряд КАК ВТ_Рязряд
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ФизическиеЛица
		|		ПО ВТ_Рязряд.ФизическоеЛицо = ФизическиеЛица.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВТ_Пред_Данные.Ссылка КАК Ссылка,
		|	ВТ_Пред_Данные.Организация КАК Организация,
		|	ВТ_Пред_Данные.ВидСпорта КАК ВидСпорта,
		|	ВТ_Пред_Данные.НомерДокумента КАК НомерДокумента,
		|	ВТ_Пред_Данные.ДатаДокумента КАК ДатаДокумента,
		|	ВТ_Пред_Данные.ТренерСборнойПредыдущий КАК ТренерСборнойПредыдущий,
		|	ВТ_Пред_Данные.ТренерСборной КАК ТренерСборной,
		|	ВТ_Пред_Данные.ГруппаПредыдущая КАК ГруппаПредыдущаяДок,
		|	ВТ_Пред_Данные.Группа КАК ГруппаДок,
		|	ВТ_Пред_Данные.Спортсмен КАК Спортсмен,
		|	ВТ_Пред_Данные.Разряд КАК Разряд,
		|	ВТ_Пред_Данные.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ВТ_Пред_Данные.ГодРождения КАК ГодРождения,
		|	ГруппаПредыдущаяОрг.Наименование КАК ГруппаПредыдущая,
		|	ГруппаТекущая.Наименование КАК Группа
		|ПОМЕСТИТЬ ВТ_Группы
		|ИЗ
		|	ВТ_Пред_Данные КАК ВТ_Пред_Данные
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Группа КАК ГруппаТекущая
		|		ПО ВТ_Пред_Данные.Группа = ГруппаТекущая.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Группа КАК ГруппаПредыдущаяОрг
		|		ПО ВТ_Пред_Данные.ГруппаПредыдущая = ГруппаПредыдущаяОрг.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВТ_Группы.Ссылка КАК Ссылка,
		|	ВТ_Группы.Организация КАК Организация,
		|	ВТ_Группы.ВидСпорта КАК ВидСпорта,
		|	ВТ_Группы.НомерДокумента КАК НомерДокумента,
		|	ВТ_Группы.ДатаДокумента КАК ДатаДокумента,
		|	ВТ_Группы.ТренерСборнойПредыдущий КАК ТренерСборнойПредыдущий,
		|	ВТ_Группы.ТренерСборной КАК ТренерСборной,
		|	ВТ_Группы.Спортсмен КАК Спортсмен,
		|	ВТ_Группы.Разряд КАК Разряд,
		|	ВТ_Группы.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ВТ_Группы.ГодРождения КАК ГодРождения,
		|	ВТ_Группы.ГруппаПредыдущая КАК ГруппаПредыдущая,
		|	ВТ_Группы.Группа КАК Группа
		|ИЗ
		|	ВТ_Группы КАК ВТ_Группы
		|ИТОГИ ПО
		|	Ссылка";
	
	ПутьКМакету = "Документ.ПереводСпортсменовМеждуГруппами.Перевод";
	Макет = УправлениеПечатью.МакетПечатнойФормы(ПутьКМакету);
	
	ТабДок = Новый ТабличныйДокумент;
	
	ВыборкаДокумент = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ОбластьШапка = Макет.ПолучитьОбласть("ОбластьШапка");
	ОбластьШапкаТренер = Макет.ПолучитьОбласть("ОбластьШапкаТренер");
	ОбластьШапкаГруппа = Макет.ПолучитьОбласть("ОбластьШапкаГруппа");
	СтрокаСпортсмен = Макет.ПолучитьОбласть("СтрокаСпортсмен");
	ОбластьПодвалТренер = Макет.ПолучитьОбласть("ОбластьПодвалТренер");
	ОбластьПодвалГруппа = Макет.ПолучитьОбласть("ОбластьПодвалГруппа");
	ОбластьПодвал = Макет.ПолучитьОбласть("ОбластьПодвал");
	Пока ВыборкаДокумент.Следующий() Цикл
		ОбластьШапка.Параметры.Организация = ВыборкаДокумент.Ссылка.Организация.ПолноеНаименование;
		ОбластьШапка.Параметры.Дата = Формат(ВыборкаДокумент.Ссылка.ДатаДокумента,"ДЛФ=D");
		ОбластьШапка.Параметры.НомерПриказа = ВыборкаДокумент.Ссылка.НомерДокумента;
		ТабДок.Вывести(ОбластьШапка);
		Если ВыборкаДокумент.Ссылка.ТренерСборнойПредыдущий = ВыборкаДокумент.Ссылка.ТренерСборной Тогда
			ОбластьШапкаГруппа.Параметры.ДатаПеревода = Формат(ВыборкаДокумент.Ссылка.ДатаПеревода,"ДФ='dd MMMM yyyy'");
			ОбластьШапкаГруппа.Параметры.ВидСпорта = ВРег(ВыборкаДокумент.Ссылка.ВидСпорта);
			ОбластьШапкаГруппа.Параметры.ИзначальнаяГруппа = ВыборкаДокумент.Ссылка.ГруппаПредыдущая;
			ОбластьШапкаГруппа.Параметры.ГруппаПеревода = ВыборкаДокумент.Ссылка.Группа;
			ТабДок.Вывести(ОбластьШапкаГруппа);
		Иначе
			ОбластьШапкаТренер.Параметры.ДатаПеревода = Формат(ВыборкаДокумент.Ссылка.ДатаПеревода,"ДФ='dd MMMM yyyy'");
			ОбластьШапкаТренер.Параметры.ВидСпорта = ВРег(ВыборкаДокумент.Ссылка.ВидСпорта);
			ОбластьШапкаТренер.Параметры.ИзначальнаяГруппа = ВыборкаДокумент.Ссылка.ГруппаПредыдущая;
			ОбластьШапкаТренер.Параметры.ГруппаПеревода = ВыборкаДокумент.Ссылка.Группа;
			ОбластьШапкаТренер.Параметры.ИзначальныйТренер = СклонениеПредставленийОбъектов.ПросклонятьФИО(Строка(ФизическиеЛицаКлиентСервер.ФамилияИнициалы(ВыборкаДокумент.Ссылка.ТренерСборнойПредыдущий.ФизическоеЛицо)),2);
			ОбластьШапкаТренер.Параметры.ТренерПеревода = СклонениеПредставленийОбъектов.ПросклонятьФИО(Строка(ФизическиеЛицаКлиентСервер.ФамилияИнициалы(ВыборкаДокумент.Ссылка.ТренерСборной.ФизическоеЛицо)),3);
			ТабДок.Вывести(ОбластьШапкаТренер);
		КонецЕсли;
		Выборка = ВыборкаДокумент.Выбрать();
		Индекс = 1;
		Пока Выборка.Следующий() Цикл
			СтрокаСпортсмен.Параметры.НомерСпортсмена = Индекс;
			СтрокаСпортсмен.Параметры.Спортсмен = Выборка.Спортсмен;
			СтрокаСпортсмен.Параметры.ГодРождения = Выборка.ГодРождения;
			СтрокаСпортсмен.Параметры.Разряд = Выборка.Разряд;
			Индекс = Индекс + 1;
			ТабДок.Вывести(СтрокаСпортсмен);
		КонецЦикла;
		Если ВыборкаДокумент.Ссылка.ТренерСборнойПредыдущий = ВыборкаДокумент.Ссылка.ТренерСборной Тогда
			ОбластьПодвалГруппа.Параметры.Тренер = ФизическиеЛицаКлиентСервер.ФамилияИнициалы(ВыборкаДокумент.Ссылка.ТренерСборной.ФизическоеЛицо);
			ТабДок.Вывести(ОбластьПодвалГруппа);
		Иначе
			ОбластьПодвалТренер.Параметры.Тренер = ФизическиеЛицаКлиентСервер.ФамилияИнициалы(ВыборкаДокумент.Ссылка.ТренерСборной.ФизическоеЛицо);
			ТабДок.Вывести(ОбластьПодвалТренер);
		КонецЕсли;
		ОбластьПодвал.Параметры.Директор = ФизическиеЛицаКлиентСервер.ФамилияИнициалы(ВыборкаДокумент.Ссылка.Организация.Директор);
		ТабДок.Вывести(ОбластьПодвал);
		ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЦикла;
	
	ТабДок.КлючПараметровПечати	= ПутьКМакету;
	ТабДок.ОриентацияСтраницы 	= ОриентацияСтраницы.Портрет;
	ТабДок.АвтоМасштаб 			= Истина;
	
	Возврат ТабДок;
КонецФункции
// }Рарус dotere #22992 -Печатая форма 2021.12.15


#КонецОбласти