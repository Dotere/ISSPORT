#Область ОбработчикиСобытий

// {Рарус adilas #18823 -Спортивные дисциплины 2021.07.29
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Владелец") и Не ПустаяСтрока(Параметры.Владелец) Тогда
		
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементОтбора.ПравоеЗначение = Параметры.Владелец;
		
 //{Рарус ivaart IN-19405 отбор по организации 2021.08.27		
	ИначеЕсли (Параметры.Отбор.Свойство("Владелец") И ПустаяСтрока(Параметры.Отбор.Владелец)) ИЛИ (Параметры.Свойство("Владелец") И ПустаяСтрока(Параметры.Владелец)) тогда 
		Организация = ПараметрыСеанса.ТекущаяОрганизация;
	
		Если Не ПустаяСтрока(Организация) ИЛИ Параметры.Свойство("Организация") тогда
			Организация = ?(Параметры.Свойство("Организация"), Параметры.Организация, Организация);
			
			ВидыСпорта.ЗагрузитьЗначения(ПолучитьРазрешенныеВидыСпорта(Организация));
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
	
&НаСервере
Функция ПолучитьРазрешенныеВидыСпорта(Организация)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ВидыСпорта.Ссылка КАК ВидСпорта
		|ИЗ
		|	Справочник.ВидыСпорта КАК ВидыСпорта
		|ГДЕ
		|	ВидыСпорта.Владелец = &Организация";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидСпорта");
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ВидыСпорта.Количество() тогда
		Список.Отбор.Элементы.Очистить();
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементОтбора.ПравоеЗначение = ВидыСпорта;
	КонецЕсли;
КонецПроцедуры
// }Рарус ivaart IN-19405 отбор по организации 2021.08.27
// }Рарус adilas #18823 -Спортивные дисциплины 2021.07.29
#КонецОбласти