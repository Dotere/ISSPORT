
#Область ОбработчикиСобытийРеквизитовШапки

&НаКлиенте
Процедура ФИОПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ФИО) Тогда				
		МассивФИО = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СокрЛП(ФИО)," ");		
		Если МассивФИО.количество() = 3 Тогда 
			Для Каждого Слово из МассивФИО Цикл
				Индекс = МассивФИО.Найти(Слово);
				Если Индекс > 2 Тогда
					Возврат;
				КонецЕсли;		
				ДобавитьКОтборуФИО(Индекс, Слово);
			КонецЦикла;
		Иначе
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ТаблицаНайденныхФизическихЛиц,"Наименование",ФИО,ВидСравненияКомпоновкиДанных.Содержит,,Истина);
		КонецЕсли;
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(ТаблицаНайденныхФизическихЛиц,"Фамилия");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(ТаблицаНайденныхФизическихЛиц,"Имя");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(ТаблицаНайденныхФизическихЛиц,"Отчество");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(ТаблицаНайденныхФизическихЛиц,"Наименование");
		
	КонецЕсли;
	 
КонецПроцедуры

&НаКлиенте
Процедура ДатаРожденияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ДатаРождения) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ТаблицаНайденныхФизическихЛиц,"ДатаРождения",ДатаРождения,ВидСравненияКомпоновкиДанных.Равно,,Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(ТаблицаНайденныхФизическихЛиц,"ДатаРождения");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НомерТелефонаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(НомерТелефона) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ТаблицаНайденныхФизическихЛиц,"НомерТелефона",НомерТелефона,ВидСравненияКомпоновкиДанных.Содержит,,Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(ТаблицаНайденныхФизическихЛиц,"НомерТелефона");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьКОтборуФИО(Индекс, Слово)
	
	Если Индекс = 0 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ТаблицаНайденныхФизическихЛиц,"Фамилия",Слово,ВидСравненияКомпоновкиДанных.Содержит,,Истина);
	ИначеЕсли Индекс = 1 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ТаблицаНайденныхФизическихЛиц,"Имя",Слово,ВидСравненияКомпоновкиДанных.Содержит,,Истина);
	ИначеЕсли Индекс = 2 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ТаблицаНайденныхФизическихЛиц,"Отчество",Слово,ВидСравненияКомпоновкиДанных.Содержит,,Истина);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыФормыФизлиц(Имя, Параметр)
	ТаблицаНайденныхФизическихЛиц.Параметры.УстановитьЗначениеПараметра(Имя, Параметр);
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Результат = ВыбранноеЗначение;
	Иначе
		Результат = ЭтаФорма.Элементы.ТаблицаНайденныхФизическихЛиц.текущиеданные.Ссылка;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Результат) Тогда 
	
		Оповещение = Новый ОписаниеОповещения("ВыбратьЗавершение", ЭтотОбъект, Новый Структура("Результат",Результат));
		
		ПоказатьВопрос(Оповещение,
		"Изменить физическое лицо?",
        РежимДиалогаВопрос.ДаНет,
        0,
        КодВозвратаДиалога.Да);
		Возврат;
	
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗавершение(Результат, Параметры) Экспорт  
	Если Результат = КодВозвратаДиалога.Да Тогда
		Закрыть(Параметры.Результат);
	Иначе
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНайденныхФизическихЛицВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ВыбранноеЗначение = ВыбраннаяСтрока;
КонецПроцедуры

#КонецОбласти