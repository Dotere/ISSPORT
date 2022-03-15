
&НаКлиенте
Процедура СметаКоличествоПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Смета.ТекущиеДанные;
    СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.Цена * СтрокаТабличнойЧасти.КоличествоДней;
	Объект.ОбщаяСумма = Объект.Смета.Итог("Сумма");
КонецПроцедуры

&НаКлиенте
Процедура СметаЦенаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Смета.ТекущиеДанные;
    СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.Цена * СтрокаТабличнойЧасти.КоличествоДней;
	Объект.ОбщаяСумма = Объект.Смета.Итог("Сумма");
КонецПроцедуры

&НаКлиенте
Процедура СметаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока И Не Копирование Тогда
        Элемент.ТекущиеДанные.Количество = Объект.Спортсмены.Количество() + Объект.Тренеры.Количество(); 
		РазницаВДнях = (НачалоДня(Объект.ДатаВозвращения) - НачалоДня(Объект.ДатаВыезда)) / (60 * 60 * 24);
		Если РазницаВДнях < 1 Тогда
			Элемент.ТекущиеДанные.КоличествоДней = 1;
		Иначе
			Элемент.ТекущиеДанные.КоличествоДней = РазницаВДнях;
		КонецЕсли
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// {Рарус adilas #23059 -РС Руководитель. Карточка спортсмена.Карточка тренера. 2021.12.13
	// {Рарус dotere #21842 -В методите поле ответственный недоступно  2020.11.06
	Если РольДоступна("ПолныеПрава") Тогда
		 Элементы.Ответственный.Доступность = Истина;
	Иначе 	 
		  Элементы.Ответственный.Доступность = Ложь;
	КонецЕсли;
	// }Рарус dotere #21842 -В методите поле ответственный недоступно 2020.11.06
	// }Рарус adilas #23059 -РС Руководитель. Карточка спортсмена.Карточка тренера. 2021.12.13
	
	Если ПараметрыСеанса.ТекущаяОрганизация.Пустая() Тогда
		Элементы.Организация.Видимость = Истина;
	Иначе
		Объект.Организация = ПараметрыСеанса.ТекущаяОрганизация; 
		Элементы.Организация.Видимость = Ложь;
	КонецЕсли;
	Если Параметры.Свойство("Cоревнование") Тогда
		Объект.Соревнование = Параметры.Cоревнование;
		Объект.Организация = Параметры.Организация;
		Объект.ВидСпорта = Параметры.ВидСпорта;
		Объект.МестоПроведения = Параметры.МестоПроведения;
		Объект.НомерСоревнования = Параметры.НомерСоревнования;
		Объект.ДатаВозвращения = Параметры.ДатаВозвращения;
		Объект.ДатаВыезда = Параметры.ДатаВыезда;
		Объект.Город = Параметры.Город;
		Объект.Финансирование = Параметры.Финансирование;
		Объект.ОснованиеВыезда = Параметры.Основание;

	КонецЕсли;
	ЗаполнитьПериод();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПериод()
	
	ПериодВыезда.ДатаНачала = Объект.ДатаВыезда;
	ПериодВыезда.ДатаОкончания = Объект.ДатаВозвращения;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если Объект.ДатаВыезда > Объект.ДатаВозвращения Тогда
		Отказ = Истина;
	ИначеЕсли Объект.ДатаВозвращения = Дата(1,1,1) Тогда
		Объект.ДатаВозвращения = Объект.ДатаВыезда;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТренерыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока И Не Копирование Тогда
        Элемент.ТекущиеДанные.ДатаВыездаТренера = Объект.ДатаВыезда;
		Элемент.ТекущиеДанные.ДатаВозвращенияТренера = Объект.ДатаВозвращения; 
    КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПериодВыездаПриИзменении(Элемент)
	Объект.ДатаВыезда = ПериодВыезда.ДатаНачала;
	Объект.ДатаВозвращения = ПериодВыезда.ДатаОкончания;
