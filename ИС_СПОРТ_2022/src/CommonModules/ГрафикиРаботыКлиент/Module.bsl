///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Процедура сдвигает только что отредактированную строку в коллекции 
// таким образом, чтобы строки коллекции оставались упорядоченными.
//
// Параметры:
//	КоллекцияСтрок - Массив, ДанныеФормыКоллекция, ТаблицаЗначений -
//	ПолеУпорядочивания - имя поля элемента коллекции, 
//		по которому производится упорядочивание.
//	ТекущаяСтрока - отредактированная строка коллекции.
//
Процедура ВосстановитьПорядокСтрокКоллекцииПослеРедактирования(КоллекцияСтрок, ПолеУпорядочивания, ТекущаяСтрока) Экспорт
	
	Если КоллекцияСтрок.Количество() < 2 Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущаяСтрока[ПолеУпорядочивания]) <> Тип("Дата") 
		И Не ЗначениеЗаполнено(ТекущаяСтрока[ПолеУпорядочивания]) Тогда
		Возврат;
	КонецЕсли;
	
	ИндексИсходный = КоллекцияСтрок.Индекс(ТекущаяСтрока);
	ИндексРезультат = ИндексИсходный;
	
	// Выбираем направление, в котором нужно сдвинуть.
	Направление = 0;
	Если ИндексИсходный = 0 Тогда
		// вниз
		Направление = 1;
	КонецЕсли;
	Если ИндексИсходный = КоллекцияСтрок.Количество() - 1 Тогда
		// вверх
		Направление = -1;
	КонецЕсли;
	
	Если Направление = 0 Тогда
		Если КоллекцияСтрок[ИндексИсходный][ПолеУпорядочивания] > КоллекцияСтрок[ИндексРезультат + 1][ПолеУпорядочивания] Тогда
			// вниз
			Направление = 1;
		КонецЕсли;
		Если КоллекцияСтрок[ИндексИсходный][ПолеУпорядочивания] < КоллекцияСтрок[ИндексРезультат - 1][ПолеУпорядочивания] Тогда
			// вверх
			Направление = -1;
		КонецЕсли;
	КонецЕсли;
	
	Если Направление = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если Направление = 1 Тогда
		// Сдвигать нужно пока значение в текущей строке больше, чем в следующей.
		Пока ИндексРезультат < КоллекцияСтрок.Количество() - 1 
			И КоллекцияСтрок[ИндексИсходный][ПолеУпорядочивания] > КоллекцияСтрок[ИндексРезультат + 1][ПолеУпорядочивания] Цикл
			ИндексРезультат = ИндексРезультат + 1;
		КонецЦикла;
	Иначе
		// Сдвигать нужно пока значение в текущей строке меньше, чем в предыдущей.
		Пока ИндексРезультат > 0 
			И КоллекцияСтрок[ИндексИсходный][ПолеУпорядочивания] < КоллекцияСтрок[ИндексРезультат - 1][ПолеУпорядочивания] Цикл
			ИндексРезультат = ИндексРезультат - 1;
		КонецЦикла;
	КонецЕсли;
	
	КоллекцияСтрок.Сдвинуть(ИндексИсходный, ИндексРезультат - ИндексИсходный);
	
КонецПроцедуры

// Пересоздает фиксированное соответствие, вставляя в него указанное значение.
//
Процедура ВставитьВФиксированноеСоответствие(ФиксированноеСоответствие, Ключ, Значение) Экспорт
	
	Соответствие = Новый Соответствие(ФиксированноеСоответствие);
	Соответствие.Вставить(Ключ, Значение);
	ФиксированноеСоответствие = Новый ФиксированноеСоответствие(Соответствие);
	
КонецПроцедуры

// Удаляет из фиксированного соответствия значение по указанному ключу.
//
Процедура УдалитьИзФиксированногоСоответствия(ФиксированноеСоответствие, Ключ) Экспорт
	
	Соответствие = Новый Соответствие(ФиксированноеСоответствие);
	Соответствие.Удалить(Ключ);
	ФиксированноеСоответствие = Новый ФиксированноеСоответствие(Соответствие);
	
КонецПроцедуры

#КонецОбласти
