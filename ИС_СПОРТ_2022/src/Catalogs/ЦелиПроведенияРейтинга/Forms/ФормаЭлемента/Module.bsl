
#Область ОбработчикиСобытий

// {Рарус adilas #18145 -Тестирование релиза Альфа СПОРТ 1.0.0.3. Рейтинги 2021.07.08
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Объект.Владелец) Тогда 
		Объект.Владелец = ПараметрыСеанса.ТекущаяОрганизация;
	КонецЕсли;
	
КонецПроцедуры
// }Рарус adilas #18145 -Тестирование релиза Альфа СПОРТ 1.0.0.3. Рейтинги 2021.07.08

#КонецОбласти