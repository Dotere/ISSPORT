#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура УстановкаПараметровСеанса(ИменаПараметровСеанса)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыСервер.УстановкаПараметровСеанса(ИменаПараметровСеанса);
	// Конец СтандартныеПодсистемы
	
	Если ТипЗнч(ИменаПараметровСеанса) = Тип("Массив") Тогда
  		Для каждого ИмяПараметра Из ИменаПараметровСеанса Цикл
			Попытка
				ПростоПеременная = ПараметрыСеанса[ИмяПараметра];
			Исключение
				ПараметрыСеанса[ИмяПараметра] = Метаданные.ПараметрыСеанса[ИмяПараметра].Тип.ПривестиЗначение();
			КонецПопытки;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли