#Область ПроведениеДокумента

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	
	Отказ = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =  "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                |	""КоличествоВидовСпортаТренеров"" КАК ИмяРегистра_,
	                |	УдалениеВидаСпортаВручную.ДатаУдаленияВидаСпорта КАК Период,
	                |	УдалениеВидаСпортаВручную.Организация КАК Организация,
	                |	УдалениеВидаСпортаВручную.Тренер КАК Тренер,
	                |	УдалениеВидаСпортаВручную.ВидСпорта КАК ВидСпорта,
	                |	1 КАК КоличествоТренеров,
	                |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	                |	УдалениеВидаСпортаВручную.ДатаУдаленияВидаСпорта КАК ДатаВидаСпорта
	                |ИЗ
	                |	Документ.УдалениеВидаСпортаВручную КАК УдалениеВидаСпортаВручную
	                |ГДЕ
	                |	УдалениеВидаСпортаВручную.Ссылка = &Ссылка";
	
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ТаблицыДляДвижений.Вставить("ТаблицаКоличествоВидовСпортаТренеров", Запрос.Выполнить().Выгрузить());
	
    ДополнительныеСвойства.Вставить("Отказ", Отказ);
	
КонецПроцедуры	

Процедура ВыполнитьКонтрольРезультатовПроведения(Объект, Отказ) Экспорт
	
	Если Ложь Тогда
		Объект = Документы.ВводВидаСпортаВручную.СоздатьДокумент();
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьКонтрольПередПроведением(Объект, Отказ) Экспорт
	
	Если Ложь Тогда
		Объект = Документы.ВводВидаСпортаВручную.СоздатьДокумент();
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьКонтрольРезультатовОтменыПроведения(Объект, Отказ) Экспорт
	
	Если Ложь Тогда
		Объект = Документы.ВводВидаСпортаВручную.СоздатьДокумент();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти