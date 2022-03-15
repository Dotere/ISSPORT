#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// {Рарус adilas #23059 -РС Руководитель. Карточка спортсмена.Карточка тренера. 2021.12.13
	// {Рарус dotere #21842 -В методите поле ответственный недоступно 2020.11.06
	Если РольДоступна("ПолныеПрава") Тогда
		 Элементы.Ответственный.Доступность = Истина;
	Иначе 	 
		 Элементы.Ответственный.Доступность = Ложь;
	КонецЕсли;
	// }Рарус dotere #21842 -В методите поле ответственный недоступно 2020.11.06
	// }Рарус adilas #23059 -РС Руководитель. Карточка спортсмена.Карточка тренера. 2021.12.13
	
	Если Параметры.Свойство("УчебныйГод") Тогда
		Объект.УчебныйГод       = Параметры.УчебныйГод;
		Если НЕ РольДоступна("ПолныеПрава") Тогда
			Элементы.УчебныйГод.ТолькоПросмотр       = Истина;
		КонецЕсли;
	ИначеЕсли Параметры.Свойство("Спортсмен") Тогда
		СтрокаСпортсмен = Объект.Спортсмены.Добавить();
		СтрокаСпортсмен.Спортсмен = Параметры.Спортсмен;	
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		УчетСпортсменовСервер.ЗаполнитьНастройкиПоУмолчанию(Объект);
		УправлениеУчебнымГодомСсылка = УчетСпортсменовСервер.ПолучитьДокументТекущегоУчебногоГода();
	    Объект.УчебныйГод = УправлениеУчебнымГодомСсылка.УчебныйГод;
	Иначе
		УчетСпортсменовСервер.ЗаполнитьДокументУчебныйГод(ЭтотОбъект, Объект.УчебныйГод, Объект.Организация);	
	КонецЕсли;
	
	// {Рарус adilas #13392 -Номер документа 2021.02.12
	Если Пользователи.РолиДоступны("АдминистраторСистемы, ПолныеПрава") Тогда
		Элементы.Номер.Доступность = Истина;
		Элементы.Номер.ТолькоПросмотр = Ложь;
	КонецЕсли;
	
	// }Рарус adilas #13392 -Номер документа 2021.02.12
				
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Если ЗначениеЗаполнено(Объект.УчебныйГод) И ЭтоНовый Тогда
		Оповестить("ДополнитьТаблицуГрупп",Новый Структура("ДокументКоманда",Объект.Ссылка));
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Документ.ЗаявкаНаПроведениеСоревнования.Форма.ФормаЗаполненияПоГруппам" Тогда
		
		массивСтрокДляЗаполнения = Новый Массив;
		
		Для Каждого ВыбранныйУчастник Из ВыбранноеЗначение Цикл
			строкиТабличнойЧасти = Объект.Спортсмены.НайтиСтроки(Новый Структура("Спортсмен",ВыбранныйУчастник));
			Если НЕ строкиТабличнойЧасти.Количество() = 0 Тогда
				Продолжить;
			КонецЕсли;	
			строкаУчастник = Объект.Спортсмены.Добавить();
			строкаУчастник.Спортсмен   = ВыбранныйУчастник;
		КонецЦикла;
				
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти                                

#Область ОбработчикиСобытийРеквизитовШапки

