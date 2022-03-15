#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
		
	Если ОбменДанными.Загрузка Тогда
         Возврат;
    КонецЕсли;
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	УчетСпортсменовСервер.ЗаполнитьРеквизит(ЭтотОбъект, "Ответственный", ПараметрыСеанса.ТекущийПользователь);	
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// {Рарус adilas #15349 -Перевод спортсменов между группами 2021.07.29
	// Выполняем отчистку движений для корректной проверки при перепроведении
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	Движения.Записать();
	
	УчетСпортсменовСервер.ПроверитьСоставГруппыНаВозможностьПеревода(Ссылка, Отказ);
	// }Рарус adilas #15349 -Перевод спортсменов между группами 2021.07.29
	// {Рарус dotere #21339 -Проверка спортсмена на зачисление в спорт учереждение 2021.10.15
	ВыполнитьПроверкуПередПроведением(Отказ);
	Если Отказ Тогда
		Возврат
	КонецЕсли;
	// }Рарус dotere #21339 -Проверка спортсмена на зачисление в спорт учереждение 2021.10.15
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	ПроведениеСервер.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ, "СоставГруппы");
	ПроведениеСервер.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ, "ЛичныйТренерСпортсмена");

	Движения.Записать();

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);	
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	Движения.Записать();

	ПроведениеСервер.ВыполнитьКонтрольРезультатовОтменыПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ФормированиеГруппы") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, ,"Номер ,Дата , Ответственный, Комментарий, Группа, ТренерСборной");
		Спортсмены.Загрузить(ДанныеЗаполнения.Спортсмены.Выгрузить());
		СписокЛичныхТренеров.Загрузить(ДанныеЗаполнения.СписокЛичныхТренеров.Выгрузить());
		ДокументОснование       = ДанныеЗаполнения;
		ГруппаПредыдущая        = ДанныеЗаполнения.Группа;
		ТренерСборнойПредыдущий = ДанныеЗаполнения.ТренерСборной;
	КонецЕсли;	
	
КонецПроцедуры

// {Рарус adilas #18233 -Тестирование релиза Альфа СПОРТ 1.0.0.3. Приказ о переводе между группами 2021.07.08
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив();
	
	Если НЕ ЗначениеЗаполнено(ГруппаПредыдущая) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Текущая группа не заполнена'");
		Сообщение.Поле = "ГруппаПредыдущая";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		Отказ = Истина;
		НепроверяемыеРеквизиты.Добавить("ГруппаПредыдущая");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Группа) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Следующая группа не заполнена'");
		Сообщение.Поле = "Группа";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		Отказ = Истина;
		НепроверяемыеРеквизиты.Добавить("Группа");
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ТренерСборнойПредыдущий) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Тренер, от которого осуществляется перевод не заполнен'");
		Сообщение.Поле = "ТренерСборнойПредыдущий";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		Отказ = Истина;
		НепроверяемыеРеквизиты.Добавить("ТренерСборнойПредыдущий");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТренерСборной) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Тренер к которому осуществляется перевод не заполнен'");
		Сообщение.Поле = "ТренерСборной";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		Отказ = Истина;
		НепроверяемыеРеквизиты.Добавить("ТренерСборной");
	КонецЕсли;

	УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры
// }Рарус adilas #18233 -Тестирование релиза Альфа СПОРТ 1.0.0.3. Приказ о переводе между группами 2021.07.08

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// {Рарус adilas #18233 -Тестирование релиза Альфа СПОРТ 1.0.0.3. Приказ о переводе между группами 2021.07.08
Процедура УдалитьНепроверяемыеРеквизитыИзМассива(МассивРеквизитов, МассивНепроверяемыхРеквизитов) Экспорт
	
	Для Каждого ЭлементМассива Из МассивНепроверяемыхРеквизитов Цикл
		ЭлементМассива = МассивРеквизитов.Найти(ЭлементМассива);
		Если ЭлементМассива <> Неопределено Тогда
			МассивРеквизитов.Удалить(ЭлементМассива);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
