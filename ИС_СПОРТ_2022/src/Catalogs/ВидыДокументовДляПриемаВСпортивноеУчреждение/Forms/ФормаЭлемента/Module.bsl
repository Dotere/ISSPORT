
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ПараметрыСеанса.ТекущаяОрганизация.Пустая() Тогда
		Элементы.Организация.Видимость = Истина;
	Иначе
		Элементы.Организация.Видимость = Ложь;
		Объект.Организация = ПараметрыСеанса.ТекущаяОрганизация;
	КонецЕсли
КонецПроцедуры
