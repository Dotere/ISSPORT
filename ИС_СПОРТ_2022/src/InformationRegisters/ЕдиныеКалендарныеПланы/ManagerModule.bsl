#Область ПечатьWord

	

#КонецОбласти

#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт 
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЕКПТабДок") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ЕКПТабДок", "ЕКП", СформироватьПечатнуюФормуЕКП(МассивОбъектов));
		
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуЕКП(МассивОбъектовДляПечати) Экспорт
	
	Если ТипЗнч(МассивОбъектовДляПечати) = Тип("Массив") Тогда
		
		МассивОбъектов = МассивОбъектовДляПечати;
		
	Иначе
		
		МассивОбъектов = Новый Массив;
		МассивОбъектов.Добавить(МассивОбъектовДляПечати);
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЕКПСрезПоследних.ВидСпорта КАК ВидСпорта,
		|	ЕКПСрезПоследних.Соревнование КАК Соревнование,
		|	ЕКПСрезПоследних.НаименованиеОрганизаторов КАК НаименованиеОрганизаторов,
		|	ЕКПСрезПоследних.Организация КАК Организация,
		|	ЕКПСрезПоследних.КоличествоУчастников КАК КоличествоУчастников,
		|	ЕКПСрезПоследних.КоличествоТренеров КАК КоличествоТренеров,
		|	ЕКПСрезПоследних.Финансирование КАК Финансирование,
		|	ЕКПСрезПоследних.МестоПроведения КАК МестоПроведения,
		|	ЕКПСрезПоследних.ДатаНачала КАК ДатаНачала,
		|	ЕКПСрезПоследних.ДатаОкончания КАК ДатаОкончания
		|ИЗ
		|	РегистрСведений.ЕКП.СрезПоследних КАК ЕКПСрезПоследних";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
КонецФункции
	
#КонецОбласти