КонецПроцедуры

&НаКлиенте
Процедура СметаКоличествоДнейПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Смета.ТекущиеДанные;
    СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.Цена * СтрокаТабличнойЧасти.КоличествоДней;
	Объект.ОбщаяСумма = Объект.Смета.Итог("Сумма");
КонецПроцедуры

&НаКлиенте
Процедура СпротсменыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	//Отказ = Истина;
	//Если Объект.ДатаВыезда = ДАТА(1,1,1) ИЛИ Объект.ВидСпорта.Пустая() ИЛИ Объект.Организация.Пустая() Тогда 
	//	Предупреждение();  
	//Иначе
	//	Параметр = новый Структура;
	//	Параметр.Вставить("ДатаСреза",Объект.ДатаВыезда);
	//	Параметр.Вставить("ТолькоВыбор",Истина);
	//	Параметр.Вставить("ВидСпорта",Объект.ВидСпорта);
	//	Параметр.Вставить("Организация",Объект.Организация);
	//	Оповещение = Новый ОписаниеОповещения("ОповещениеЗакрытия", ЭтотОбъект);
	//	ОткрытьФорму("Справочник.Спортсмены.Форма.ФормаВыбораСпортсменаПоУчреждению", Параметр, , , , ,Оповещение);
	//КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура Предупреждение()
	Если Объект.Организация.Пустая() Тогда
		ОбщегоНазначения.СообщитьПользователю("Заполните спортивное учереждение.");
	КонецЕсли;
	Если Объект.ВидСпорта.Пустая() Тогда
		ОбщегоНазначения.СообщитьПользователю("Заполните вид спорта.");
	КонецЕсли;
	Если ПериодВыезда.ДатаНачала = Дата(1,1,1) ИЛИ ПериодВыезда.ДатаОкончания = Дата(1,1,1) тогда
		ОбщегоНазначения.СообщитьПользователю("Заполнимте дату выезда.");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеЗакрытия(Результат, ДополнительныеПараметры) Экспорт
	
	 ОповещениеЗакрытияНаСервере(Результат, ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Процедура ОповещениеЗакрытияНаСервере(Результат, ДополнительныеПараметры) Экспорт
	Элементы.Спротсмены.ВыделенныеСтроки.Очистить();
	//Объект.Спортсмены.Удалить(Объект.Спортсмены.Количество()-1);
	Если НЕ Результат = Неопределено Тогда
		Параметр = новый Структура;
		Параметр.Вставить("Спортсмен",Результат.Спортсмен);
		Если Объект.Спортсмены.НайтиСтроки(Параметр).Количество() = 0 Тогда
			Объект.Спортсмены.Добавить();
			Строка = Объект.Спортсмены[Объект.Спортсмены.Количество()-1];
			Строка.Спортсмен = Результат.Спортсмен;
		Иначе
			ОбщегоНазначения.СообщитьПользователю("Спортсмен " + Результат.Спортсмен + " уже добавлен");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПодборСпортсменов(Команда)
	Если Объект.ДатаВыезда = ДАТА(1,1,1) ИЛИ Объект.ВидСпорта.Пустая() ИЛИ Объект.Организация.Пустая() Тогда 
		Предупреждение();  
	Иначе
		Параметр = новый Структура;
		Параметр.Вставить("ДатаСреза",Объект.ДатаВыезда);
		Параметр.Вставить("ТолькоВыбор",Истина);
		Параметр.Вставить("ВидСпорта",Объект.ВидСпорта);
		Параметр.Вставить("Организация",Объект.Организация);
		Оповещение = Новый ОписаниеОповещения("ОповещениеЗакрытия", ЭтотОбъект);
		ОткрытьФорму("Справочник.Спортсмены.Форма.ФормаВыбораСпортсменаПоУчреждению", Параметр, , , , ,Оповещение);
	КонецЕсли;

КонецПроцедуры