&НаКлиенте
Процедура ОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Объект.СписокЛичныхТренеров.Количество()>0 Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Оповещение = Новый ОписаниеОповещения("ОрганизацияНачалоВыбораЗавершение",
		ЭтотОбъект);	
		
		ПоказатьВопрос(Оповещение,
		"Табличные части в документе будут очищены. 
		|Продолжить?",
		РежимДиалогаВопрос.ДаНет,
		0);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура УчебныйГодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	УчетСпортсменовКлиент.УчебныйГодНачалоВыбора(ЭтотОбъект,СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура УчебныйГодОткрытие(Элемент, СтандартнаяОбработка)
	УчетСпортсменовКлиент.УчебныйГодОткрытие(УправлениеУчебнымГодомСсылка,СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура УчебныйГодСоздание(Элемент, СтандартнаяОбработка)
	УчетСпортсменовКлиент.УчебныйГодСоздание(ЭтаФорма, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандНаФорме

&НаКлиенте
Процедура ПодобратьСпортсменов(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;	
	
	ПараметрыФормы = Новый Структура("СтруктураПараметров", Новый Структура("Организация, ТекущаяДата, Организация, УчебныйГод, ВидСпорта, ТренерСборной, Группа", 
	   Объект.Организация, Объект.Дата, Объект.Организация, Объект.УчебныйГод, Объект.ВидСпорта, Объект.ТренерСборнойПредыдущий, Объект.ГруппаПредыдущая));
	   
	ОткрытьФорму("Документ.ЗаявкаНаПроведениеСоревнования.Форма.ФормаЗаполненияПоГруппам", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТабличныхЧастей

#Область ОбработчикиСобытийЭлементовТаблицыФормыСпортсмены

&НаКлиенте
Процедура СпортсменыСпортсменНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	
	Если Объект.ДатаПеревода = Дата(1, 1, 1) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Укажите дату зачисления!'");
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Поле = "ДатаЗачисления";
		Сообщение.Сообщить();
		Возврат;	
	ИначеЕсли Не ЗначениеЗаполнено(Объект.Организация) Тогда 
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Укажите организацию!'");
	    Сообщение.ПутьКДанным = "Объект";
		Сообщение.Поле = "Организация";
		Сообщение.Сообщить();
		Возврат;
	Иначе
		ПараметрыФормы.Вставить("ДатаСреза", УчетСпортсменовВызовСервера.ТекущаяДатаНаСервере());
	    ПараметрыФормы.Вставить("Организация", Объект.Организация);
	КонецЕсли;

	ПараметрыФормы.Вставить("ТолькоВыбор", Истина);
	ОбработчикВыбора = Новый ОписаниеОповещения("СпортсменНачалоВыбораЗавершение", ЭтотОбъект);
		
	ОткрытьФорму("Справочник.Спортсмены.Форма.ФормаВыбораСоставУчащихся", ПараметрыФормы, ЭтаФорма, , , , ОбработчикВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура СпортсменыПослеУдаления(Элемент)
КонецПроцедуры

&НаКлиенте
Процедура СпортсменыСпортсменАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Возврат;
КонецПроцедуры

&НаКлиенте
Процедура СпортсменыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
КонецПроцедуры

&НаКлиенте
Процедура СпортсменыПередУдалением(Элемент, Отказ)
	
	ТекДанныеОбъектСпортсмен        = Элементы.Спортсмены.ТекущиеДанные;
	ОчиститьСтрокиСписокЛичныхТренеров(ТекДанныеОбъектСпортсмен.КлючСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура СпортсменыСпортсменПриИзменении(Элемент)
	
	ТекДанныеОбъектСпортсмен            = Элементы.Спортсмены.ТекущиеДанные;
	ТекДанныеОбъектСпортсмен.КлючСтроки = СокрЛП(ТекДанныеОбъектСпортсмен.Спортсмен.УникальныйИдентификатор());
		   
КонецПроцедуры

&НаКлиенте
Процедура СпортсменыПриАктивизацииСтроки(Элемент)
	
	ТекДанные = Элементы.Спортсмены.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекДанные.Спортсмен <> ТекущаяСтрокаСпортсмен Тогда
		УстановитьОтборНаТабличуюЧастьСписокЛичныхТренеров(ТекДанные.КлючСтроки);
		УстановитьТекущуюСтрокуТаблицыСпортсмены(ТекДанные.Спортсмен);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСпортсмены

&НаКлиенте
Процедура СписокЛичныхТренеровПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ТекДанныеОбъектСпортсмен = Элементы.Спортсмены.ТекущиеДанные;
	Если ТекДанныеОбъектСпортсмен = Неопределено Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не задана текущая строка!
		|Выберете строку в табличной части 'Список спортсменов'!",,"Спортсмены","Объект.Спортсмены");
	КонецЕсли;   
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЛичныхТренеровФизическоеЛицоПриИзменении(Элемент)
	
	ТекДанныеОбъектСпортсмен         = Элементы.Спортсмены.ТекущиеДанные;
	ТекДанныеЛичныйТренер            = Элементы.СписокЛичныхТренеров.ТекущиеДанные;
	ТекДанныеЛичныйТренер.КлючСтроки = ТекДанныеОбъектСпортсмен.КлючСтроки;	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЛичныхТренеровПослеУдаления(Элемент)
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОрганизацияНачалоВыбораЗавершение(Результат, ДопПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Объект.СписокЛичныхТренеров.Очистить();
		Объект.Спортсмены.Очистить();
		Элементы.ТренерСборной.СписокВыбора.Очистить();
		Объект.ТренерСборной = "";
		
		ОткрытьФорму("Справочник.Организации.ФормаВыбора",,Элементы.Организация);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекущуюСтрокуТаблицыСпортсмены(Спортсмен)
	
	ТекущаяСтрокаСпортсмен = Спортсмен;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборНаТабличуюЧастьСписокЛичныхТренеров(КлючСтроки)
	
	Элементы.СписокЛичныхТренеров.ОтборСтрок = Новый ФиксированнаяСтруктура("КлючСтроки",КлючСтроки);
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьСтрокиСписокЛичныхТренеров(КлючСтроки)
	
	массивСтрокСписокЛичныхТренеров = Объект.СписокЛичныхТренеров.НайтиСтроки(Новый Структура("КлючСтроки",КлючСтроки));
	Для Каждого СтрокаЛичныйТренер Из массивСтрокСписокЛичныхТренеров Цикл
		Объект.СписокЛичныхТренеров.Удалить(СтрокаЛичныйТренер);
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Функция ПроверитьНаличиеДанныхПоСтрокеСпортсмена(КлючСтроки)
	массивСтрокСписокЛичныхТренеров = Объект.СписокЛичныхТренеров.НайтиСтроки(Новый Структура("КлючСтроки", КлючСтроки));
	Возврат ?(массивСтрокСписокЛичныхТренеров.Количество() = 0, Ложь, Истина);
КонецФункции		

&НаСервере
Процедура ЗаполнитьДанныеПоИсключеннымСпортсменам()
	
	тзИсключенныхСпортсменов = РеквизитФормыВЗначение("Объект").ПолучитьДанныеПоИсключеннымИзГруппыСпортсменам();
	Для Каждого строкаИсключенных Из тзИсключенныхСпортсменов Цикл
		Объект.Спортсмены[строкаИсключенных.НомерСтроки-1].ИсключенИзГруппы = "исключен " + Формат(строкаИсключенных.ДатаИсключенияИзГруппы,"ДЛФ=Д");
	КонецЦикла;	
	
КонецПроцедуры	

&НаКлиенте
Процедура УчебныйГодСозданиеЗавершение(Результат, ДопПараметры) Экспорт
	
	Если НЕ Результат = Неопределено Тогда
	   Объект.УчебныйГод = Результат.УчебныйГодСсылка;
	   УправлениеУчебнымГодомСсылка = Результат.УчебныйГодОбъект;
	КонецЕсли;   
	
КонецПроцедуры

&НаКлиенте
Процедура УчебныйГодНачалоВыбораЗавершение(Результат, ДопПараметры) Экспорт
	
	УправлениеУчебнымГодомСсылка = Результат;
    ПолучитьУчебныйГодСсылка();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьУчебныйГодСсылка()
	Объект.УчебныйГод = УправлениеУчебнымГодомСсылка.УчебныйГод;
КонецПроцедуры	
// {Рарус dotere #21339 -Добавление выбранного спортсмена в таб часть 2021.10.18
&НаКлиенте
Процедура СпортсменНачалоВыбораЗавершение(Результат, ДопПараметры) Экспорт
	Если Не Результат = Неопределено Тогда
		 Строка = Объект.Спортсмены.НайтиПоИдентификатору(Элементы.Спортсмены.ТекущаяСтрока);
		 Строка.Спортсмен = Результат.Спортсмен;
	КонецЕсли
КонецПроцедуры
// }Рарус dotere #21339 -Добавление выбранного спортсмена в таб часть 2021.10.18
#КонецОбласти