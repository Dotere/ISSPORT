// {Рарус ivaart IN-19101 Кадровая история тренеров. Обработка создания записи регистра 2021.08.19
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Отбор") тогда
		ОтборФормы = Параметры.Отбор;
	КонецЕсли;
	// {Рарус dotere #21989 -Скрывает колонку организации под методистом 2021.10.29
	Если ПараметрыСеанса.ТекущаяОрганизация.Пустая() Тогда
		Элементы.Организация.Видимость = Истина;
	Иначе
		Элементы.Организация.Видимость = Ложь;
	КонецЕсли
	// }Рарус dotere #21989 -Скрывает колонку организации под методистом 2021.10.29

КонецПроцедуры

&НаКлиенте
Процедура Создать(Команда)
	Если ПустаяСтрока(ОтборФормы) тогда
		ОтборФормы = новый Структура()
	КонецЕсли;
	ОткрытьФорму("РегистрСведений.КадровыеИсторииТренеров.Форма.ФормаЗаписи",ОтборФормы);
КонецПроцедуры
// }Рарус ivaart IN-19101 Кадровая история тренеров. Обработка создания записи регистра 2021.08.19