// }Рарус adilas #18233 -Тестирование релиза Альфа СПОРТ 1.0.0.3. Приказ о переводе между группами 2021.07.08
// {Рарус dotere #21339 -Проверка спортсмена на зачисление в спорт учереждение 2021.10.15
Процедура ВыполнитьПроверкуПередПроведением(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ВидСпорта", ВидСпорта);
	   
	Запрос.Текст =  "ВЫБРАТЬ
	                |	ПереводСпортсменовМеждуГруппамиСпортсмены.Спортсмен КАК Спортсмен,
	                |	ПереводСпортсменовМеждуГруппамиСпортсмены.Ссылка.ВидСпорта КАК ВидСпорта
	                |ПОМЕСТИТЬ ВТ_Предв
	                |ИЗ
	                |	Документ.ПереводСпортсменовМеждуГруппами.Спортсмены КАК ПереводСпортсменовМеждуГруппамиСпортсмены
	                |ГДЕ
	                |	ПереводСпортсменовМеждуГруппамиСпортсмены.Ссылка = &Ссылка
	                |;
	                |
	                |////////////////////////////////////////////////////////////////////////////////
	                |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                |	СоставУчащихсяСпортивногоУчрежденияСрезПоследних.Спортсмен КАК Спортсмен,
	                |	СоставУчащихсяСпортивногоУчрежденияСрезПоследних.ВидСпорта КАК ВидСпорта,
	                |	ВТ_Предв.Спортсмен КАК СпортсменЗачисленияВГруппу,
	                |	ВТ_Предв.ВидСпорта КАК ВидСпортаЗачисленияВГруппу,
	                |	СоставУчащихсяСпортивногоУчрежденияСрезПоследних.ДатаОкончанияОбучения КАК ДатаОкончанияОбучения
	                |ИЗ
	                |	ВТ_Предв КАК ВТ_Предв
	                |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоставУчащихсяСпортивногоУчреждения.СрезПоследних КАК СоставУчащихсяСпортивногоУчрежденияСрезПоследних
	                |		ПО ВТ_Предв.Спортсмен = СоставУчащихсяСпортивногоУчрежденияСрезПоследних.Спортсмен
	                |			И ВТ_Предв.ВидСпорта = СоставУчащихсяСпортивногоУчрежденияСрезПоследних.ВидСпорта
	                |;
	                |
	                |////////////////////////////////////////////////////////////////////////////////
	                |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                |	СоставУчащихсяСпортивногоУчрежденияСрезПоследних.Спортсмен КАК Спортсмен
	                |ИЗ
	                |	РегистрСведений.СоставУчащихсяСпортивногоУчреждения.СрезПоследних КАК СоставУчащихсяСпортивногоУчрежденияСрезПоследних
	                |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Предв КАК ВТ_Предв
	                |		ПО СоставУчащихсяСпортивногоУчрежденияСрезПоследних.Спортсмен = ВТ_Предв.Спортсмен";
	
	Результат = Запрос.ВыполнитьПакет();
	ЗачисленныйСпортсмен = Результат[1].Выгрузить();
	СтруктураПоиска = Новый Структура("Спортсмен");
	Для Каждого ЗачисляемыйСпортсмен из ЗачисленныйСпортсмен Цикл
			ВидыСпортаСпортсмена = Результат[2].Выбрать();
			СтруктураПоиска.Спортсмен = ЗачисляемыйСпортсмен.СпортсменЗачисленияВГруппу;
			Если ВидыСпортаСпортсмена.НайтиСледующий(СтруктураПоиска) Тогда
				Если ЗачисляемыйСпортсмен.Спортсмен = null Тогда
					Отказ = Истина;
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Спортсмен %1 не зачислен(а) на вид спорта %2 в спортивном учреждении.'"),
						ЗачисляемыйСпортсмен.СпортсменЗачисленияВГруппу, ЗачисляемыйСпортсмен.ВидСпортаЗачисленияВГруппу);
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
				ИначеЕсли ЗачисляемыйСпортсмен.ДатаОкончанияОбучения <> Дата(1,1,1) Тогда
					Отказ = Истина;
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Спортсмен %1 был отчислен(а) из спортивного учреждения.'"),
						ЗачисляемыйСпортсмен.СпортсменЗачисленияВГруппу);
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
				КонецЕсли;
			Иначе
				Отказ = Истина;
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Спортсмен %1 не зачислен(а) в спортивное учреждение.'"),
						ЗачисляемыйСпортсмен.СпортсменЗачисленияВГруппу);
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			КонецЕсли;
	КонецЦикла
КонецПроцедуры
// }Рарус dotere #21339 -Проверка спортсмена на зачисление в спорт учереждение 2021.10.15
#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли








	
