
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)

    СтандартнаяОбработка = Ложь;
    
    Поля.Добавить("Соревнование");
	Поля.Добавить("ДатаНачалаСоревнования");
        
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)

    СтандартнаяОбработка = Ложь;
	
	// {Рарус adilas #8400 -После согласования убрать дату в пердставлении 2020.08.17
	//
	Представление = Данные.Соревнование.Наименование; //+ " " + Формат(Данные.ДатаПроведения, "ДФ=dd.MM.yyyy");
	
	// }Рарус adilas #8400 -После согласования убрать дату в пердставлении 2020.08.17
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	
	Отказ = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка"          			, ДокументСсылка);
	Запрос.УстановитьПараметр("Дата"            			, ДокументСсылка.Дата);
	// {Рарус adilas #11621 -Интервал периода соревнований в протоколе 2020.12.14
	Запрос.УстановитьПараметр("ДатаНачалаСоревнования"      , ДокументСсылка.ДатаНачалаСоревнования);
	Запрос.УстановитьПараметр("ДатаОкончанияСоревнования"   , ДокументСсылка.ДатаОкончанияСоревнования);
	// }Рарус adilas #11621 -Интервал периода соревнований в протоколе 2020.12.14
	Запрос.УстановитьПараметр("УчебныйГод"      			, ДокументСсылка.УчебныйГод);
	Запрос.УстановитьПараметр("Организация"     			, ДокументСсылка.Организация);
	Запрос.УстановитьПараметр("Соревнование"    			, ДокументСсылка.Соревнование);
	Запрос.УстановитьПараметр("ВидСпорта"       			, ДокументСсылка.ВидСпорта);
	Запрос.УстановитьПараметр("МестоПроведения" 			, ДокументСсылка.МестоПроведения);
	Запрос.Текст =  "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                |	""УчастникиСоревнований"" КАК ИмяРегистра_,
	                |	&Дата КАК Период,
	                |	&УчебныйГод КАК УчебныйГод,
	                |	&Организация КАК Организация,
	                |	&Соревнование КАК Соревнование,
	                |	&ВидСпорта КАК ВидСпорта,
	                |	СоревнованиеСоставУчастников.Спортсмен КАК Спортсмен,
	                |	СоревнованиеСоставУчастников.МеждународнаяВозрастнаяГруппа КАК МеждународнаяВозрастнаяГруппа,
	                |	&МестоПроведения КАК МестоПроведения,
	                |	СоревнованиеСоставУчастников.Тренер КАК Тренер,
	                |	СоревнованиеСоставУчастников.Команда КАК Команда,
	                |	&ДатаОкончанияСоревнования КАК ДатаОкончанияСоревнования,
	                |	&ДатаНачалаСоревнования КАК ДатаНачалаСоревнования,
					// {Рарус adilas #18019 -Дисциплины 2021.07.07
	                |	СоревнованиеСоставУчастников.Дисциплина КАК Дисциплина
					// }Рарус adilas #18019 -Дисциплины 2021.07.07
	                |ИЗ
	                |	Документ.Соревнование.СоставУчастников КАК СоревнованиеСоставУчастников
	                |ГДЕ
	                |	СоревнованиеСоставУчастников.Ссылка = &Ссылка";
	
	
	ТаблицаУчастникиСоревнований = Запрос.Выполнить().Выгрузить();
	
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ТаблицыДляДвижений.Вставить("ТаблицаУчастникиСоревнований" , ТаблицаУчастникиСоревнований);
	
    ДополнительныеСвойства.Вставить("Отказ", Отказ);
	
КонецПроцедуры	

Процедура ВыполнитьКонтрольРезультатовПроведения(Объект, Отказ) Экспорт
	
	Если Ложь Тогда
		Объект = Документы.Соревнование.СоздатьДокумент();
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьКонтрольПередПроведением(Объект, Отказ) Экспорт
	
	Если Ложь Тогда
		Объект = Документы.Соревнование.СоздатьДокумент();
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьКонтрольРезультатовОтменыПроведения(Объект, Отказ) Экспорт
	
	Если Ложь Тогда
		Объект = Документы.Соревнование.СоздатьДокумент();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти